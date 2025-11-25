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
  static final _homeNavigatorKey = GlobalKey<NavigatorState>();
  static final _applicationsNavigatorKey = GlobalKey<NavigatorState>();
  static final _contactsNavigatorKey = GlobalKey<NavigatorState>();
  static final _moreNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: [
      // Shared BLoC provider wrapper for all tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BlocProvider(
            create: (context) =>
                BlocFactory.createCurrentUserBloc()
                  ..add(const CurrentUserEvent.loadCurrentUser()),
            child: MainShell(navigationShell: navigationShell),
          );
        },
        branches: [
          // Home Tab Branch
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: BlocProvider(
                    create: (context) =>
                        BlocFactory.createNewsListBloc()
                          ..add(const NewsListEvent.loadNews()),
                    child: const HomePage(),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'discount-categories',
                    builder: (context, state) {
                      return BlocProvider(
                        create: (context) =>
                            BlocFactory.createDiscountCategoriesBloc()..add(
                              const DiscountCategoriesEvent.loadCategories(),
                            ),
                        child: const DiscountCategoriesPage(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'discounts',
                    builder: (context, state) {
                      final category = state.getExtra<String>('category');
                      final source = state.getExtra<String>('source');
                      final categoryName = state.getExtra<String>(
                        'categoryName',
                      );
                      final categoryCode = category != null
                          ? int.tryParse(category)
                          : null;
                      final sourceCode = source != null
                          ? int.tryParse(source)
                          : null;
                      return BlocProvider(
                        create: (context) =>
                            BlocFactory.createDiscountsListBloc()..add(
                              DiscountsListEvent.loadDiscounts(
                                category: categoryCode,
                                source: sourceCode,
                                categoryName: categoryName,
                              ),
                            ),
                        child: const DiscountsPage(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (context, state) {
                          final discountId = int.parse(
                            state.pathParameters['id']!,
                          );
                          return BlocProvider(
                            create: (context) =>
                                BlocFactory.createDiscountDetailBloc(discountId)
                                  ..add(const DiscountDetailEvent.loadDetail()),
                            child: const DiscountDetailPage(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'polls',
                    builder: (context, state) {
                      return BlocProvider(
                        create: (context) =>
                            BlocFactory.createPollsListBloc()
                              ..add(const PollsListEvent.loadPolls()),
                        child: const PollsPage(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: ':id',
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
                    ],
                  ),
                  GoRoute(
                    path: 'resell',
                    builder: (context, state) => BlocProvider(
                      create: (context) =>
                          BlocFactory.createResellItemsBloc()
                            ..add(const ResellItemsEvent.loadResellItems()),
                      child: const ResellItemsPage(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'detail/:id',
                        builder: (context, state) {
                          final itemId = state.pathParameters['id']!;
                          return BlocProvider(
                            create: (context) =>
                                BlocFactory.createResellDetailBloc(itemId)..add(
                                  const ResellDetailEvent.loadResellDetail(),
                                ),
                            child: ResellDetailPage(itemId: itemId),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'booking/:id',
                        builder: (context, state) {
                          final itemId = state.pathParameters['id']!;
                          return BlocProvider(
                            create: (context) =>
                                BlocFactory.createResellBookingBloc(itemId),
                            child: const ResellBookingPage(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'news',
                    builder: (context, state) {
                      return BlocProvider(
                        create: (context) =>
                            BlocFactory.createNewsListBloc()
                              ..add(const NewsListEvent.loadNews()),
                        child: const NewsPage(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: ':id',
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
                    ],
                  ),
                  GoRoute(
                    path: 'comments/:entityType/:entityId',
                    builder: (context, state) {
                      final entityId = int.parse(
                        state.pathParameters['entityId']!,
                      );
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
                ],
              ),
            ],
          ),
          // Applications Tab Branch
          StatefulShellBranch(
            navigatorKey: _applicationsNavigatorKey,
            routes: [
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
                routes: [
                  GoRoute(
                    path: 'creation',
                    pageBuilder: (context, state) => MaterialPage(
                      fullscreenDialog: true,
                      child: BlocProvider(
                        create: (context) =>
                            BlocFactory.createApplicationCreationBloc()..add(
                              const ApplicationCreationEvent.loadApplicationForms(),
                            ),
                        child: const ApplicationCreationPage(),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'form/:formCode',
                    pageBuilder: (context, state) {
                      final applicationForm = state.extra as ApplicationForm;
                      return MaterialPage(
                        child: BlocProvider(
                          create: (context) =>
                              BlocFactory.createApplicationFormBloc(
                                applicationForm,
                              )..add(
                                ApplicationFormEvent.loadFormData(
                                  applicationForm.code,
                                ),
                              ),
                          child: ApplicationFormPage(),
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final applicationId = state.pathParameters['id']!;
                      return BlocProvider(
                        create: (context) =>
                            BlocFactory.createApplicationDetailBloc(
                              applicationId,
                            )..add(ApplicationDetailEvent.loadDetail()),
                        child: const ApplicationDetailPage(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Contacts Tab Branch
          StatefulShellBranch(
            navigatorKey: _contactsNavigatorKey,
            routes: [
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
            ],
          ),
          // More Tab Branch
          StatefulShellBranch(
            navigatorKey: _moreNavigatorKey,
            routes: [
              GoRoute(
                path: '/more',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: MorePage()),
              ),
            ],
          ),
        ],
      ),
      // Root-level routes (outside tab navigation - no tab bar)
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
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final notification = state.extra as Notification;
              return BlocProvider(
                create: (context) =>
                    BlocFactory.createNotificationDetailBloc(notification),
                child: const NotificationDetailPage(),
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
