import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/feed_provider.dart';
import '../../providers/saved_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/hackathon_model.dart';
import '../../widgets/loading_widget.dart';

class HackathonFeedScreen extends StatefulWidget {
  const HackathonFeedScreen({super.key});

  @override
  State<HackathonFeedScreen> createState() => _HackathonFeedScreenState();
}

class _HackathonFeedScreenState extends State<HackathonFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _currentCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadHackathons();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.accent,
                        size: 18,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'GitMatch Feed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.tune,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.cardBorder, width: 0.5),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'For You'),
                  Tab(text: 'Remote'),
                  Tab(text: 'Nearby'),
                ],
                labelColor: AppColors.accent,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.accent,
                indicatorWeight: 2,
              ),
            ),

            // Content
            Expanded(
              child: Consumer<FeedProvider>(
                builder: (context, feedProvider, _) {
                  if (feedProvider.isLoading) {
                    return const LoadingWidget(
                      message: 'Loading hackathons...',
                    );
                  }
                  if (feedProvider.isRateLimited) {
                    return RateLimitWidget(
                      timeRemaining: feedProvider.timeUntilReset,
                    );
                  }
                  if (feedProvider.hackathons.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hackathons available right now.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  final hackathon =
                      feedProvider.hackathons[_currentCardIndex.clamp(
                        0,
                        feedProvider.hackathons.length - 1,
                      )];
                  return _HackathonCard(
                    hackathon: hackathon,
                    onNotForMe: () {
                      feedProvider.removeHackathon(hackathon.id);
                      feedProvider.recordSwipe();
                    },
                    onInterested: () {
                      final uid = context.read<AuthProvider>().user?.id ?? '';
                      context.read<SavedProvider>().saveHackathon(hackathon, uid);
                      feedProvider.removeHackathon(hackathon.id);
                      feedProvider.recordSwipe();
                    },
                    onBookmark: () {
                      final uid = context.read<AuthProvider>().user?.id ?? '';
                      context.read<SavedProvider>().saveHackathon(hackathon, uid);
                    },
                  );
                },
              ),
            ),

            // Bottom nav
            Container(
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                border: Border(
                  top: BorderSide(color: AppColors.cardBorder, width: 0.5),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: 0,
                backgroundColor: AppColors.secondary,
                selectedItemColor: AppColors.accent,
                unselectedItemColor: AppColors.navInactive,
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                selectedFontSize: 11,
                unselectedFontSize: 11,
                onTap: (i) {
                  if (i != 0) Navigator.pop(context);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.explore_outlined),
                    activeIcon: Icon(Icons.explore),
                    label: 'DISCOVER',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_outline),
                    label: 'MATCHES',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble_outline),
                    label: 'MESSAGES',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.groups_outlined),
                    label: 'TEAMS',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    label: 'PROFILE',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HackathonCard extends StatelessWidget {
  final HackathonModel hackathon;
  final VoidCallback onNotForMe;
  final VoidCallback onInterested;
  final VoidCallback onBookmark;

  const _HackathonCard({
    required this.hackathon,
    required this.onNotForMe,
    required this.onInterested,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Main card
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image area with badges
                Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: AppColors.surface,
                      child: Center(
                        child: Icon(
                          Icons.emoji_events,
                          size: 80,
                          color: AppColors.accent.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    if (hackathon.isTrending)
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'TRENDING',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + LIVE badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              hackathon.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textWhite,
                                height: 1.2,
                              ),
                            ),
                          ),
                          if (hackathon.isLive)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.badgeLive.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.badgeLive),
                              ),
                              child: const Text(
                                'LIVE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.badgeLive,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Date & Location
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            hackathon.dateRange,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            hackathon.location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Prize Pool & Category
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PRIZE POOL',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  hackathon.prizeFormatted,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CATEGORY',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  hackathon.category,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tech Stack
                      Text(
                        'TECH STACK',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: hackathon.techStack.map((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Text(
                              tech,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Not For Me
              _HackathonAction(
                icon: Icons.close,
                color: AppColors.textSecondary,
                label: AppStrings.notForMe,
                onTap: onNotForMe,
                size: 56,
              ),
              // Interested
              _HackathonAction(
                icon: Icons.check,
                color: AppColors.accent,
                label: AppStrings.interested,
                onTap: onInterested,
                size: 64,
                filled: true,
              ),
              // Bookmark
              _HackathonAction(
                icon: Icons.star_outline,
                color: AppColors.textSecondary,
                label: AppStrings.bookmark,
                onTap: onBookmark,
                size: 56,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HackathonAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final double size;
  final bool filled;

  const _HackathonAction({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.size = 56,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? color : color.withValues(alpha: 0.1),
              border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
            ),
            child: Icon(
              icon,
              color: filled ? Colors.white : color,
              size: size * 0.4,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: filled ? color : AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
