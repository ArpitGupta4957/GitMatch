import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../widgets/animated_button.dart';
import '../feeds/mentorship_feed_screen.dart';

import 'package:provider/provider.dart';
import '../../providers/feed_provider.dart';

class MentorshipFilterScreen extends StatefulWidget {
  const MentorshipFilterScreen({super.key});

  @override
  State<MentorshipFilterScreen> createState() => _MentorshipFilterScreenState();
}

class _MentorshipFilterScreenState extends State<MentorshipFilterScreen> {
  String _selectedDomain = 'Career Guidance';
  final List<String> _domains = ['Career Guidance', 'Code Review', 'Open Source', 'System Design', 'Interview Prep'];

  String _experienceLevel = 'Any';
  final List<String> _levels = ['Any', 'Junior', 'Mid-Level', 'Senior', 'Staff+'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text('Find a Mentor/Mentee', style: AppTextStyles.heading3),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Domain / Help Type', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: _domains.map((domain) {
                return ChoiceChip(
                  label: Text(domain),
                  selected: _selectedDomain == domain,
                  onSelected: (val) {
                    if (val) setState(() => _selectedDomain = domain);
                  },
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.accent,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            
            Text('Experience Level', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _levels.map((level) {
                return ChoiceChip(
                  label: Text(level),
                  selected: _experienceLevel == level,
                  onSelected: (val) {
                    if (val) setState(() => _experienceLevel = level);
                  },
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.accent,
                );
              }).toList(),
            ),
            const SizedBox(height: 48),

            AnimatedButton(
              label: 'Find Connections',
              onPressed: () {
                context.read<FeedProvider>().loadMentors(
                  domain: _selectedDomain == 'Any' ? null : _selectedDomain,
                  level: _experienceLevel == 'Any' ? null : _experienceLevel,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MentorshipFeedScreen(),
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
