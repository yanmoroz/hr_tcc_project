import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/entities/application_form.dart';
import '../../features/applications/applications.dart';
import '../../features/comments/comments.dart';
import '../../features/discounts/discounts.dart';
import '../../features/home/home.dart';
import '../../features/more/more.dart';
import '../../features/news/news.dart';
import '../../features/notifications/notifications.dart';
import '../../features/polls/polls.dart';
import '../../features/resell/resell.dart';
import '../../features/users/users.dart';
import '../di/bloc_factory.dart';
import 'main_shell.dart';

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
                BlocFactory.createCurrentUserBloc()
                  ..add(const CurrentUserEvent.loadCurrentUser()),
            child: MainShell(child: child),
          );
        },
        routes: [
          // Bottom navigation tab routes
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
                create: (context) => BlocFactory.createApplicationFormBloc(
                  applicationForm,
                )..add(ApplicationFormEvent.loadFormData(applicationForm.code)),
                child: ApplicationFormPage(),
              );
            },
          ),
          GoRoute(
            path: '/application/:id',
            builder: (context, state) {
              final applicationId = state.pathParameters['id']!;
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createApplicationDetailBloc(applicationId)
                      ..add(ApplicationDetailEvent.loadDetail()),
                child: const ApplicationDetailPage(),
              );
            },
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
                child: const CommentsPage(),
              );
            },
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
            path: '/discount/:id',
            builder: (context, state) {
              final discountId = int.parse(state.pathParameters['id']!);
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createDiscountDetailBloc(discountId)
                      ..add(const DiscountDetailEvent.loadDetail()),
                child: const DiscountDetailPage(),
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
            path: '/home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: '/more',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MorePage()),
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
                child: const NewsDetailPage(),
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
                child: const NotificationDetailPage(),
              );
            },
          ),
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
            path: '/poll/:id',
            builder: (context, state) {
              final pollId = int.parse(state.pathParameters['id']!);
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createPollDetailBloc(pollId)
                      ..add(const PollDetailEvent.loadPollDetail()),
                child: const PollPage(),
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
            path: '/resell',
            builder: (context, state) => BlocProvider(
              create: (context) =>
                  BlocFactory.createResellItemsBloc()
                    ..add(const ResellItemsEvent.loadResellItems()),
              child: const ResellItemsPage(),
            ),
          ),
          GoRoute(
            path: '/resell-booking/:id',
            builder: (context, state) {
              final itemId = state.pathParameters['id']!;
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createResellBookingBloc(itemId),
                child: const ResellBookingPage(),
              );
            },
          ),
          GoRoute(
            path: '/resell-detail/:id',
            builder: (context, state) {
              final itemId = state.pathParameters['id']!;
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createResellDetailBloc(itemId)
                      ..add(const ResellDetailEvent.loadResellDetail()),
                child: ResellDetailPage(itemId: itemId),
              );
            },
          ),
        ],
      ),
    ],
  );
}

extension GoRouterStateExtension on GoRouterState {
  T? getExtra<T>(String key) {
    final extra = this.extra as Map<String, dynamic>?;
    return extra?[key] as T?;
  }
}
