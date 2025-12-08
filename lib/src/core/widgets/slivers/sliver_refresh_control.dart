import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliverRefreshControl extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const SliverRefreshControl({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      builder: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoSliverRefreshControl.buildRefreshIndicator
          : _buildAndroidRefreshIndicator,
      onRefresh: onRefresh,
    );
  }

  Widget _buildAndroidRefreshIndicator(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {
    const Curve opacityCurve = const Interval(
      0.4,
      0.8,
      curve: Curves.easeInOut,
    );
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: refreshState == RefreshIndicatorMode.drag
            ? Opacity(
                opacity: opacityCurve.transform(
                  min(pulledExtent / refreshTriggerPullDistance, 1.0),
                ),
                child: const Icon(
                  Icons.arrow_downward,
                  color: CupertinoColors.inactiveGray,
                  size: 24.0,
                ),
              )
            : Opacity(
                opacity: opacityCurve.transform(
                  min(pulledExtent / refreshIndicatorExtent, 1.0),
                ),
                child: const CircularProgressIndicator(strokeWidth: 2.0),
              ),
      ),
    );
  }
}
