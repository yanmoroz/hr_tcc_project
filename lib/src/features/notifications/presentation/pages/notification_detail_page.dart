import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/html_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/domain.dart';
import '../blocs/notification_detail/bloc.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(),
      body: BlocBuilder<NotificationDetailBloc, NotificationDetailState>(
        builder: (context, state) {
          if (state.notification == null) {
            return const Center(child: AppProgressIndicator());
          }
          return _buildListView(state.notification!);
        },
      ),
    );
  }

  _buildListView(Notification notification) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
      children: [
        // Timestamp
        Text(
          notification.created.toRelativeTime(),
          style: AppTypography.captionMedium2.grey700,
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
              color: AppColors.black,
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
                color: AppColors.black,
              ),
              ...commonHtmlElementStyles,
            },
          ),
        ],
      ],
    );
  }
}
