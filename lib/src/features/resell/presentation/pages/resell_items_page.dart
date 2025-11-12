import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc_project/src/core/di/service_locator.dart';
import 'package:hr_tcc_project/src/features/resell/presentation/bloc/resell_items_bloc.dart';
import 'package:hr_tcc_project/src/features/resell/presentation/bloc/resell_items_event.dart';
import 'package:hr_tcc_project/src/features/resell/presentation/bloc/resell_items_state.dart';
import 'package:hr_tcc_project/src/features/resell/presentation/widgets/resell_item_card.dart';
import 'package:hr_tcc_project/src/features/resell/presentation/widgets/resell_status_chip.dart';

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
      sl<ResellItemsBloc>().add(const ResellItemsEvent.loadMore());
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
    return BlocProvider(
      create: (context) => sl<ResellItemsBloc>()..add(const ResellItemsEvent.loadResellItems()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Барахолка')),
        body: Column(
          children: [
            // Status Filter
            BlocBuilder<ResellItemsBloc, ResellItemsState>(
              builder: (context, state) {
                final currentStatus = state.maybeWhen(loaded: (_, __, ___, ____, status) => status, orElse: () => 1);

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ResellStatusChip(
                        label: 'Активные',
                        isSelected: currentStatus == 1,
                        onTap: () => context.read<ResellItemsBloc>().add(const ResellItemsEvent.filterByStatus(1)),
                      ),
                      ResellStatusChip(
                        label: 'Забронированные',
                        isSelected: currentStatus == 2,
                        onTap: () => context.read<ResellItemsBloc>().add(const ResellItemsEvent.filterByStatus(2)),
                      ),
                      ResellStatusChip(
                        label: 'Все',
                        isSelected: currentStatus == 0,
                        onTap: () => context.read<ResellItemsBloc>().add(const ResellItemsEvent.filterByStatus(0)),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Items List
            Expanded(
              child: BlocBuilder<ResellItemsBloc, ResellItemsState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const Center(child: CircularProgressIndicator()),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    loaded: (items, _, hasMore, isLoadingMore, __) {
                      if (items.isEmpty) {
                        return const Center(child: Text('Нет товаров'));
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<ResellItemsBloc>().add(const ResellItemsEvent.refreshItems());
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: items.length + (isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= items.length) {
                              return const Center(
                                child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
                              );
                            }

                            final item = items[index];
                            return ResellItemCard(
                              item: item,
                              onTap: () {
                                Navigator.pushNamed(context, '/resell-detail', arguments: item.id);
                              },
                            );
                          },
                        ),
                      );
                    },
                    error: (message) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Ошибка: $message'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ResellItemsBloc>().add(const ResellItemsEvent.loadResellItems());
                            },
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
