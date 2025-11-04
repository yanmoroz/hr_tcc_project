import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/bloc_factory.dart';
import '../bloc/discount_categories_page/discount_categories_bloc.dart';
import '../bloc/discount_categories_page/discount_categories_event.dart';
import '../bloc/discount_categories_page/discount_categories_state.dart';

class DiscountCategoriesPage extends StatelessWidget {
  const DiscountCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BlocFactory.createDiscountCategoriesBloc()..add(const DiscountCategoriesEvent.loadCategories()),
      child: BlocBuilder<DiscountCategoriesBloc, DiscountCategoriesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Discount Categories')),
            body: state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (categories, sources) {
                if (categories.isEmpty) {
                  return const Center(child: Text('No categories available'));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<DiscountCategoriesBloc>().add(const DiscountCategoriesEvent.refreshCategories());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(category.name, style: Theme.of(context).textTheme.titleMedium),
                          subtitle: category.discountSourceCode != null
                              ? Text('Source: ${category.discountSourceCode}')
                              : null,
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/discounts',
                              arguments: {'category': category.code, 'source': category.discountSourceCode},
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $message', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DiscountCategoriesBloc>().add(const DiscountCategoriesEvent.loadCategories());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
