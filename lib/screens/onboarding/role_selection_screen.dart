import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/animated_button.dart';
import 'interest_selection_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  final List<_RoleOption> _roles = [
    _RoleOption(
      id: 'student',
      title: 'Student',
      subtitle: 'Learning and exploring new technologies',
      icon: Icons.school,
    ),
    _RoleOption(
      id: 'professional',
      title: 'Working Professional',
      subtitle: 'Building products and contributing to open source',
      icon: Icons.work,
    ),
    _RoleOption(
      id: 'mentor',
      title: 'Mentor',
      subtitle: 'Guiding and supporting other developers',
      icon: Icons.psychology,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: AppColors.textWhite),
              ),
              const SizedBox(height: 32),

              const Text(
                'Select Your Role',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This helps us personalize your experience',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

              ...(_roles.map((role) => _buildRoleCard(role))),

              const Spacer(),

              AnimatedButton(
                label: 'Continue',
                onPressed: _selectedRole != null
                    ? () {
                        final auth = context.read<AuthProvider>();
                        if (auth.user != null) {
                          auth.updateProfile(
                            auth.user!.copyWith(role: _selectedRole),
                          );
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const InterestSelectionScreen(),
                          ),
                        );
                      }
                    : () {},
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(_RoleOption role) {
    final isSelected = _selectedRole == role.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.secondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent.withValues(alpha: 0.2)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                role.icon,
                color: isSelected ? AppColors.accent : AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.accent, size: 24),
          ],
        ),
      ),
    );
  }
}

class _RoleOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  _RoleOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
