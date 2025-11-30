import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';

class SubmitResultWidget extends StatelessWidget {
  final VoidCallback onClose;
  final String message;
  final bool isSuccess;

  const SubmitResultWidget({
    super.key,
    required this.onClose,
    required this.message,
    this.isSuccess = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blur effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withValues(alpha: 0.3)),
        ),
        // Content
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: onClose,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        Assets.icons.closeIcon,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.black54,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                // Success/Error icon
                SvgPicture.asset(
                  isSuccess
                      ? Assets.icons.operationSuccessIcon
                      : Assets.icons.operationFailureIcon,
                  width: 76,
                  height: 76,
                  colorFilter: ColorFilter.mode(
                    isSuccess
                        ? const Color(0xFF44BF78)
                        : const Color(0xFFF6514C),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 30),
                // Message
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.left,
                ),

                SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String message,
    required bool isSuccess,
    VoidCallback? onClose,
  }) async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (dialogContext) => SubmitResultWidget(
        message: message,
        isSuccess: isSuccess,
        onClose: () {
          Navigator.of(dialogContext).pop();
          onClose?.call();
        },
      ),
    );
  }
}
