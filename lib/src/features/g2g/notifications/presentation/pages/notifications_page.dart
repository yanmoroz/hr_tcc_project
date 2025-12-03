import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../blocs/notifications_list/bloc.dart';
import '../widgets/notification_item.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
        appBar: AppBar(title: Text('Уведомления')),
        body: BlocBuilder<NotificationsListBloc, NotificationsListState>(
          builder: (context, state) {
            return switch (state.status) {
              LoadingStatus.initial => _buildLoadingState(),
              LoadingStatus.loading => _buildLoadingState(),
              LoadingStatus.error => _buildErrorState(context),
              LoadingStatus.success => _buildLoadedState(context, state),
            };
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: AppColors.grey200,
                highlightColor: AppColors.grey100,
                child: Container(
                  width: double.infinity,
                  height: 175,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: 10,
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return NetworkErrorMessageWidget(
      onRetry: () {
        context.read<NotificationsListBloc>().add(
          const NotificationsListEvent.loadNotifications(),
        );
      },
    );
  }

  Widget _buildLoadedState(BuildContext context, NotificationsListState state) {
    if (state.notifications.isEmpty) {
      return Center(
        child: Text('Нет уведомлений', style: AppTypography.textRegular1.black),
      );
    }

    return Stack(
      children: [
        // Notifications list
        AppRefreshIndicator(
          onRefresh: () async {
            context.read<NotificationsListBloc>().add(
              const NotificationsListEvent.refreshNotifications(),
            );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
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
            ),
          ),
        ),

        // Mark all as read button (bottom)
        if (state.unreadNotificationsCount > 0)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
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
              ),
            ),
          ),
      ],
    );
  }
}
