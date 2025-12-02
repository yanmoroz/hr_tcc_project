import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_html/flutter_html.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/html_styles.dart';
import '../../domain/domain.dart';

class NotificationItem extends StatelessWidget {
  final Notification notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 170),
        child: ClipRect(
          child: Material(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            elevation: 0,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Timestamp with green dot (for unread) or without (for read)
                            Row(
                              children: [
                                if (!notification.isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.green500,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                Text(
                                  notification.created.toRelativeTime(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grey700,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),

                            // Title (if available)
                            const SizedBox(height: 8),
                            Html(
                              data: notification.notificationText,
                              style: {
                                "body": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                  fontSize: FontSize(16),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                                ...commonHtmlElementStyles,
                              },
                            ),

                            // Body text
                            if (notification.text != null &&
                                notification.text!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Flexible(
                                child: Html(
                                  data: notification.text!,
                                  style: {
                                    "body": Style(
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                      fontSize: FontSize(14),
                                      color: AppColors.grey700,
                                    ),
                                    ...commonHtmlElementStyles,
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Chevron icon - vertically centered
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.chevron_right,
                          color: AppColors.grey700,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
