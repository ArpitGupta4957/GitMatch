import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/spacing.dart';

import '../../providers/feed_provider.dart';

import '../../widgets/github_card.dart';
import '../feeds/repo_feed_screen.dart';
import '../feeds/hackathon_feed_screen.dart';
import '../feeds/mentorship_feed_screen.dart';
import '../saved/saved_items_screen.dart';
import '../profile/profile_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadAllFeeds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _DashboardHome(),
      const RepoFeedScreen(),
      const SavedItemsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.secondary,
          border: Border(
            top: BorderSide(color: AppColors.cardBorder, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: AppColors.secondary,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.navInactive,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'EXPLORE',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'MENTORS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                  const SizedBox(width: 10),
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // Dashboard heading
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.dashboard,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.welcomeBack,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Explore Repos card
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: _DiscoveryCard(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade900.withValues(alpha: 0.4),
                    AppColors.secondary,
                  ],
                ),
                icon: Icons.code,
                title: AppStrings.exploreRepos,
                badge: AppStrings.newProjects,
                badgeColor: AppColors.accent,
                description: AppStrings.exploreReposDesc,
                buttonText: AppStrings.browseRepos,
                buttonIcon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RepoFeedScreen()),
                  );
                },
              ),
            ),
          ),

          // Find Hackathons card
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: _DiscoveryCard(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade900.withValues(alpha: 0.3),
                    AppColors.secondary,
                  ],
                ),
                icon: Icons.emoji_events,
                title: AppStrings.findHackathons,
                description: AppStrings.findHackathonsDesc,
                buttonText: AppStrings.viewAllEvents,
                buttonIcon: Icons.calendar_today,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HackathonFeedScreen()),
                  );
                },
              ),
            ),
          ),

          // Connect with Mentors card
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: _DiscoveryCard(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade900.withValues(alpha: 0.3),
                    AppColors.secondary,
                  ],
                ),
                icon: Icons.people,
                title: AppStrings.connectWithMentors,
                description: AppStrings.connectWithMentorsDesc,
                buttonText: AppStrings.findAMentor,
                buttonIcon: Icons.person_add,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MentorshipFeedScreen()),
                  );
                },
              ),
            ),
          ),

          // Activity section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                AppStrings.activity,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  _ActivityItem(
                    icon: Icons.visibility,
                    iconColor: Colors.orange,
                    text: 'Recently viewed facebook/react',
                    time: '2 hours ago',
                  ),
                  _ActivityItem(
                    icon: Icons.star,
                    iconColor: Colors.blue,
                    text: 'You starred shadcn/ui',
                    time: 'Yesterday',
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  final LinearGradient gradient;
  final IconData icon;
  final String title;
  final String? badge;
  final Color? badgeColor;
  final String description;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onPressed;

  const _DiscoveryCard({
    required this.gradient,
    required this.icon,
    required this.title,
    this.badge,
    this.badgeColor,
    required this.description,
    required this.buttonText,
    required this.buttonIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              color: AppColors.surface.withValues(alpha: 0.5),
            ),
            child: Center(
              child: Icon(icon, color: AppColors.accent.withValues(alpha: 0.5), size: 60),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textWhite,
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor?.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: badgeColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onPressed,
                    icon: Text(buttonText),
                    label: Icon(buttonIcon, size: 16),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return GitHubCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
