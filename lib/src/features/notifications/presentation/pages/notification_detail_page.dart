import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/html_styles.dart';
import '../../domain/domain.dart';
import '../blocs/notification_detail/bloc.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
    switch (state.status) {
      case LoadingStatus.initial:
      case LoadingStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadingStatus.error:
        return Center(child: Text(state.errorMessage ?? 'Unknown error'));
      case LoadingStatus.success:
        return _buildListView(state.notification!);
    }
  }

  _buildListView(Notification notification) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 48),
      children: [
        // Timestamp
        Text(
          notification.created.toRelativeTime(),
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey700,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),

        // Title (if available)
        Html(
          data: notification.notificationText,
          style: {
            "body": Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
              fontSize: FontSize(24),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
              lineHeight: const LineHeight(1.5),
            ),
            ...commonHtmlElementStyles,
          },
        ),

        const SizedBox(height: 21),

        // Description
        if (notification.text != null &&
            (notification.text?.isNotEmpty ?? false)) ...[
          Html(
            data: notification.text!,
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(16),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF212121),
              ),
              ...commonHtmlElementStyles,
            },
          ),
        ],
      ],
    );
  }
}
