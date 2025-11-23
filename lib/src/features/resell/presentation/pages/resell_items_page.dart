import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../blocs/resell_items_page/bloc.dart';
import '../widgets/resell_item_card.dart';
import '../widgets/resell_status_chip.dart';

class ResellItemsPage extends StatefulWidget {
  const ResellItemsPage({super.key});

  @override
  State<ResellItemsPage> createState() => _ResellItemsPageState();
}

class _ResellItemsPageState extends State<ResellItemsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ResellItemsBloc>().add(const ResellItemsEvent.loadMore());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Барахолка')),
      body: BlocBuilder<ResellItemsBloc, ResellItemsState>(
        builder: (context, state) {
          final currentStatus = state.status == LoadingStatus.success
              ? state.currentStatus
              : 1;

          return Column(
            children: [
              // Status Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ResellStatusChip(
                      label: 'Активные',
                      isSelected: currentStatus == 1,
                      onTap: () => context.read<ResellItemsBloc>().add(
                        const ResellItemsEvent.filterByStatus(1),
                      ),
                    ),
                    ResellStatusChip(
                      label: 'Забронированные',
                      isSelected: currentStatus == 2,
                      onTap: () => context.read<ResellItemsBloc>().add(
                        const ResellItemsEvent.filterByStatus(2),
                      ),
                    ),
                    ResellStatusChip(
                      label: 'Все',
                      isSelected: currentStatus == 0,
                      onTap: () => context.read<ResellItemsBloc>().add(
                        const ResellItemsEvent.filterByStatus(0),
                      ),
                    ),
                  ],
                ),
              ),

              // Items List
              Expanded(
                child: _buildBody(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ResellItemsState state) {
    if (state.status == LoadingStatus.loading || state.status == LoadingStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == LoadingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ошибка: ${state.errorMessage ?? 'Unknown error'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ResellItemsBloc>().add(
                  const ResellItemsEvent.loadResellItems(),
                );
              },
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    // Success state
    final items = state.items;
    final isLoadingMore = state.isLoadingMore;

    if (items.isEmpty) {
      return const Center(child: Text('Нет товаров'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ResellItemsBloc>().add(
          const ResellItemsEvent.refreshItems(),
        );
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: items.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final item = items[index];
          return ResellItemCard(
            item: item,
            onTap: () {
              context.push('/home/resell/detail/${item.id}');
            },
          );
        },
      ),
    );
  }
}
