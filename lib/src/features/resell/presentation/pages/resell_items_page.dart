import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/delegates/delegates.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/pluralization.dart';
import '../../../../core/widgets/widgets.dart';
import '../blocs/resell_items_page/bloc.dart';
import '../widgets/resell_item_card.dart';

class ResellItemsPage extends StatefulWidget {
  const ResellItemsPage({super.key});

  @override
  State<ResellItemsPage> createState() => _ResellItemsPageState();
}

class _ResellItemsPageState extends State<ResellItemsPage> {
  final ScrollController _scrollController = ScrollController();

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        appBar: AppBar(
          title: BlocSelector<ResellItemsBloc, ResellItemsState, int>(
            selector: (state) => state.totalOnSale + state.totalReserved,
            builder: (context, totalCount) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Реализация имущества'),
                  if (totalCount > 0)
                    Text(
                      _getItemCountText(totalCount),
                      style: AppTypography.textRegular2.grey700,
                    )
                  else
                    const SizedBox(height: 18),
                ],
              );
            },
          ),
        ),
        body: BlocListener<ResellItemsBloc, ResellItemsState>(
          listenWhen: (previous, current) =>
              previous.bookingItemId != current.bookingItemId ||
              previous.isBooking != current.isBooking,
          listener: (context, state) {
            if (state.bookingItemId != null && !state.isBooking) {
              final itemId = state.bookingItemId!;
              context.push('/home/resell/booking/$itemId').then((_) {
                context.read<ResellItemsBloc>()
                  ..add(const ResellItemsEvent.clearBookingState())
                  ..add(const ResellItemsEvent.refreshItems());
              });
            }

            if (state.errorMessage != null && !state.isBooking) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ошибка: ${state.errorMessage}'),
                ),
              );
            }
          },
          child: BlocBuilder<ResellItemsBloc, ResellItemsState>(
            builder: (context, state) {
              final currentStatus = state.currentStatus;

              return CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: FiltersAndSearchBarsHeaderDelegate(
                    filtersBar: FiltersBar<int>(
                      items: [
                        FilterItem(
                          value: 1,
                          label: 'В продаже',
                          count: state.totalOnSale,
                        ),
                        FilterItem(
                          value: 2,
                          label: 'Забронировано',
                          count: state.totalReserved,
                        ),
                      ],
                      selectedValue: currentStatus,
                      onFilterChanged: (value) {
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(0);
                        }
                        context
                            .read<ResellItemsBloc>()
                            .add(ResellItemsEvent.filterByStatus(value ?? 1));
                      },
                    ),
                    filtersExtent: 62.0,
                    searchHint: 'Поиск',
                    isSearchLoading:
                        state.filteringStatus == LoadingStatus.loading,
                    onSearchChanged: (query) {
                      if (_scrollController.hasClients) {
                        _scrollController.jumpTo(0);
                      }
                      context.read<ResellItemsBloc>().add(
                        ResellItemsEvent.changeSearchQuery(
                          query.isEmpty ? null : query,
                        ),
                      );
                    },
                  ),
                ),
                SliverRefreshControl(
                  onRefresh: () async {
                    context.read<ResellItemsBloc>().add(
                      const ResellItemsEvent.refreshItems(),
                    );
                  },
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: _buildContent(context, state),
                ),
              ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Widget _buildContent(BuildContext context, ResellItemsState state) {
    if (state.status == LoadingStatus.loading ||
        state.status == LoadingStatus.initial) {
      return SliverShimmeringList(spacing: 8, maxHeight: 120);
    }

    if (state.status == LoadingStatus.error) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: NetworkErrorMessageWidget(
          onRetry: () => context.read<ResellItemsBloc>().add(
            const ResellItemsEvent.loadResellItems(),
          ),
        ),
      );
    }

    // Success state
    final items = state.items;

    if (items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('Нет товаров', style: AppTypography.textRegular1.black),
        ),
      );
    }

    return SliverList.separated(
      itemCount: items.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: AppProgressIndicator(),
            ),
          );
        }

        final item = items[index];
        final coverImage = state.coverImages[item.id];
        return ResellItemCard(
          item: item,
          coverImage: coverImage,
          onBookPressed: state.currentStatus == 1
              ? () => context
                  .read<ResellItemsBloc>()
                  .add(ResellItemsEvent.bookItem(item.id))
              : null,
          onTap: () {
            context.push('/home/resell/detail/${item.id}');
          },
        );
      },
    );
  }

  String _getItemCountText(int count) {
    return pluralizeRu(count, '$count лот', '$count лота', '$count лотов');
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ResellItemsBloc>().add(const ResellItemsEvent.loadMore());
    }
  }
}
