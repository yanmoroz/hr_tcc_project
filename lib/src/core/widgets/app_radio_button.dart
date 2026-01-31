import 'package:flutter/material.dart';

import '../theme/theme.dart';

class AppRadioButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const AppRadioButton({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 24.0,
    this.activeColor,
    this.inactiveColor,
  });

  bool get _isEnabled => onChanged != null;
  bool get _isSelected => value == true;

  Color get _backgroundColor {
    // Both selected and unselected have white/grey background
    return _isEnabled ? AppColors.white : AppColors.grey200;
  }

  Color get _borderColor {
    // Both selected and unselected have blue/grey border
    return _isEnabled
        ? (activeColor ?? AppColors.blue500)
        : AppColors.grey500;
  }

  Color get _innerDotColor {
    // Inner dot is blue (same as border) when selected
    return _isEnabled
        ? (activeColor ?? AppColors.blue500)
        : AppColors.grey500;
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
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: _borderColor,
              ),
            ),
            child: _isSelected
                ? Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: 1.0,
                      curve: Curves.easeInOut,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: 1.0,
                        curve: Curves.easeInOut,
                        child: Container(
                          width: size * 0.5,
                          height: size * 0.5,
                          decoration: BoxDecoration(
                            color: _innerDotColor,
                            shape: BoxShape.circle,
                          ),
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
