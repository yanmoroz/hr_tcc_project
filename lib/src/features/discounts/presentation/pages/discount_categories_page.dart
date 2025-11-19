import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/discount_categories_page/bloc.dart';
import '../widgets/discount_category_card.dart';

class DiscountCategoriesPage extends StatelessWidget {
  const DiscountCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscountCategoriesBloc, DiscountCategoriesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Льготы и возможности')),
          body: state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (categories, sources) {
              if (categories.isEmpty) {
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
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return DiscountCategoryCard(
                      title: category.name,
                      onTap: () {
                        context.push(
                          '/discounts',
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
                      context.read<DiscountCategoriesBloc>().add(
                        const DiscountCategoriesEvent.loadCategories(),
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
