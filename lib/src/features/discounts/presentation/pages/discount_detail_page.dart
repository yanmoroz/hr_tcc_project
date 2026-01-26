import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/html_styles.dart';
import '../../../../core/widgets/comments_button.dart';
import '../../../../core/widgets/like_button.dart';
import '../../../../core/widgets/user_avatar.dart';
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
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            body: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DiscountDetailState state) {
    if (state.status == LoadingStatus.loading ||
        state.status == LoadingStatus.initial) {
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
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Duration and creation date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Duration badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getDurationText(discount.dateTo),
                    style: AppTypography.captionMedium2.black,
                  ),
                ),
                // Creation date
                if (discount.createDate != null)
                  Text(
                    _formatDateTime(discount.createDate!),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 21),

            // Author
            Row(
              children: [
                UserAvatar.fromName(
                  firstName: discount.author.firstName,
                  lastName: discount.author.lastName,
                  id: discount.author.id.toString(),
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Публикация',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        discount.author.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              discount.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (coverImage != null) const SizedBox(height: 16),

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
                      child: const Icon(Icons.image_not_supported, size: 64),
                    );
                  },
                ),
              ),

            // Description
            if (discount.description != null) ...[
              Html(
                data: discount.description,
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                  ...commonHtmlElementStyles,
                  "span": Style(fontSize: FontSize(16)),
                  "p": Style(fontSize: FontSize(16)),
                  "span.rte-document": Style(display: Display.none),
                  "a": Style(
                    color: AppColors.white,
                    textDecoration: TextDecoration.none,
                  ),
                },
              ),
              const SizedBox(height: 16),
            ],

            // Contact Info & Promo Code Container
            if (discount.contact != null ||
                discount.phone != null ||
                discount.email != null ||
                discount.site != null ||
                discount.promocode != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.blue500,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact Info
                    if (discount.phone != null) ...[
                      _buildContactInfoRow(
                        'Телефон',
                        discount.phone!,
                        onTap: () => _launchPhone(discount.phone!),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (discount.email != null) ...[
                      _buildContactInfoRow(
                        'Адрес',
                        discount.email!,
                        onTap: () => _launchEmail(discount.email!),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (discount.contact != null) ...[
                      _buildContactInfoRow(
                        'Контактное лицо',
                        discount.contact!,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (discount.site != null) ...[
                      _buildContactInfoRow(
                        'Сайт',
                        discount.site!,
                        onTap: () => _launchUrl(discount.site!),
                      ),
                      if (discount.promocode != null)
                        const SizedBox(height: 24),
                    ],

                    // Promo Code
                    if (discount.promocode != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A7FD5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Промокод',
                              style: AppTypography.textSemibold2.white,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  discount.promocode!,
                                  style: AppTypography.textMedium2.blue200,
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: discount.promocode!),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Промокод скопирован'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.copy_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Like and Comment buttons
            Row(
              children: [
                LikeButton(
                  isLiked: liked,
                  likeCount: likeCount,
                  likedTextStyle: AppTypography.textMedium2.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                  notLikedTextStyle: AppTypography.textMedium2.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                  likedIconColor: AppColors.white,
                  notLikedIconColor: AppColors.white.withValues(alpha: 0.7),
                  onPressed: () {
                    context.read<DiscountDetailBloc>().add(
                      const DiscountDetailEvent.toggleLike(),
                    );
                  },
                ),
                const SizedBox(width: 16),
                CommentsButton(
                  commentCount: commentCount,
                  textColor: AppColors.white,
                  iconColor: AppColors.white,
                  onPressed: () {
                    context.push('/home/comments/discount/${discount.id}');
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoRow(
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    final valueWidget = Text(
      value,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        decoration: onTap != null ? TextDecoration.underline : null,
        decorationColor: Colors.white,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        onTap != null
            ? GestureDetector(onTap: onTap, child: valueWidget)
            : valueWidget,
      ],
    );
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _getDurationText(DateTime? dateTo) {
    if (dateTo == null) {
      return 'Бессрочно';
    }
    return 'До ${DateFormat('dd.MM.yyyy').format(dateTo)}';
  }

  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    final timeFormat = DateFormat('HH:mm');

    if (dateToCheck == today) {
      return 'Вчера в ${timeFormat.format(date)}';
    } else {
      return '${DateFormat('dd.MM.yyyy').format(date)} в ${timeFormat.format(date)}';
    }
  }
}
