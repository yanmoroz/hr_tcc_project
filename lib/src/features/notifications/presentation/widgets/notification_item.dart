import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_html/flutter_html.dart';

import '../../../../../gen/fonts.gen.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../domain/domain.dart';

class NotificationItem extends StatelessWidget {
  final Notification notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  // Common HTML element styles to prevent font family from being overridden by deeper nodes
  static final Map<String, Style> _commonHtmlElementStyles = {
    "p": Style(
      fontFamily: FontFamily.sFProDisplay,
      margin: Margins.zero,
      padding: HtmlPaddings.zero,
    ),
    "div": Style(
      fontFamily: FontFamily.sFProDisplay,
      margin: Margins.zero,
      padding: HtmlPaddings.zero,
    ),
    "span": Style(fontFamily: FontFamily.sFProDisplay),
    "strong": Style(fontFamily: FontFamily.sFProDisplay),
    "b": Style(fontFamily: FontFamily.sFProDisplay),
    "em": Style(fontFamily: FontFamily.sFProDisplay),
    "i": Style(fontFamily: FontFamily.sFProDisplay),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 170),
        child: ClipRect(
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            elevation: 0,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF44BF78),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                Text(
                                  notification.created.toRelativeTime(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF767679),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: FontFamily.sFProDisplay,
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
                                  fontFamily: FontFamily.sFProDisplay,
                                  color: const Color(0xFF212121),
                                ),
                                ..._commonHtmlElementStyles,
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
                                      fontFamily: FontFamily.sFProDisplay,
                                      color: const Color(0xFF757575),
                                    ),
                                    ..._commonHtmlElementStyles,
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
                          color: const Color(0xFF9E9E9E),
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
