import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textWhite),
        ),
        actions: [
          if (provider.notifications.isNotEmpty)
            TextButton(
              onPressed: () => context.read<NotificationProvider>().markAllAsRead(),
              child: const Text(
                'Mark all read',
                style: TextStyle(color: AppColors.accent),
              ),
            ),
        ],
        iconTheme: const IconThemeData(color: AppColors.textWhite),
      ),
      body: provider.isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : provider.notifications.isEmpty
              ? const Center(
                  child: Text(
                    'No notifications yet.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              : ListView.separated(
                  itemCount: provider.notifications.length,
                  separatorBuilder: (context, index) => const Divider(color: AppColors.cardBorder, height: 1),
                  itemBuilder: (context, index) {
                    final notif = provider.notifications[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      onTap: () {
                        if (!notif.isRead) {
                          context.read<NotificationProvider>().markAsRead(notif.id);
                        }
                      },
                      tileColor: notif.isRead ? Colors.transparent : AppColors.surface,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                        child: Icon(
                          notif.type.contains('mentor') ? Icons.school : Icons.emoji_events,
                          color: AppColors.accent,
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notif.title,
                            style: TextStyle(
                              fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                              color: AppColors.textWhite,
                            ),
                          ),
                          Text(
                            _formatDate(notif.createdAt),
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          notif.body,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
