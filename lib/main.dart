import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/core/di/bloc_factory.dart';
import 'src/core/di/service_locator.dart';
import 'src/features/features/pages/features_page.dart';
import 'src/features/notifications/presentation/pages/notifications_page.dart';
import 'src/features/notifications/presentation/bloc/notifications_page/notifications_list_event.dart';
import 'src/features/polls/presentation/pages/polls_page.dart';
import 'src/features/polls/presentation/bloc/polls_page/polls_list_event.dart';
import 'src/features/polls/presentation/pages/poll_page.dart';
import 'src/features/polls/presentation/bloc/poll_page/poll_detail_event.dart';
import 'src/features/users/presentation/pages/users_page.dart';
import 'src/features/discounts/presentation/pages/discount_categories_page.dart';
import 'src/features/discounts/presentation/bloc/discount_categories_page/discount_categories_event.dart';
import 'src/features/discounts/presentation/pages/discounts_page.dart';
import 'src/features/discounts/presentation/bloc/discounts_page/discounts_list_event.dart';
import 'src/features/discounts/presentation/pages/discount_detail_page.dart';
import 'src/features/discounts/presentation/bloc/discount_page/discount_detail_event.dart';
import 'src/features/news/presentation/pages/news_page.dart';
import 'src/features/news/presentation/bloc/news_page/news_list_event.dart';
import 'src/features/news/presentation/pages/news_detail_page.dart';
import 'src/features/news/presentation/bloc/news_detail_page/news_detail_event.dart';
import 'src/features/resell/presentation/pages/resell_items_page.dart';
import 'src/features/resell/presentation/pages/resell_detail_page.dart';
import 'src/shared/comments/presentation/pages/comments_page.dart';
import 'src/shared/comments/presentation/bloc/comments_page/comments_event.dart';
import 'src/shared/comments/domain/domain.dart';

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
        '/notifications': (context) {
          return BlocProvider(
            create: (context) =>
                BlocFactory.createNotificationsListBloc()
                  ..add(const NotificationsListEvent.loadNotifications()),
            child: const NotificationsPage(),
          );
        },
        '/polls': (context) {
          return BlocProvider(
            create: (context) =>
                BlocFactory.createPollsListBloc()
                  ..add(const PollsListEvent.loadPolls()),
            child: const PollsPage(),
          );
        },
        '/poll': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final pollId = args as int;
          return BlocProvider(
            create: (context) =>
                BlocFactory.createPollDetailBloc(pollId)
                  ..add(const PollDetailEvent.loadPollDetail()),
            child: PollPage(pollId: pollId),
          );
        },
        '/users': (context) => const UsersPage(),
        '/discount-categories': (context) {
          return BlocProvider(
            create: (context) =>
                BlocFactory.createDiscountCategoriesBloc()
                  ..add(const DiscountCategoriesEvent.loadCategories()),
            child: const DiscountCategoriesPage(),
          );
        },
        '/discounts': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final categoryCode = args?['category'] as int?;
          final sourceCode = args?['source'] as int?;
          return BlocProvider(
            create: (context) => BlocFactory.createDiscountsListBloc()
              ..add(
                DiscountsListEvent.loadDiscounts(
                  category: categoryCode,
                  source: sourceCode,
                ),
              ),
            child: const DiscountsPage(),
          );
        },
        '/discount': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final discountId = args as int;
          return BlocProvider(
            create: (context) =>
                BlocFactory.createDiscountDetailBloc(discountId)
                  ..add(const DiscountDetailEvent.loadDetail()),
            child: DiscountDetailPage(discountId: discountId),
          );
        },
        '/news': (context) {
          return BlocProvider(
            create: (context) =>
                BlocFactory.createNewsListBloc()
                  ..add(const NewsListEvent.loadNews()),
            child: const NewsPage(),
          );
        },
        '/news-detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final newsId = args as int;
          return BlocProvider(
            create: (context) =>
                BlocFactory.createNewsDetailBloc(newsId)
                  ..add(const NewsDetailEvent.loadDetail()),
            child: NewsDetailPage(newsId: newsId),
          );
        },
        '/comments': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final entityId = args['entityId'] as int;
          final entityType = CommentableEntityType.fromString(
            args['feature'] as String,
          );
          return BlocProvider(
            create: (context) => BlocFactory.createCommentsBloc(
              entityId: entityId,
              entityType: entityType,
            )..add(const CommentsEvent.loadComments()),
            child: CommentsPage(entityId: entityId, entityType: entityType),
          );
        },
        '/resell': (context) => const ResellItemsPage(),
        '/resell-detail': (context) => const ResellDetailPage(),
      },
    );
  }
}
