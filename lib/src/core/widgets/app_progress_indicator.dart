import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppProgressIndicator extends StatelessWidget {
  final double? value;

  final Color? color;

  final double radius;

  final double strokeWidth;

  const AppProgressIndicator({
    this.value,
    this.color,
    this.radius = 10.0,
    this.strokeWidth = 4.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return CupertinoActivityIndicator(radius: radius, color: color);
    }

    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CircularProgressIndicator(
        value: value,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
