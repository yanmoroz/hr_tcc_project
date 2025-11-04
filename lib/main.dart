import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/core/di/service_locator.dart';
import 'src/features/features/pages/features_page.dart';
import 'src/features/notifications/presentation/pages/notifications_page.dart';
import 'src/features/polls/presentation/pages/polls_page.dart';
import 'src/features/polls/presentation/pages/poll_page.dart';
import 'src/features/users/presentation/pages/users_page.dart';
import 'src/features/discounts/presentation/pages/discount_categories_page.dart';
import 'src/features/discounts/presentation/pages/discounts_page.dart';
import 'src/features/discounts/presentation/pages/discount_detail_page.dart';
import 'src/shared/comments/presentation/pages/comments_page.dart';

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
      routes: {
        '/': (context) => const FeaturesPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/polls': (context) => const PollsPage(),
        '/poll': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final pollId = args as int;
          return PollPage(pollId: pollId);
        },
        '/users': (context) => const UsersPage(),
        '/discount-categories': (context) => const DiscountCategoriesPage(),
        '/discounts': (context) => const DiscountsPage(),
        '/discount': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final discountId = args as int;
          return DiscountDetailPage(discountId: discountId);
        },
        '/comments': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final entityId = args['entityId'] as int;
          return CommentsPage(entityId: entityId);
        },
      },
    );
  }
}
