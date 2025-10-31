import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/core/di/service_locator.dart';
import 'src/features_page.dart';
import 'src/features/notifications/presentation/pages/notifications_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize dependencies
  await initializeDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR TCC Project',
      initialRoute: '/',
      routes: {'/': (context) => const FeaturesPage(), '/notifications': (context) => const NotificationsPage()},
    );
  }
}
