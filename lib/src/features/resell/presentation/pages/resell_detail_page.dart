import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc_project/src/core/entities/system_status.dart';
import 'package:intl/intl.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/domain.dart';
import '../blocs/resell_detail_page/bloc.dart';

class ResellDetailPage extends StatefulWidget {
  final String itemId;

  const ResellDetailPage({super.key, required this.itemId});

  @override
  State<ResellDetailPage> createState() => _ResellDetailPageState();
}

class _ResellDetailPageState extends State<ResellDetailPage> {
  int _currentImagePage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResellDetailBloc, ResellDetailState>(
      listenWhen: (previous, current) =>
          previous.isBooking != current.isBooking,
      listener: (context, state) {
        // Navigate to booking page when booking is initiated
        if (state.isBooking) {
          context
              .push(
                '/home/resell/booking/${widget.itemId}',
                extra: {'itemName': state.detail?.name ?? ''},
              )
              .then((_) {
                // Reload detail when booking page is closed
                context.read<ResellDetailBloc>().add(
                  const ResellDetailEvent.loadResellDetail(),
                );
              });
        }

        // Handle error
        if (state.status == LoadingStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка: ${state.errorMessage ?? 'Unknown error'}'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: AppColors.white,
        body: BlocBuilder<ResellDetailBloc, ResellDetailState>(
          builder: (context, state) {
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ResellDetailState state) {
    if (state.status == LoadingStatus.loading ||
        state.status == LoadingStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == LoadingStatus.error && state.detail == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ошибка: ${state.errorMessage ?? 'Unknown error'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ResellDetailBloc>().add(
                  const ResellDetailEvent.loadResellDetail(),
                );
              },
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    // Success state
    final detail = state.detail;

    if (detail == null) {
      return const Center(child: Text('No data available'));
    }

    return _buildDetailContent(context, state);
  }

  Widget _buildBottomButtonContainer(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SafeArea(
        top: false,
        child: PrimaryButton(
          label: 'Забронировать',
          size: PrimaryButtonSize.large,
          style: PrimatyButtonStyle.colored,
          onPressed: () {
            context.read<ResellDetailBloc>().add(
              const ResellDetailEvent.bookResellItem(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, ResellDetailState state) {
    final detail = state.detail!;
    final priceFormat = NumberFormat('#,###', 'ru_RU');

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Header: Status badge and date
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusBadge(detail.status),
                      Text(
                        _formatDate(detail.creationDate),
                        style: AppTypography.captionMedium2.copyWith(
                          color: AppColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Image carousel
                _buildImageCarousel(detail, state.carouselImages),
                const SizedBox(height: 16),

                // Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${priceFormat.format(detail.price).replaceAll(',', ' ')} ₽',
                    style: AppTypography.titleBold2,
                  ),
                ),
                const SizedBox(height: 8),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(detail.name, style: AppTypography.textSemibold1),
                ),
                const SizedBox(height: 16),

                // Info sections
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Equipment Type
                      _buildInfoSection('Тип', detail.equipmentType.name),

                      // Author
                      if (detail.author != null) ...[
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          'Ответственный',
                          '${detail.author!.lastName} ${detail.author!.firstName}${detail.author!.middleName != null ? ' ${detail.author!.middleName}' : ''}',
                        ),
                      ],

                      // Location
                      if (detail.location != null) ...[
                        const SizedBox(height: 16),
                        _buildInfoSection('Расположение', detail.location!),
                      ],

                      // Description
                      if (detail.description != null) ...[
                        const SizedBox(height: 16),
                        _buildInfoSection('Описание', detail.description!),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Pinned bottom button
        if (!detail.bookingFinish) _buildBottomButtonContainer(context),
      ],
    );
  }

  Widget _buildImageCarousel(
    ResellDetail detail,
    Map<String, Uint8List> carouselImages,
  ) {
    // Build list of photo IDs (generalPhoto first, then photo list)
    final photoIds = <String>[];
    if (detail.generalPhoto != null && detail.generalPhoto!.isNotEmpty) {
      photoIds.add(detail.generalPhoto!);
    }
    if (detail.photo != null) {
      for (final photoId in detail.photo!) {
        if (!photoIds.contains(photoId)) {
          photoIds.add(photoId);
        }
      }
    }

    final hasMultiplePhotos = photoIds.length > 1;

    Widget imageWidget;

    if (photoIds.isNotEmpty) {
      imageWidget = PageView.builder(
        itemCount: photoIds.length,
        onPageChanged: (index) {
          setState(() {
            _currentImagePage = index;
          });
        },
        itemBuilder: (context, index) {
          final photoId = photoIds[index];
          final imageBytes = carouselImages[photoId];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: imageBytes != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey200, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder();
                        },
                      ),
                    ),
                  )
                : _buildImageLoadingPlaceholder(),
          );
        },
      );
    } else {
      imageWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildImagePlaceholder(),
      );
    }

    return SizedBox(
      height: 228,
      child: Stack(
        children: [
          imageWidget,
          if (hasMultiplePhotos)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${_currentImagePage + 1} / ${photoIds.length}',
                    style: AppTypography.captionMedium2.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageLoadingPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.image, size: 80, color: AppColors.grey500),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.captionMedium2.copyWith(
            color: AppColors.grey700,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.textRegular1),
      ],
    );
  }

  Widget _buildStatusBadge(SystemStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusBadgeColor(status),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.name,
        style: AppTypography.captionMedium2.copyWith(
          color: _getStatusBadgeTextColor(status),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    final timeFormat = DateFormat('HH:mm');

    if (dateOnly == today) {
      return 'Сегодня в ${timeFormat.format(date)}';
    } else if (dateOnly == yesterday) {
      return 'Вчера в ${timeFormat.format(date)}';
    } else {
      return DateFormat('dd.MM.yyyy, HH:mm').format(date);
    }
  }

  Color _getStatusBadgeColor(SystemStatus status) {
    if (status.code == "1") {
      return AppColors.green500;
    }

    return AppColors.grey200;
  }

  Color _getStatusBadgeTextColor(SystemStatus status) {
    if (status.code == "1") {
      return AppColors.white;
    }

    return AppColors.black;
  }
}
