import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/animated_button.dart';
import 'tech_stack_selection_screen.dart';

class InterestSelectionScreen extends StatefulWidget {
  const InterestSelectionScreen({super.key});

  @override
  State<InterestSelectionScreen> createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  final Set<String> _selected = {};

  final List<_InterestOption> _interests = [
    _InterestOption(
      id: 'Open Source',
      title: 'Open Source',
      subtitle: 'Contribute to open-source projects',
      icon: Icons.code,
    ),
    _InterestOption(
      id: 'Hackathons',
      title: 'Hackathons',
      subtitle: 'Compete in coding challenges and hackathons',
      icon: Icons.emoji_events,
    ),
    _InterestOption(
      id: 'Mentorship',
      title: 'Mentorship',
      subtitle: 'Learn from or guide other developers',
      icon: Icons.school,
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
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: AppColors.textWhite),
              ),
              const SizedBox(height: 32),

              const Text(
                'Select Your Interests',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose what you\'re most excited about',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

              ...(_interests.map((interest) {
                final isSelected = _selected.contains(interest.id);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selected.remove(interest.id);
                      } else {
                        _selected.add(interest.id);
                      }
                    });
                  },
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
                            interest.icon,
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
                                interest.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.textWhite
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                interest.subtitle,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle,
                              color: AppColors.accent, size: 24),
                      ],
                    ),
                  ),
                );
              })),

              const Spacer(),

              AnimatedButton(
                label: 'Continue',
                onPressed: _selected.isNotEmpty
                    ? () {
                        final auth = context.read<AuthProvider>();
                        if (auth.user != null) {
                          auth.updateProfile(
                            auth.user!.copyWith(interests: _selected.toList()),
                          );
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TechStackSelectionScreen(),
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
}

class _InterestOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  _InterestOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
