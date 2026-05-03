import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../widgets/animated_button.dart';
import '../feeds/hackathon_feed_screen.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/feed_provider.dart';
import '../../providers/swipe_provider.dart';
import '../../providers/saved_provider.dart';
import '../../providers/auth_provider.dart';

class HackathonFilterScreen extends StatefulWidget {
  const HackathonFilterScreen({super.key});

  @override
  State<HackathonFilterScreen> createState() => _HackathonFilterScreenState();
}

class _HackathonFilterScreenState extends State<HackathonFilterScreen> {
  String _selectedRole = 'Any';
  final List<String> _roles = ['Any', 'Frontend', 'Backend', 'Fullstack', 'UI/UX', 'AI/ML'];

  String _availability = 'Upcoming';
  final List<String> _availabilities = ['Any', 'Live Now', 'Upcoming', 'Registration Open'];

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedRole = prefs.getString('hack_role') ?? 'Any';
      _availability = prefs.getString('hack_status') ?? 'Upcoming';
    });
  }

  Future<void> _saveFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hack_role', _selectedRole);
    await prefs.setString('hack_status', _availability);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text('Hackathon Matches', style: AppTextStyles.heading3),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preferred Role', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: _roles.map((role) {
                return ChoiceChip(
                  label: Text(role),
                  selected: _selectedRole == role,
                  onSelected: (val) {
                    if (val) setState(() => _selectedRole = role);
                  },
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.accent,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            
            Text('Event Status', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _availabilities.map((status) {
                return ChoiceChip(
                  label: Text(status),
                  selected: _availability == status,
                  onSelected: (val) {
                    if (val) setState(() => _availability = status);
                  },
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.accent,
                );
              }).toList(),
            ),
            const SizedBox(height: 48),

            AnimatedButton(
              label: 'Find Teammates',
              onPressed: () async {
                await _saveFilters();

                final swipeProvider = context.read<SwipeProvider>();
                final savedProvider = context.read<SavedProvider>();
                final selfId = context.read<AuthProvider>().user?.id;
                final excludeIds = <String>{};
                excludeIds.addAll(swipeProvider.swipes.map((s) => s.itemId));
                excludeIds.addAll(savedProvider.savedItems.map((s) => s.itemId));

                context.read<FeedProvider>().loadHackathons(
                  role: _selectedRole == 'Any' ? null : _selectedRole,
                  status: _availability == 'Any' ? null : _availability,
                  excludeIds: excludeIds,
                  selfId: selfId,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HackathonFeedScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
