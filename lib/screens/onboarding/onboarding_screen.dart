import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/spacing.dart';
import '../../widgets/animated_button.dart';
import 'role_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      icon: Icons.code,
      secondaryIcons: [Icons.settings, Icons.device_hub, Icons.call_split],
      title: AppStrings.findNextProject,
      description: AppStrings.findNextProjectDesc,
      featureIcon: Icons.filter_list,
      featureTitle: AppStrings.smartFilters,
      featureDescription: AppStrings.smartFiltersDesc,
    ),
    _OnboardingPage(
      icon: Icons.people,
      secondaryIcons: [Icons.group_add, Icons.handshake, Icons.diversity_3],
      title: AppStrings.findTeammates,
      description: AppStrings.findTeammatesDesc,
      featureIcon: Icons.groups,
      featureTitle: AppStrings.teamMatching,
      featureDescription: AppStrings.teamMatchingDesc,
    ),
    _OnboardingPage(
      icon: Icons.school,
      secondaryIcons: [Icons.lightbulb, Icons.trending_up, Icons.star],
      title: AppStrings.findMentors,
      description: AppStrings.findMentorsDesc,
      featureIcon: Icons.workspace_premium,
      featureTitle: AppStrings.expertGuidance,
      featureDescription: AppStrings.expertGuidanceDesc,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      );
    }
  }

  void _skip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.terminal, color: AppColors.accent, size: 18),
                  ),
                  const Spacer(),
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 30),
                ],
              ),
            ),

            // Progress indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= _currentPage
                        ? AppColors.accent
                        : AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPage(page);
                },
              ),
            ),

            // Bottom buttons
            Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  AnimatedButton(
                    label: _currentPage < _pages.length - 1
                        ? AppStrings.nextStep
                        : AppStrings.getStarted,
                    onPressed: _nextPage,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _skip,
                    child: Text(
                      AppStrings.skipIntro,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          // Illustration area
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(page.icon, color: AppColors.accent, size: 80),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: page.secondaryIcons.map((icon) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(
                            icon,
                            color: AppColors.accent.withValues(alpha: 0.6),
                            size: 28,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textWhite,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Feature card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(page.featureIcon, color: AppColors.accent, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        page.featureTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        page.featureDescription,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final List<IconData> secondaryIcons;
  final String title;
  final String description;
  final IconData featureIcon;
  final String featureTitle;
  final String featureDescription;

  _OnboardingPage({
    required this.icon,
    required this.secondaryIcons,
    required this.title,
    required this.description,
    required this.featureIcon,
    required this.featureTitle,
    required this.featureDescription,
  });
}
