import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/saved_provider.dart';
import 'edit_profile_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.user;
        if (user == null) {
          return const Center(child: Text('Not logged in', style: TextStyle(color: AppColors.textSecondary)));
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    const Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textWhite)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.settings, color: AppColors.textSecondary),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Avatar
                CircleAvatar(radius: 50, backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                  child: Text(user.displayName?[0] ?? user.username[0], style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: AppColors.accent))),
                const SizedBox(height: 16),
                Text(user.displayName ?? user.username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textWhite)),
                Text('@${user.username}', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                if (user.bio != null) ...[
                  const SizedBox(height: 12),
                  Text(user.bio!, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.5)),
                ],
                const SizedBox(height: 24),

                // Stats
                Consumer<SavedProvider>(builder: (context, sp, _) {
                  return Row(children: [
                    _Stat('Saved', '${sp.totalSaved}'),
                    const SizedBox(width: 12),
                    _Stat('Skills', '${user.skills.length}'),
                    const SizedBox(width: 12),
                    _Stat('Interests', '${user.interests.length}'),
                  ]);
                }),
                const SizedBox(height: 24),

                // Skills
                _Section(title: 'Skills', child: Wrap(spacing: 8, runSpacing: 8, children: user.skills.map((s) => _Chip(s)).toList())),
                const SizedBox(height: 16),

                // Interests
                _Section(title: 'Interests', child: Wrap(spacing: 8, runSpacing: 8, children: user.interests.map((i) => _Chip(i)).toList())),
                const SizedBox(height: 16),

                // Modes
                _Section(title: 'Active Modes', child: Column(children: [
                  _Toggle('Hackathon Mode', Icons.emoji_events, user.hackathonMode, (v) => auth.updateProfile(user.copyWith(hackathonMode: v))),
                  _Toggle('Mentorship Mode', Icons.school, user.mentorshipMode, (v) => auth.updateProfile(user.copyWith(mentorshipMode: v))),
                ])),
                const SizedBox(height: 24),

                // Edit & Sign out
                SizedBox(width: double.infinity, child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Edit Profile'),
                )),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: OutlinedButton(
                  onPressed: () {
                    auth.signOut();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
                  },
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Sign Out'),
                )),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
      child: Column(children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textWhite)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, letterSpacing: 1)),
      ]),
    ));
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textWhite)),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(100), border: Border.all(color: AppColors.cardBorder)),
      child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
    );
  }
}

class _Toggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle(this.label, this.icon, this.value, this.onChanged);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Icon(icon, color: value ? AppColors.accent : AppColors.textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: value ? AppColors.textWhite : AppColors.textSecondary))),
        Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.accent),
      ]),
    );
  }
}
