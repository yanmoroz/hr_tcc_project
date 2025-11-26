import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../blocs/discount_categories_page/bloc.dart';
import '../widgets/discount_category_card.dart';

class DiscountCategoriesPage extends StatelessWidget {
  const DiscountCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscountCategoriesBloc, DiscountCategoriesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Льготы и возможности')),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DiscountCategoriesState state) {
    if (state.status == LoadingStatus.initial ||
        state.status == LoadingStatus.loading) {
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
                context.read<DiscountCategoriesBloc>().add(
                  const DiscountCategoriesEvent.loadCategories(),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DiscountCategoriesBloc>().add(
          const DiscountCategoriesEvent.refreshCategories(),
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final category = state.categories[index];
          return DiscountCategoryCard(
            title: category.name,
            onTap: () {
              context.push(
                '/home/discounts',
                extra: {
                  'category': category.code.toString(),
                  'source': category.discountSourceCode.toString(),
                  'categoryName': category.name,
                },
              );
            },
          );
        },
      ),
    );
  }
}
