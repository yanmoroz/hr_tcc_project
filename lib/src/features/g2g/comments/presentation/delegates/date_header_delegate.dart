import 'package:flutter/material.dart';

import '../widgets/date_separator.dart';

class DateHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DateTime date;

  DateHeaderDelegate({required this.date});

  @override
  double get maxExtent => 20.0 + 32.0;

  @override
  double get minExtent => 20.0 + 32.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DateSeparator(date: date);
  }

  @override
  bool shouldRebuild(DateHeaderDelegate oldDelegate) {
    return date != oldDelegate.date;
  }
}
