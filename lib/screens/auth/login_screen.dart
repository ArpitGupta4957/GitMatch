import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/animated_button.dart';
import '../home/home_dashboard.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleGitHubLogin(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final success = await auth.signInWithGitHub();

    if (context.mounted) {
      if (success) {
        // Navigate to home dashboard on successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('GitHub sign-in failed. Check your OAuth setup.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              // Top bar
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.terminal,
                      color: AppColors.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // Logo area
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/logo_half.png', fit: BoxFit.cover),
              ),

              const SizedBox(height: 28),

              // Title
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.tagline,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),

              const Spacer(flex: 2),

              // Continue with GitHub button
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return auth.isLoading
                      ? const CircularProgressIndicator(color: AppColors.accent)
                      : AnimatedButton(
                          label: AppStrings.continueWithGitHub,
                          iconWidget: const Icon(
                            Icons.code,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () => _handleGitHubLogin(context),
                        );
                },
              ),

              const SizedBox(height: 16),

              // Demo mode fallback
              TextButton(
                onPressed: () {
                  context.read<AuthProvider>().enterDemoMode();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeDashboard()),
                  );
                },
                child: Text(
                  'Continue in Demo Mode',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Divider with COLLABORATORS
              Row(
                children: [
                  Expanded(
                    child: Container(height: 1, color: AppColors.cardBorder),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      AppStrings.collaborators,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(height: 1, color: AppColors.cardBorder),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Avatar row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(3, (i) {
                    final icons = [
                      Icons.code,
                      Icons.desktop_mac,
                      Icons.integration_instructions,
                    ];
                    final colors = [
                      AppColors.info,
                      AppColors.accent,
                      const Color(0xFFBC8CFF),
                    ];
                    return Container(
                      margin: const EdgeInsets.only(right: 0),
                      transform: Matrix4.translationValues(i * -8.0, 0, 0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: colors[i].withValues(alpha: 0.2),
                        child: Icon(icons[i], color: colors[i], size: 20),
                      ),
                    );
                  }),
                  Transform.translate(
                    offset: const Offset(-24, 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '+12k',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.joinThousands,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),

              const Spacer(flex: 1),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.builtForDevelopers,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppStrings.gitMatchTeam,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  const _FooterLink(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
        letterSpacing: 1,
      ),
    );
  }
}
