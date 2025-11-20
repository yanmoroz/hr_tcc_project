import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const InfoBox({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? const Color(0xFF1B5E20),
          fontSize: 14,
        ),
      ),
    );
  }
}
