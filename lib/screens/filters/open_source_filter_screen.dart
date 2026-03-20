import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../widgets/animated_button.dart';
import '../feeds/repo_feed_screen.dart';

import 'package:provider/provider.dart';
import '../../providers/feed_provider.dart';

class OpenSourceFilterScreen extends StatefulWidget {
  const OpenSourceFilterScreen({super.key});

  @override
  State<OpenSourceFilterScreen> createState() => _OpenSourceFilterScreenState();
}

class _OpenSourceFilterScreenState extends State<OpenSourceFilterScreen> {
  String _selectedDifficulty = 'Any';
  final List<String> _difficulties = [
    'Any',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  String _selectedSize = 'Any';
  final List<String> _sizes = [
    'Any',
    '<1K Stars',
    '1K-10K Stars',
    '>10K Stars',
  ];

  final List<String> _selectedStack = [];
  final List<String> _techOptions = [
    'Flutter',
    'React',
    'Python',
    'Node.js',
    'Go',
    'Rust',
    'Java',
    'C++',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text('Open Source Filters', style: AppTextStyles.heading3),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tech Stack', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: _techOptions.map((tech) {
                final isSelected = _selectedStack.contains(tech);
                return FilterChip(
                  label: Text(tech),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedStack.add(tech);
                      } else {
                        _selectedStack.remove(tech);
                      }
                    });
                  },
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.accent.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.accent,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.accent
                        : AppColors.textPrimary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            Text('Difficulty Level', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _difficulties.map((diff) {
                return ChoiceChip(
                  label: Text(diff),
                  selected: _selectedDifficulty == diff,
                  onSelected: (val) {
                    if (val) setState(() => _selectedDifficulty = diff);
                  },
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.accent,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            Text('Project Size', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _sizes.map((size) {
                return ChoiceChip(
                  label: Text(size),
                  selected: _selectedSize == size,
                  onSelected: (val) {
                    if (val) setState(() => _selectedSize = size);
                  },
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.accent,
                );
              }).toList(),
            ),
            const SizedBox(height: 48),

            AnimatedButton(
              label: 'Find Projects',
              onPressed: () {
                context.read<FeedProvider>().loadRepos(
                  techFilter: _selectedStack.isNotEmpty ? _selectedStack : null,
                  difficulty: _selectedDifficulty == 'Any'
                      ? null
                      : _selectedDifficulty,
                  size: _selectedSize == 'Any' ? null : _selectedSize,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RepoFeedScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
