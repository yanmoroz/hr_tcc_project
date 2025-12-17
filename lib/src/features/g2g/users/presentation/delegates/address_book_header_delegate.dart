import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../blocs/address_book/bloc.dart';

class AddressBookHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double userBarExtent;
  final double searchBarExtent;
  final double searchBarMinHeight;
  final AddressBookState state;
  final Function(String) onSearchChanged;

  AddressBookHeaderDelegate({
    required this.userBarExtent,
    required this.searchBarExtent,
    required this.searchBarMinHeight,
    required this.state,
    required this.onSearchChanged,
  });

  @override
  double get maxExtent => userBarExtent + searchBarExtent;

  @override
  double get minExtent => userBarExtent + searchBarMinHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final searchBarHeight = max(
      searchBarExtent - shrinkOffset,
      searchBarMinHeight,
    );

    // Calculate how much the search bar should be offset (pushed up)
    final searchBarOffset = min(
      shrinkOffset,
      searchBarExtent - searchBarMinHeight,
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
          const UserInfoBar(enableCorners: false),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: SearchBarWidget(
                        hintText: 'Поиск',
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
  bool shouldRebuild(covariant AddressBookHeaderDelegate oldDelegate) =>
      state.filteringStatus != oldDelegate.state.filteringStatus ||
      userBarExtent != oldDelegate.userBarExtent ||
      searchBarExtent != oldDelegate.searchBarExtent;
}
