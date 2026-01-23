import 'package:flutter/material.dart';

import '../theme/theme.dart';

class AppCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double size;
  final Color? checkColor;
  final Color? activeColor;
  final Color? inactiveColor;

  const AppCheckBox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 24.0,
    this.checkColor,
    this.activeColor,
    this.inactiveColor,
  });

  bool get _isEnabled => onChanged != null;
  bool get _isChecked => value == true;

  Color get _backgroundColor {
    if (_isChecked) {
      return _isEnabled
          ? (activeColor ?? AppColors.blue500)
          : AppColors.grey500;
    }
    return _isEnabled ? AppColors.white : AppColors.grey200;
  }

  Color get _borderColor {
    if (_isChecked) return AppColors.transparent;
    return _isEnabled
        ? (inactiveColor ?? AppColors.blue500)
        : AppColors.grey500;
  }

  Color get _checkmarkColor {
    final baseColor = checkColor ?? AppColors.white;
    return _isEnabled ? baseColor : baseColor.withValues(alpha: 0.5);
  }

  void _handleTap() {
    if (_isEnabled) {
      onChanged!(!value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      enabled: _isEnabled,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                width: _isChecked ? 0 : 2,
                color: _borderColor,
              ),
            ),
            child: _isChecked
                ? Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: 1.0,
                      curve: Curves.easeInOut,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: 1.0,
                        curve: Curves.easeInOut,
                        child: CustomPaint(
                          size: Size(size * 0.6, size * 0.6),
                          painter: _CheckmarkPainter(color: _checkmarkColor),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final Color color;

  const _CheckmarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.5)
      ..lineTo(size.width * 0.45, size.height * 0.7)
      ..lineTo(size.width * 0.75, size.height * 0.3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
