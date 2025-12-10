import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../theme/theme.dart';

class SliverShimmeringList extends StatelessWidget {
  final double spacing;
  final double maxHeight;
  final _random = Random();

  SliverShimmeringList({
    super.key,
    required this.spacing,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverList.separated(
          separatorBuilder: (context, index) => SizedBox(height: spacing),
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: AppColors.grey200,
            highlightColor: AppColors.grey100,
            child: Container(
              width: double.infinity,
              height: (1 + _random.nextDouble()) * maxHeight,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
