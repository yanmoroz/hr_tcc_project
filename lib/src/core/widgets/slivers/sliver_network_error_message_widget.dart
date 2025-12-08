import 'package:flutter/material.dart';

import '../network_error_message_widget.dart';

class SliverNetworkErrorMessageWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const SliverNetworkErrorMessageWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: NetworkErrorMessageWidget(onRetry: onRetry),
    );
  }
}
