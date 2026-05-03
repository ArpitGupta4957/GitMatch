import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';
import '../services/supabase_service.dart';

class NotificationProvider extends ChangeNotifier {
  final SupabaseClient _client = SupabaseService.client;
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  RealtimeChannel? _subscription;
  String? _userId;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get isLoading => _isLoading;

  void init(String userId) {
    if (_userId == userId) return;
    _userId = userId;
    _loadNotifications();
    _subscribeToNotifications();
  }

  void disposeProvider() {
    _subscription?.unsubscribe();
    _notifications.clear();
    _userId = null;
  }

  Future<void> _loadNotifications() async {
    if (_userId == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _client
          .from('notifications')
          .select()
          .eq('user_id', _userId!)
          .order('created_at', ascending: false);
      
      _notifications = (response as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void _subscribeToNotifications() {
    if (_userId == null) return;
    
    _subscription = _client
        .channel('public:notifications:user_id=eq.$_userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _userId!,
          ),
          callback: (payload) {
            final newNotification = NotificationModel.fromJson(payload.newRecord);
            _notifications.insert(0, newNotification);
            notifyListeners();
          },
        )
        .subscribe();
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();

      try {
        await _client
            .from('notifications')
            .update({'is_read': true})
            .eq('id', notificationId);
      } catch (e) {
        debugPrint('Error marking notification as read: $e');
      }
    }
  }

  Future<void> markAllAsRead() async {
    if (_userId == null) return;
    
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();

    try {
      await _client
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', _userId!)
          .eq('is_read', false);
    } catch (e) {
      debugPrint('Error marking all as read: $e');
    }
  }
}
