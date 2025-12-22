import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../widgets/widgets.dart';

class FiltersAndSearchBarsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget? headerWidget;
  final double headerExtent;
  final Widget filtersBar;
  final double filtersExtent;
  final double searchBarExtent;
  final double collapsedExtent;
  final String searchHint;
  final bool isSearchLoading;
  final ValueChanged<String> onSearchChanged;

  FiltersAndSearchBarsHeaderDelegate({
    this.headerWidget,
    this.headerExtent = 0.0,
    required this.filtersBar,
    required this.filtersExtent,
    this.searchBarExtent = 60.0,
    this.collapsedExtent = 8.0,
    required this.searchHint,
    this.isSearchLoading = false,
    required this.onSearchChanged,
  });

  @override
  double get maxExtent => headerExtent + filtersExtent + searchBarExtent;

  @override
  double get minExtent => headerExtent + collapsedExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Calculate visible heights
    final filtersAndSearchHeight = max(
      filtersExtent + searchBarExtent - shrinkOffset,
      collapsedExtent,
    );

    final filtersHeight = max(filtersExtent - shrinkOffset, 0.0);

    final searchBarHeight = max(
      filtersAndSearchHeight - filtersHeight,
      collapsedExtent,
    );

    // Calculate offsets for sliding effect
    // Filters start sliding first
    final filtersOffset = min(shrinkOffset, filtersExtent);

    // Search bar starts sliding after filters are gone
    final searchBarOffset = max(
      0.0,
      min(shrinkOffset - filtersExtent, searchBarExtent - collapsedExtent),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (headerWidget != null) headerWidget!,
          if (filtersExtent > 0)
            SizedBox(
              height: filtersHeight,
              child: ClipRect(
                child: OverflowBox(
                  minHeight: filtersExtent,
                  maxHeight: filtersExtent,
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: Offset(0, -filtersOffset),
                    child: Container(
                      height: filtersExtent,
                      color: AppColors.white,
                      child: filtersBar,
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(
            height: searchBarHeight,
            child: ClipRect(
              child: OverflowBox(
                minHeight: searchBarExtent,
                maxHeight: searchBarExtent,
                alignment: Alignment.topCenter,
                child: Transform.translate(
                  offset: Offset(0, -searchBarOffset),
                  child: Container(
                    height: searchBarExtent,
                    color: AppColors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: SearchBarWidget(
                        hintText: searchHint,
                        isLoading: isSearchLoading,
                        onSearchChanged: onSearchChanged,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant FiltersAndSearchBarsHeaderDelegate oldDelegate) =>
      headerWidget != oldDelegate.headerWidget ||
      headerExtent != oldDelegate.headerExtent ||
      filtersBar != oldDelegate.filtersBar ||
      filtersExtent != oldDelegate.filtersExtent ||
      searchBarExtent != oldDelegate.searchBarExtent ||
      collapsedExtent != oldDelegate.collapsedExtent ||
      searchHint != oldDelegate.searchHint ||
      isSearchLoading != oldDelegate.isSearchLoading;
}
