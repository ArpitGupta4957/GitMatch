import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/feed_provider.dart';
import '../../providers/saved_provider.dart';
import '../../providers/swipe_provider.dart';
import '../../models/repo_model.dart';
import '../../models/swipe_model.dart';
import '../../widgets/swipe_indicator.dart';
import '../../widgets/loading_widget.dart';
import '../detail/detail_page.dart';

class RepoFeedScreen extends StatefulWidget {
  const RepoFeedScreen({super.key});

  @override
  State<RepoFeedScreen> createState() => _RepoFeedScreenState();
}

class _RepoFeedScreenState extends State<RepoFeedScreen> {
  final int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadRepos();
    });
  }

  void _onSwipeLeft(RepoModel repo) {
    context.read<SwipeProvider>().recordSwipe(
      userId: 'demo',
      itemId: repo.id,
      itemType: SwipeItemType.repo,
      direction: SwipeDirection.left,
    );
    context.read<FeedProvider>().recordSwipe();
    context.read<FeedProvider>().removeRepo(repo.id);
  }

  void _onSwipeRight(RepoModel repo) {
    context.read<SwipeProvider>().recordSwipe(
      userId: 'demo',
      itemId: repo.id,
      itemType: SwipeItemType.repo,
      direction: SwipeDirection.right,
    );
    context.read<SavedProvider>().saveRepo(repo);
    context.read<FeedProvider>().recordSwipe();
    context.read<FeedProvider>().removeRepo(repo.id);
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
                    icon: const Icon(Icons.filter_list, color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined,
                            color: AppColors.textSecondary),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card stack
            Expanded(
              child: Consumer<FeedProvider>(
                builder: (context, feedProvider, _) {
                  if (feedProvider.isLoading) {
                    return const LoadingWidget(message: 'Loading repositories...');
                  }
                  if (feedProvider.isRateLimited) {
                    return RateLimitWidget(
                      timeRemaining: feedProvider.timeUntilReset,
                    );
                  }
                  if (feedProvider.repos.isEmpty) {
                    return const Center(
                      child: Text(
                        'No more repos to discover.\nCheck back later!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ),
                    );
                  }

                  final repo = feedProvider.repos[_currentIndex.clamp(0, feedProvider.repos.length - 1)];
                  return _RepoSwipeCard(
                    repo: repo,
                    onSwipeLeft: () => _onSwipeLeft(repo),
                    onSwipeRight: () => _onSwipeRight(repo),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(repo: repo),
                        ),
                      );
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
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'FEED',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.star_outline),
                    label: 'MATCHES',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble_outline),
                    label: 'CHAT',
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

class _RepoSwipeCard extends StatefulWidget {
  final RepoModel repo;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onTap;

  const _RepoSwipeCard({
    required this.repo,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onTap,
  });

  @override
  State<_RepoSwipeCard> createState() => _RepoSwipeCardState();
}

class _RepoSwipeCardState extends State<_RepoSwipeCard>
    with SingleTickerProviderStateMixin {
  double _dragX = 0;
  double _dragY = 0;
  double _rotation = 0;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragX += details.delta.dx;
      _dragY += details.delta.dy;
      _rotation = _dragX * 0.001;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragX > 100) {
      widget.onSwipeRight();
    } else if (_dragX < -100) {
      widget.onSwipeLeft();
    }
    setState(() {
      _dragX = 0;
      _dragY = 0;
      _rotation = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final swipeProgress = (_dragX / 150).clamp(-1.0, 1.0);

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 0),
              transform: Matrix4.identity()
                ..translateByDouble(_dragX, _dragY, 0, 0)
                ..rotateZ(_rotation),
              child: Stack(
                children: [
                  // Card
                  Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image area
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            color: AppColors.surface,
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.code,
                                    size: 80,
                                    color: AppColors.textMuted.withValues(alpha: 0.3),
                                  ),
                                ),
                                // Owner avatar & name
                                Positioned(
                                  left: 16,
                                  bottom: 16,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: AppColors.surface,
                                        child: Text(
                                          widget.repo.owner[0].toUpperCase(),
                                          style: const TextStyle(
                                            color: AppColors.textWhite,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.repo.fullName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textWhite,
                                            ),
                                          ),
                                          if (widget.repo.isVerified)
                                            Container(
                                              margin: const EdgeInsets.only(top: 4),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.accent.withValues(alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.verified,
                                                      color: AppColors.accent,
                                                      size: 12),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    AppStrings.verifiedOwner,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: AppColors.accent,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Info section
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Stats row
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.repo.starsFormatted,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(Icons.call_split, color: AppColors.textSecondary, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.repo.forksFormatted,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.accent.withValues(alpha: 0.5),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.favorite_outline,
                                        color: AppColors.accent,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Title
                                Text(
                                  widget.repo.description,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textWhite,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),

                                // Long description
                                if (widget.repo.longDescription != null)
                                  Expanded(
                                    child: Text(
                                      widget.repo.longDescription!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                        height: 1.5,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                const SizedBox(height: 8),

                                // Tech chips
                                Wrap(
                                  spacing: 8,
                                  children: widget.repo.techStack.map((tech) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(
                                          color: AppColors.cardBorder,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.code,
                                              size: 12,
                                              color: AppColors.accent),
                                          const SizedBox(width: 4),
                                          Text(
                                            tech,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Swipe indicators
                  if (swipeProgress < 0)
                    SwipeIndicator(
                      opacity: -swipeProgress,
                      isRight: false,
                    ),
                  if (swipeProgress > 0)
                    SwipeIndicator(
                      opacity: swipeProgress,
                      isRight: true,
                    ),
                ],
              ),
            ),
          ),
        ),

        // Action buttons
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SwipeActionButtons(
            onReject: widget.onSwipeLeft,
            onRefresh: () {},
            onSave: widget.onSwipeRight,
          ),
        ),
      ],
    );
  }
}
