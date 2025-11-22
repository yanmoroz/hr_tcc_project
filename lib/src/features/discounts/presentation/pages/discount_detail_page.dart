import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/widgets/comments_button.dart';
import '../../../../core/widgets/like_button.dart';
import '../blocs/discount_page/bloc.dart';

class DiscountDetailPage extends StatelessWidget {
  const DiscountDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscountDetailBloc, DiscountDetailState>(
      builder: (context, state) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            scaffoldBackgroundColor: Color(0xFF3F6FD4),
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF3F6FD4),
              foregroundColor: Colors.white,
            ),
          ),
          child: Scaffold(
            appBar: AppBar(),
            body: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DiscountDetailState state) {
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
                context.read<DiscountDetailBloc>().add(
                  const DiscountDetailEvent.loadDetail(),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Success state
    final discount = state.discount;
    final likeCount = state.likeCount;
    final liked = state.liked;
    final commentCount = state.commentCount;
    final coverImage = state.coverImage;

    if (discount == null) {
      return const Center(child: Text('No data available'));
    }

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
            if (coverImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  coverImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 64,
                      ),
                    );
                  },
                ),
              ),
            if (coverImage != null) const SizedBox(height: 16),

            // Title
            Text(
              discount.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
              Html(data: discount.description),
              const SizedBox(height: 16),
            ],

            // Contact Info
            if (discount.contact != null ||
                discount.phone != null ||
                discount.email != null ||
                discount.site != null) ...[
              if (discount.contact != null)
                _buildInfoRow(
                  context,
                  Icons.person,
                  discount.contact!,
                ),
              if (discount.phone != null)
                _buildInfoRow(
                  context,
                  Icons.phone,
                  discount.phone!,
                ),
              if (discount.email != null)
                _buildInfoRow(
                  context,
                  Icons.email,
                  discount.email!,
                ),
              if (discount.site != null)
                _buildInfoRow(
                  context,
                  Icons.language,
                  discount.site!,
                ),
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
                      const Icon(
                        Icons.local_offer,
                        color: Colors.green,
                      ),
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
                LikeButton(
                  isLiked: liked,
                  likeCount: likeCount,
                  onPressed: () {
                    context.read<DiscountDetailBloc>().add(
                      const DiscountDetailEvent.toggleLike(),
                    );
                  },
                ),
                const SizedBox(width: 16),
                CommentsButton(
                  commentCount: commentCount,
                  onPressed: () {
                    context.push(
                      '/comments/discount/${discount.id}',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
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
