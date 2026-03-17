import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/animated_button.dart';
import '../home/home_dashboard.dart';

class TechStackSelectionScreen extends StatefulWidget {
  const TechStackSelectionScreen({super.key});

  @override
  State<TechStackSelectionScreen> createState() =>
      _TechStackSelectionScreenState();
}

class _TechStackSelectionScreenState extends State<TechStackSelectionScreen> {
  final Set<String> _selected = {};

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
                'Select Your Tech Stack',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose technologies you work with',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: AppStrings.techOptions.map((tech) {
                      final isSelected = _selected.contains(tech);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selected.remove(tech);
                            } else {
                              _selected.add(tech);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent.withValues(alpha: 0.15)
                                : AppColors.secondary,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accent
                                  : AppColors.cardBorder,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) ...[
                                const Icon(
                                  Icons.check,
                                  color: AppColors.accent,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                              ],
                              Text(
                                tech,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              AnimatedButton(
                label: AppStrings.getStarted,
                onPressed: _selected.isNotEmpty
                    ? () {
                        final auth = context.read<AuthProvider>();
                        if (auth.user != null) {
                          auth.updateProfile(
                            auth.user!.copyWith(skills: _selected.toList()),
                          );
                        }
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const HomeDashboard(),
                          ),
                          (route) => false,
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
