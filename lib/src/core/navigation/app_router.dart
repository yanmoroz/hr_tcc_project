import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/applications/applications.dart';
import '../../core/entities/application_form.dart';
import '../../features/comments/domain/domain.dart';
import '../../features/comments/presentation/blocs/comments_page/comments_event.dart';
import '../../features/comments/presentation/pages/comments_page.dart';
import '../../features/discounts/presentation/blocs/discount_categories_page/discount_categories_event.dart';
import '../../features/discounts/presentation/blocs/discount_page/discount_detail_event.dart';
import '../../features/discounts/presentation/blocs/discounts_page/discounts_list_event.dart';
import '../../features/discounts/presentation/pages/discount_categories_page.dart';
import '../../features/discounts/presentation/pages/discount_detail_page.dart';
import '../../features/discounts/presentation/pages/discounts_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/news/presentation/blocs/news_detail_page/news_detail_event.dart';
import '../../features/news/presentation/blocs/news_page/news_list_event.dart';
import '../../features/news/presentation/pages/news_detail_page.dart';
import '../../features/news/presentation/pages/news_page.dart';
import '../../features/notifications/presentation/blocs/notification_detail_page/notification_detail_event.dart';
import '../../features/notifications/presentation/blocs/notifications_page/notifications_list_event.dart';
import '../../features/notifications/presentation/pages/notification_detail_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/polls/presentation/blocs/poll_page/poll_detail_event.dart';
import '../../features/polls/presentation/blocs/polls_page/polls_list_event.dart';
import '../../features/polls/presentation/pages/poll_page.dart';
import '../../features/polls/presentation/pages/polls_page.dart';
import '../../features/resell/presentation/pages/resell_detail_page.dart';
import '../../features/resell/presentation/pages/resell_items_page.dart';
import '../../features/users/presentation/blocs/address_book_page/address_book_event.dart';
import '../../features/users/presentation/blocs/user_profile_header/user_profile_header_event.dart';
import '../../features/users/presentation/pages/address_book_page.dart';
import '../../features/users/presentation/pages/users_page.dart';
import '../../features/users/presentation/widgets/user_profile_header.dart';
import '../di/bloc_factory.dart';
import 'scaffold_with_nav_bar.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) =>
                BlocFactory.createUserProfileHeaderBloc()
                  ..add(const UserProfileHeaderEvent.loadUserProfile()),
            child: ScaffoldWithNavBar(child: child),
          );
        },
        routes: [
          // Bottom navigation tab routes
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: '/applications',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (context) =>
                    BlocFactory.createApplicationsListBloc()
                      ..add(const ApplicationsListEvent.loadApplications()),
                child: const MyApplicationsPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/contacts',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (context) =>
                    BlocFactory.createAddressBookBloc()
                      ..add(const AddressBookEvent.loadAddressBook()),
                child: const AddressBookPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/more',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MorePage()),
          ),
          // Navigable routes (with persistent bottom nav)
          GoRoute(
            path: '/notifications',
            builder: (context, state) {
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createNotificationsListBloc()
                      ..add(const NotificationsListEvent.loadNotifications()),
                child: const NotificationsPage(),
              );
            },
          ),
          GoRoute(
            path: '/polls',
            builder: (context, state) {
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createPollsListBloc()
                      ..add(const PollsListEvent.loadPolls()),
                child: const PollsPage(),
              );
            },
          ),
          GoRoute(
            path: '/poll/:id',
            builder: (context, state) {
              final pollId = int.parse(state.pathParameters['id']!);
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createPollDetailBloc(pollId)
                      ..add(const PollDetailEvent.loadPollDetail()),
                child: PollPage(pollId: pollId),
              );
            },
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) => const UsersPage(),
          ),
          GoRoute(
            path: '/discount-categories',
            builder: (context, state) {
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createDiscountCategoriesBloc()
                      ..add(const DiscountCategoriesEvent.loadCategories()),
                child: const DiscountCategoriesPage(),
              );
            },
          ),
          GoRoute(
            path: '/discounts',
            builder: (context, state) {
              final category = state.getExtra<String>('category');
              final source = state.getExtra<String>('source');
              final categoryName = state.getExtra<String>('categoryName');
              final categoryCode = category != null
                  ? int.tryParse(category)
                  : null;
              final sourceCode = source != null ? int.tryParse(source) : null;
              return BlocProvider(
                create: (context) => BlocFactory.createDiscountsListBloc()
                  ..add(
                    DiscountsListEvent.loadDiscounts(
                      category: categoryCode,
                      source: sourceCode,
                      categoryName: categoryName,
                    ),
                  ),
                child: const DiscountsPage(),
              );
            },
          ),
          GoRoute(
            path: '/discount/:id',
            builder: (context, state) {
              final discountId = int.parse(state.pathParameters['id']!);
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createDiscountDetailBloc(discountId)
                      ..add(const DiscountDetailEvent.loadDetail()),
                child: DiscountDetailPage(discountId: discountId),
              );
            },
          ),
          GoRoute(
            path: '/news',
            builder: (context, state) {
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createNewsListBloc()
                      ..add(const NewsListEvent.loadNews()),
                child: const NewsPage(),
              );
            },
          ),
          GoRoute(
            path: '/news-detail/:id',
            builder: (context, state) {
              final newsId = int.parse(state.pathParameters['id']!);
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createNewsDetailBloc(newsId)
                      ..add(const NewsDetailEvent.loadDetail()),
                child: NewsDetailPage(newsId: newsId),
              );
            },
          ),
          GoRoute(
            path: '/comments/:entityType/:entityId',
            builder: (context, state) {
              final entityId = int.parse(state.pathParameters['entityId']!);
              final entityType = CommentableEntityType.fromString(
                state.pathParameters['entityType']!,
              );
              return BlocProvider(
                create: (context) => BlocFactory.createCommentsBloc(
                  entityId: entityId,
                  entityType: entityType,
                )..add(const CommentsEvent.loadComments()),
                child: CommentsPage(entityId: entityId, entityType: entityType),
              );
            },
          ),
          GoRoute(
            path: '/resell',
            builder: (context, state) => const ResellItemsPage(),
          ),
          GoRoute(
            path: '/resell-detail',
            builder: (context, state) => const ResellDetailPage(),
          ),
          GoRoute(
            path: '/application-creation',
            builder: (context, state) {
              return BlocProvider(
                create: (context) => BlocFactory.createApplicationCreationBloc()
                  ..add(const ApplicationCreationEvent.loadApplicationForms()),
                child: const ApplicationCreationPage(),
              );
            },
          ),
          GoRoute(
            path: '/application-form/:formCode',
            builder: (context, state) {
              final applicationForm = state.extra as ApplicationForm;
              return BlocProvider(
                create: (context) => BlocFactory.createApplicationFormBloc(),
                child: ApplicationFormPage(applicationForm: applicationForm),
              );
            },
          ),
          GoRoute(
            path: '/application/:id',
            builder: (context, state) {
              final applicationId = state.pathParameters['id']!;
              return BlocProvider(
                create: (context) => BlocFactory.createApplicationDetailBloc(),
                child: ApplicationDetailPage(applicationId: applicationId),
              );
            },
          ),
          GoRoute(
            path: '/notification/:id',
            builder: (context, state) {
              final notificationId = int.parse(state.pathParameters['id']!);
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createNotificationDetailBloc()
                      ..add(NotificationDetailEvent.loadDetail(notificationId)),
                child: NotificationDetailPage(notificationId: notificationId),
              );
            },
          ),
        ],
      ),
    ],
  );
}

// TODO: Move?
extension GoRouterStateExtension on GoRouterState {
  T? getExtra<T>(String key) {
    final extra = this.extra as Map<String, dynamic>?;
    return extra?[key] as T?;
  }
}

// Placeholder pages for bottom navigation tabs
class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const UserProfileHeader(),
          Expanded(child: Center(child: Placeholder())),
        ],
      ),
    );
  }
}

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Контакты')),
      body: Center(child: Placeholder()),
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const UserProfileHeader(),
          Expanded(child: Center(child: Placeholder())),
        ],
      ),
    );
  }
}
