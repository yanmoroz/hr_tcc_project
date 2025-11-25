import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

import '../../../../../gen/fonts.gen.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../blocs/notification_detail/bloc.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key});

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
    return Scaffold(
      backgroundColor: Colors.white,
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
    final notification = state.notification;

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: REFACTORING
        // context.read<NotificationDetailBloc>().add(
        //   const NotificationDetailEvent.refreshDetail(),
        // );
        // Wait a moment for the refresh
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 48),
        children: [
          // Timestamp
          Text(
            notification.created.toRelativeTime(),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF767679),
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
              ..._commonHtmlElementStyles,
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
                ..._commonHtmlElementStyles,
              },
            ),
          ],
        ],
      ),
    );
  }
}
