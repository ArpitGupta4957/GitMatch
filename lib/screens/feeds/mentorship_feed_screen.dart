import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/feed_provider.dart';
import '../../providers/saved_provider.dart';
import '../../models/mentor_model.dart';
import '../../widgets/loading_widget.dart';

class MentorshipFeedScreen extends StatefulWidget {
  const MentorshipFeedScreen({super.key});

  @override
  State<MentorshipFeedScreen> createState() => _MentorshipFeedScreenState();
}

class _MentorshipFeedScreenState extends State<MentorshipFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadMentors();
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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.accent,
                      child: const Icon(Icons.person, color: Colors.white, size: 16),
                    ),
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
                  Tab(text: 'Mentors'),
                  Tab(text: 'Mentees'),
                  Tab(text: 'Explore'),
                ],
              ),
            ),

            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _FilterChip(label: AppStrings.filters, icon: Icons.tune, isActive: true),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Python'),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Architecture'),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Remote'),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Consumer<FeedProvider>(
                builder: (context, feedProvider, _) {
                  if (feedProvider.isLoading) {
                    return const LoadingWidget(message: 'Loading mentors...');
                  }
                  if (feedProvider.mentors.isEmpty) {
                    return const Center(
                      child: Text(
                        'No mentors available right now.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Featured mentor card
                      if (feedProvider.mentors.isNotEmpty)
                        _FeaturedMentorCard(
                          mentor: feedProvider.mentors.first,
                          onReject: () {
                            feedProvider.removeMentor(feedProvider.mentors.first.id);
                          },
                          onSave: () {
                            context.read<SavedProvider>().saveMentor(feedProvider.mentors.first);
                            feedProvider.removeMentor(feedProvider.mentors.first.id);
                          },
                        ),

                      const SizedBox(height: 16),

                      // Additional mentor tiles
                      ...feedProvider.mentors.skip(1).map((mentor) =>
                          _MentorListTile(
                            mentor: mentor,
                            onTap: () {},
                          )),
                    ],
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
                    label: 'Feed',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_outline),
                    label: 'Matches',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble_outline),
                    label: 'Messages',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    label: 'Profile',
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

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isActive;

  const _FilterChip({required this.label, this.icon, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.accent : AppColors.secondary,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isActive ? AppColors.accent : AppColors.cardBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: isActive ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedMentorCard extends StatelessWidget {
  final MentorModel mentor;
  final VoidCallback onReject;
  final VoidCallback onSave;

  const _FeaturedMentorCard({
    required this.mentor,
    required this.onReject,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area with badge
          Stack(
            children: [
              Container(
                height: 280,
                width: double.infinity,
                color: AppColors.surface,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                        child: Text(
                          mentor.name[0],
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mentor.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mentor.titleWithCompany,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Badge
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: mentor.isOffering
                        ? AppColors.accent
                        : AppColors.info,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    mentor.isOffering
                        ? AppStrings.offeringMentorship
                        : AppStrings.seekingMentorship,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Skills
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Wrap(
              spacing: 8,
              children: mentor.skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                  ),
                );
              }).toList(),
            ),
          ),

          // Looking for
          if (mentor.lookingFor != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.lookingFor,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      mentor.lookingFor!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onReject,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const Icon(Icons.close, color: AppColors.textWhite),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: onSave,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent,
                    ),
                    child: const Icon(Icons.favorite, color: Colors.white),
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

class _MentorListTile extends StatelessWidget {
  final MentorModel mentor;
  final VoidCallback onTap;

  const _MentorListTile({required this.mentor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.surface,
              child: Text(
                mentor.name[0],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        mentor.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (mentor.isOffering ? AppColors.accent : AppColors.info)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          mentor.statusLabel,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: mentor.isOffering ? AppColors.accent : AppColors.info,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${mentor.title}${mentor.level != null ? ' • ${mentor.level}' : ''}',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mentor.skills.join('  '),
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
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
