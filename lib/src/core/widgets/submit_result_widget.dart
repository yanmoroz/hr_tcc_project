import 'dart:ui';

import 'package:flutter/material.dart';

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
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),
        // Content
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: onClose,
                    child: const Icon(
                      Icons.close,
                      size: 24,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Success/Error icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: isSuccess ? const Color(0xFF4CAF50) : Colors.red,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    isSuccess ? Icons.check : Icons.close,
                    size: 48,
                    color: isSuccess ? const Color(0xFF4CAF50) : Colors.red,
                  ),
                ),
                const SizedBox(height: 24),
                // Message
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
