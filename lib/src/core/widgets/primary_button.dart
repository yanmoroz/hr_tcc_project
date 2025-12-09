import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';
import '../theme/theme.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final String? icon;
  final PrimaryButtonSize size;
  final PrimatyButtonStyle style;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    required this.size,
    required this.style,
    this.enabled = true,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

enum PrimaryButtonSize {
  small,
  large;

  double get height => switch (this) {
    PrimaryButtonSize.small => 40,
    PrimaryButtonSize.large => 52,
  };
}

enum PrimatyButtonStyle {
  colored,
  white,
  transparent;

  Color get backgroundColor => switch (this) {
    PrimatyButtonStyle.colored => AppColors.blue700,
    PrimatyButtonStyle.white => AppColors.white,
    PrimatyButtonStyle.transparent => AppColors.transparent,
  };

  Color get borderColor => switch (this) {
    PrimatyButtonStyle.colored => AppColors.transparent,
    PrimatyButtonStyle.white => AppColors.grey500,
    PrimatyButtonStyle.transparent => AppColors.blue200,
  };

  double get borderWidth => switch (this) {
    PrimatyButtonStyle.colored => 0,
    PrimatyButtonStyle.white => 1,
    PrimatyButtonStyle.transparent => 1,
  };

  Color get textColor => switch (this) {
    PrimatyButtonStyle.colored => AppColors.white,
    PrimatyButtonStyle.white => AppColors.black,
    PrimatyButtonStyle.transparent => AppColors.white,
  };
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        height: widget.size.height,
        decoration: BoxDecoration(
          color: widget.enabled
              ? widget.style.backgroundColor
              : widget.style.backgroundColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: widget.style.borderWidth,
            color: widget.style.borderColor.withValues(
              alpha: widget.enabled ? 1 : 0.5,
            ),
          ),
        ),
        child: InkWell(
          onTap: (widget.enabled && !widget.isLoading)
              ? widget.onPressed
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              if (widget.isLoading) ...[
                _buildLoadingState(),
              ] else ...[
                _buildNormalState(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_animationController);
  }

  Widget _buildLoadingState() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.rotate(
        angle: _animation.value,
        child: SvgPicture.asset(
          Assets.icons.progressIcon,
          colorFilter: ColorFilter.mode(
            widget.style.textColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildNormalState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        if (widget.icon != null)
          SvgPicture.asset(
            widget.icon!,
            colorFilter: ColorFilter.mode(
              widget.style.textColor,
              BlendMode.srcIn,
            ),
          ),
        Text(
          widget.label,
          style: AppTypography.buttonMedium1.copyWith(
            color: widget.style.textColor,
          ),
        ),
      ],
    );
  }
}
