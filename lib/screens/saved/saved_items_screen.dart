import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/saved_provider.dart';
import '../../providers/auth_provider.dart';
import '../detail/detail_page.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});
  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  const Text('Saved Items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textWhite)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.settings, color: AppColors.textSecondary), onPressed: () {}),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder, width: 0.5))),
              child: TabBar(controller: _tabController, tabs: const [Tab(text: 'Repos'), Tab(text: 'Hackathons'), Tab(text: 'Mentors')]),
            ),
            Expanded(child: TabBarView(controller: _tabController, children: [_ReposList(), _HackathonsList(), _MentorsList()])),
          ],
        ),
      ),
    );
  }
}

class _ReposList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SavedProvider>(builder: (context, sp, _) {
      if (sp.savedRepos.isEmpty) return const Center(child: Text('No saved repos yet.\nSwipe right to save!', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)));
      return ListView.builder(
        padding: const EdgeInsets.all(16), itemCount: sp.savedRepos.length,
        itemBuilder: (context, i) {
          final repo = sp.savedRepos[i];
          return _Tile(
            leading: Text(repo.owner[0].toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textWhite)),
            title: '${repo.owner}/${repo.name}', subtitle: repo.description,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(repo: repo))),
            onRemove: () => sp.unsaveRepo(repo.id, context.read<AuthProvider>().user?.id ?? ''),
          );
        },
      );
    });
  }
}

class _HackathonsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SavedProvider>(builder: (context, sp, _) {
      if (sp.savedHackathons.isEmpty) return const Center(child: Text('No saved hackathons yet.', style: TextStyle(color: AppColors.textSecondary)));
      return ListView.builder(
        padding: const EdgeInsets.all(16), itemCount: sp.savedHackathons.length,
        itemBuilder: (context, i) {
          final h = sp.savedHackathons[i];
          return _Tile(leading: const Icon(Icons.emoji_events, color: AppColors.accent), title: h.title, subtitle: h.dateRange, onRemove: () => sp.unsaveHackathon(h.id, context.read<AuthProvider>().user?.id ?? ''));
        },
      );
    });
  }
}

class _MentorsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SavedProvider>(builder: (context, sp, _) {
      if (sp.savedMentors.isEmpty) return const Center(child: Text('No saved mentors yet.', style: TextStyle(color: AppColors.textSecondary)));
      return ListView.builder(
        padding: const EdgeInsets.all(16), itemCount: sp.savedMentors.length,
        itemBuilder: (context, i) {
          final m = sp.savedMentors[i];
          return _Tile(leading: Text(m.name[0], style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textWhite)), title: m.name, subtitle: m.title, onRemove: () => sp.unsaveMentor(m.id, context.read<AuthProvider>().user?.id ?? ''));
        },
      );
    });
  }
}

class _Tile extends StatelessWidget {
  final Widget leading;
  final String title, subtitle;
  final VoidCallback? onTap, onRemove;
  const _Tile({required this.leading, required this.title, required this.subtitle, this.onTap, this.onRemove});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
        child: Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: Center(child: leading)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textWhite)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
          ])),
          if (onRemove != null) IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.textSecondary, size: 20), onPressed: onRemove),
        ]),
      ),
    );
  }
}
