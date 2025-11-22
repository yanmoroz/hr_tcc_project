import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../blocs/discounts_page/bloc.dart';
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
        final appBarTitle = state.status == LoadingStatus.success
            ? state.categoryName ?? ''
            : '';

        return Scaffold(
          appBar: AppBar(title: Text(appBarTitle)),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DiscountsListState state) {
    if (state.status == LoadingStatus.loading || state.status == LoadingStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == LoadingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.errorMessage ?? 'Unknown error'}',
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
      );
    }

    // Success state
    final discounts = state.discounts;
    final isLoadingMore = state.isLoadingMore;
    final category = state.category;
    final source = state.source;
    final categoryName = state.categoryName;

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
            onLikeTap: () {
              context.read<DiscountsListBloc>().add(
                DiscountsListEvent.toggleDiscountLike(
                  discountId: discount.id,
                ),
              );
            },
            onCommentTap: () {
              // Get current state to preserve filters when refreshing
              final bloc = context.read<DiscountsListBloc>();
              final currentState = bloc.state;

              context.push('/comments/discount/${discount.id}').then((_) {
                // Refresh discounts list when returning from comments
                bloc.add(
                  DiscountsListEvent.refreshDiscounts(
                    category: currentState.category,
                    source: currentState.source,
                    categoryName: currentState.categoryName,
                  ),
                );
              });
            },
          );
        },
      ),
    );
  }
}
