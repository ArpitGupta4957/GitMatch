import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _githubCtrl;
  late TextEditingController _twitterCtrl;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameCtrl = TextEditingController(text: user?.displayName ?? '');
    _bioCtrl = TextEditingController(text: user?.bio ?? '');
    _githubCtrl = TextEditingController(text: user?.githubUrl ?? '');
    _twitterCtrl = TextEditingController(text: user?.twitterHandle ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _bioCtrl.dispose();
    _githubCtrl.dispose(); _twitterCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final auth = context.read<AuthProvider>();
    if (auth.user != null) {
      auth.updateProfile(auth.user!.copyWith(
        displayName: _nameCtrl.text,
        bio: _bioCtrl.text,
        githubUrl: _githubCtrl.text,
        twitterHandle: _twitterCtrl.text,
      ));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Edit Profile'),
        actions: [TextButton(onPressed: _save, child: const Text('Save', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _Field(label: 'Display Name', controller: _nameCtrl),
          const SizedBox(height: 16),
          _Field(label: 'Bio', controller: _bioCtrl, maxLines: 3),
          const SizedBox(height: 16),
          _Field(label: 'GitHub URL', controller: _githubCtrl, prefix: 'github.com/'),
          const SizedBox(height: 16),
          _Field(label: 'Twitter', controller: _twitterCtrl, prefix: '@'),
          const SizedBox(height: 32),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Save Changes'),
          )),
        ]),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final String? prefix;
  const _Field({required this.label, required this.controller, this.maxLines = 1, this.prefix});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      const SizedBox(height: 8),
      TextField(
        controller: controller, maxLines: maxLines,
        style: const TextStyle(color: AppColors.textWhite),
        decoration: InputDecoration(
          prefixText: prefix,
          prefixStyle: const TextStyle(color: AppColors.textMuted),
          filled: true, fillColor: AppColors.secondary,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.cardBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.cardBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accent)),
        ),
      ),
    ]);
  }
}
