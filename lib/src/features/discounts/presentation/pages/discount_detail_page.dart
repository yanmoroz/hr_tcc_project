import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/bloc_factory.dart';
import '../bloc/discount_page/discount_detail_bloc.dart';
import '../bloc/discount_page/discount_detail_event.dart';
import '../bloc/discount_page/discount_detail_state.dart';

class DiscountDetailPage extends StatelessWidget {
  final int discountId;

  const DiscountDetailPage({
    super.key,
    required this.discountId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlocFactory.createDiscountDetailBloc(discountId)
        ..add(const DiscountDetailEvent.loadDetail()),
      child: BlocBuilder<DiscountDetailBloc, DiscountDetailState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Discount Detail')),
            body: state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (discount, likeCount, liked, commentCount) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<DiscountDetailBloc>().add(
                          const DiscountDetailEvent.refresh(),
                        );
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        if (discount.image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              discount.image!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported, size: 64),
                                );
                              },
                            ),
                          ),
                        if (discount.image != null) const SizedBox(height: 16),

                        // Title
                        Text(
                          discount.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),

                        // Category
                        if (discount.category != null)
                          Chip(
                            label: Text(discount.category!.title),
                            avatar: const Icon(Icons.category, size: 16),
                          ),
                        if (discount.category != null) const SizedBox(height: 16),

                        // Dates
                        if (discount.dateFrom != null && discount.dateTo != null)
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${_formatDate(discount.dateFrom!)} - ${_formatDate(discount.dateTo!)}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),

                        // Description
                        if (discount.description != null) ...[
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Html(data: discount.description),
                          const SizedBox(height: 16),
                        ],

                        // Contact Info
                        if (discount.contact != null ||
                            discount.phone != null ||
                            discount.email != null ||
                            discount.site != null) ...[
                          Text(
                            'Contact Information',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          if (discount.contact != null)
                            _buildInfoRow(context, Icons.person, discount.contact!),
                          if (discount.phone != null)
                            _buildInfoRow(context, Icons.phone, discount.phone!),
                          if (discount.email != null)
                            _buildInfoRow(context, Icons.email, discount.email!),
                          if (discount.site != null)
                            _buildInfoRow(context, Icons.language, discount.site!),
                          const SizedBox(height: 16),
                        ],

                        // Promo Code
                        if (discount.promocode != null) ...[
                          Card(
                            color: Colors.green[50],
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  const Icon(Icons.local_offer, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Promo Code: ${discount.promocode}',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[900],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Author
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(discount.author.title),
                            subtitle: discount.author.position != null
                                ? Text(discount.author.position!)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Like and Comment buttons
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<DiscountDetailBloc>().add(
                                      const DiscountDetailEvent.toggleLike(),
                                    );
                              },
                              icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
                              label: Text('$likeCount'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: liked ? Colors.red[50] : null,
                                foregroundColor: liked ? Colors.red : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/comments',
                                  arguments: {'entityId': discountId},
                                );
                              },
                              icon: const Icon(Icons.comment),
                              label: Text('$commentCount'),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                        context.read<DiscountDetailBloc>().add(
                              const DiscountDetailEvent.loadDetail(),
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
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}
