import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../blocs/notification_detail_page/bloc.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<NotificationDetailBloc, NotificationDetailState>(
        builder: (context, state) {
          return _buildBody(context, state);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationDetailState state) {
    if (state.status == LoadingStatus.loading ||
        state.status == LoadingStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == LoadingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFF757575)),
            const SizedBox(height: 16),
            const Text(
              'Ошибка загрузки',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.errorMessage ?? 'Unknown error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<NotificationDetailBloc>().add(
                  const NotificationDetailEvent.refreshDetail(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    // Success state
    final notification = state.notification;

    if (notification == null) {
      return const Center(child: Text('No data available'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationDetailBloc>().add(
          const NotificationDetailEvent.refreshDetail(),
        );
        // Wait a moment for the refresh
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Timestamp
          Text(
            notification.created.toRelativeTime(),
            style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
          ),
          const SizedBox(height: 16),

          // Title (if available)
          if (notification.text != null &&
              (notification.text?.isNotEmpty ?? false)) ...[
            Html(
              data: notification.text!,
              style: {
                "body": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(24),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              },
            ),
            const SizedBox(height: 16),
          ],

          // Description
          Html(
            data: notification.notificationText,
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(16),
                color: const Color(0xFF212121),
                lineHeight: const LineHeight(1.5),
              ),
            },
          ),
        ],
      ),
    );
  }
}
