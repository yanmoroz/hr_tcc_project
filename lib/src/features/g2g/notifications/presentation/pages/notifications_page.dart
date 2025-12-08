import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/extensions/state_extension.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../blocs/notifications_list/bloc.dart';
import '../widgets/notification_item.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  double _buttonHeight = 0.0;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationsListBloc, NotificationsListState>(
      listenWhen: (previous, current) =>
          previous.actionError != current.actionError &&
          current.actionError != null,
      listener: (context, state) {
        SubmitResultWidget.show(
          context: context,
          message: state.actionError!,
          isSuccess: false,
        );
      },
      child: Scaffold(
        body: BlocBuilder<NotificationsListBloc, NotificationsListState>(
          builder: (context, state) => Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  CustomSliverAppBar(title: const Text('Уведомления')),
                  SliverRefreshControl(
                    onRefresh: () async {
                      context.read<NotificationsListBloc>().add(
                        const NotificationsListEvent.refreshNotifications(),
                      );
                    },
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      64 + _buttonHeight,
                    ),
                    sliver: switch (state.status) {
                      LoadingStatus.initial => _buildLoadingState(),
                      LoadingStatus.loading => _buildLoadingState(),
                      LoadingStatus.error => _buildErrorState(context),
                      LoadingStatus.success => _buildLoadedState(
                        context,
                        state,
                      ),
                    },
                  ),
                ],
              ),
              // Mark all as read button (bottom)
              if (state.unreadNotificationsCount > 0)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: SafeArea(child: _buildMarkAllAsReadButton(context)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildErrorState(BuildContext context) {
    return SliverNetworkErrorMessageWidget(
      onRetry: () {
        context.read<NotificationsListBloc>().add(
          const NotificationsListEvent.loadNotifications(),
        );
      },
    );
  }

  Widget _buildLoadedState(BuildContext context, NotificationsListState state) {
    if (state.notifications.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'Нет уведомлений',
            style: AppTypography.textRegular1.black,
          ),
        ),
      );
    }

    return SliverList.separated(
      itemCount: state.notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final notification = state.notifications[index];
        return NotificationItem(
          notification: notification,
          onTap: () {
            // Navigate to detail page
            context.push('/notifications/${notification.id}');
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return SliverShimmeringList(spacing: 12);
  }

  Widget _buildMarkAllAsReadButton(BuildContext context) {
    return MeasureSize(
      onChange: (size) {
        safeSetState(() {
          _buttonHeight = size.height;
        });
      },
      onDispose: () {
        if (mounted)
          safeSetState(() {
            _buttonHeight = 0.0;
          });
      },
      child: ElevatedButton(
        onPressed: () {
          context.read<NotificationsListBloc>().add(
            const NotificationsListEvent.markAllAsRead(),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.blue700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Отметить все как прочитанные',
          style: AppTypography.buttonMedium1.white,
        ),
      ),
    );
  }
}
