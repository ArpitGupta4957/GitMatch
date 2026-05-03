import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/feed_provider.dart';
import 'providers/swipe_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/saved_provider.dart';
import 'providers/activity_provider.dart';
import 'providers/notification_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/splash/splash_screen.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize Supabase using credentials from .env
  await SupabaseService.initialize();

  runApp(const GitMatchApp());
}

class GitMatchApp extends StatelessWidget {
  const GitMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final swipeProvider = SwipeProvider();
    final savedProvider = SavedProvider();
    final activityProvider = ActivityProvider();
    final notificationProvider = NotificationProvider();
    final authProvider = AuthProvider()
      ..init(swipeProvider, savedProvider, activityProvider, notificationProvider);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider.value(value: swipeProvider),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider.value(value: savedProvider),
        ChangeNotifierProvider.value(value: activityProvider),
        ChangeNotifierProvider.value(value: notificationProvider),
      ],
      child: MaterialApp(
        title: 'GitMatch',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
