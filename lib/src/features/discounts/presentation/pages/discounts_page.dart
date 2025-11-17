import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/discounts_page/discounts_list_bloc.dart';
import '../bloc/discounts_page/discounts_list_event.dart';
import '../bloc/discounts_page/discounts_list_state.dart';
import '../widgets/discount_card.dart';

class DiscountsPage extends StatefulWidget {
  const DiscountsPage({super.key});

  @override
  State<DiscountsPage> createState() => _DiscountsPageState();
}

class _DiscountsPageState extends State<DiscountsPage> {
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
      context.read<DiscountsListBloc>().add(
        const DiscountsListEvent.loadMoreDiscounts(),
      );
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
    return BlocBuilder<DiscountsListBloc, DiscountsListState>(
      builder: (context, state) {
        String appBarTitle = 'Льготы и возможности';
        state.maybeWhen(
          loaded: (_, __, ___, ____, _____, ______, _______, categoryName) {
            if (categoryName != null) {
              appBarTitle = categoryName;
            }
          },
          orElse: () {},
        );

        return Scaffold(
          appBar: AppBar(title: Text(appBarTitle)),
          body: state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded:
                (
                  discounts,
                  currentPage,
                  hasMorePages,
                  isLoadingMore,
                  coverImages,
                  category,
                  source,
                  categoryName,
                ) {
                  if (discounts.isEmpty) {
                    return const Center(child: Text('No discounts available'));
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<DiscountsListBloc>().add(
                        DiscountsListEvent.refreshDiscounts(
                          category: category,
                          source: source,
                          categoryName: categoryName,
                        ),
                      );
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: discounts.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= discounts.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final discount = discounts[index];
                        return DiscountCard(
                          discount: discount,
                          onTap: () {
                            context.push('/discount/${discount.id}');
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
                  Text(
                    'Error: $message',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final args =
                          ModalRoute.of(context)?.settings.arguments
                              as Map<String, dynamic>?;
                      final categoryCode = args?['category'] as int?;
                      final sourceCode = args?['source'] as int?;
                      context.read<DiscountsListBloc>().add(
                        DiscountsListEvent.loadDiscounts(
                          category: categoryCode,
                          source: sourceCode,
                        ),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
