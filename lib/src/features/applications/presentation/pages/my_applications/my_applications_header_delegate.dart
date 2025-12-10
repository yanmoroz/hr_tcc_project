import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/value_objects/status_group_type.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../blocs/applications_list_page/bloc.dart';
import '../../widgets/status_filter_tabs.dart';

class MyApplicationsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double userBarExtent;
  final double tabsExtent;
  final double searchBarExtent;
  final double collapsedExtent;
  final ApplicationsListState state;
  final Function(StatusGroupType?) onStatusGroupChanged;
  final Function(String) onSearchChanged;

  MyApplicationsHeaderDelegate({
    required this.userBarExtent,
    required this.tabsExtent,
    required this.searchBarExtent,
    required this.collapsedExtent,
    required this.state,
    required this.onStatusGroupChanged,
    required this.onSearchChanged,
  });

  @override
  double get maxExtent => userBarExtent + tabsExtent + searchBarExtent;

  @override
  double get minExtent => userBarExtent + collapsedExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Calculate visible heights
    final tabsAndSearchHeight = max(
      tabsExtent + searchBarExtent - shrinkOffset,
      collapsedExtent,
    );

    final tabsHeight = max(tabsExtent - shrinkOffset, 0.0);

    final searchBarHeight = max(
      tabsAndSearchHeight - tabsHeight,
      collapsedExtent,
    );

    // Calculate offsets for sliding effect
    // Tabs start sliding first
    final tabsOffset = min(shrinkOffset, tabsExtent);

    // Search bar starts sliding after tabs are gone
    final searchBarOffset = max(
      0.0,
      min(shrinkOffset - tabsExtent, searchBarExtent - collapsedExtent),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow300,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const UserInfoBar(enableCorners: false),
          if (state.statistics.isNotEmpty)
            SizedBox(
              height: tabsHeight,
              child: ClipRect(
                child: OverflowBox(
                  minHeight: tabsExtent,
                  maxHeight: tabsExtent,
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: Offset(0, -tabsOffset),
                    child: Container(
                      height: tabsExtent,
                      color: AppColors.white,
                      child: StatusFilterTabs(
                        statistics: state.statistics,
                        selectedStatusGroup: state.statusGroup,
                        onStatusGroupChanged: onStatusGroupChanged,
                      ),
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
                        hintText: 'Поиск по заявкам',
                        isLoading:
                            state.filteringStatus == LoadingStatus.loading,
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
  bool shouldRebuild(covariant MyApplicationsHeaderDelegate oldDelegate) =>
      state.filteringStatus != oldDelegate.state.filteringStatus ||
      state.statistics != oldDelegate.state.statistics ||
      state.statusGroup != oldDelegate.state.statusGroup ||
      userBarExtent != oldDelegate.userBarExtent ||
      tabsExtent != oldDelegate.tabsExtent ||
      searchBarExtent != oldDelegate.searchBarExtent;
}
