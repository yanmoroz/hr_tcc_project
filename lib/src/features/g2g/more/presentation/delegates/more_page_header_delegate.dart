import 'package:flutter/material.dart';

import '../../../../../core/widgets/widgets.dart';

class ShadowedUserBarDelegate extends SliverPersistentHeaderDelegate {
  final double extent;

  ShadowedUserBarDelegate({required this.extent});

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const UserInfoBar(enableCorners: true, showShadow: true);
  }

  @override
  bool shouldRebuild(covariant ShadowedUserBarDelegate oldDelegate) => false;
}
