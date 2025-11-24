import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../domain/domain.dart';
import '../blocs/resell_detail_page/bloc.dart';

class ResellDetailPage extends StatelessWidget {
  final String itemId;

  const ResellDetailPage({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResellDetailBloc, ResellDetailState>(
      listenWhen: (previous, current) =>
          previous.isBooking != current.isBooking,
      listener: (context, state) {
        // Navigate to booking page when booking is initiated
        if (state.isBooking) {
          context.push('/home/resell/booking/$itemId').then((_) {
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

    return _buildDetailContent(context, detail);
  }

  Widget _buildDetailContent(BuildContext context, ResellDetail detail) {
    final currencyFormat = NumberFormat.currency(symbol: '₽', decimalDigits: 0);
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image carousel or single image
          if (detail.photo != null && detail.photo!.isNotEmpty)
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: detail.photo!.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    detail.photo![index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 80),
                      );
                    },
                  );
                },
              ),
            )
          else if (detail.generalPhoto != null)
            Image.network(
              detail.generalPhoto!,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 80),
                );
              },
            )
          else
            Container(
              height: 300,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 80),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Price
                Text(
                  detail.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      currencyFormat.format(detail.price),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 12),
                    if (detail.lottery)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Розыгрыш',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Equipment Type
                _buildInfoRow(
                  context,
                  'Тип оборудования:',
                  detail.equipmentType.name,
                ),
                const SizedBox(height: 8),

                // Location
                if (detail.location != null) ...[
                  _buildInfoRow(context, 'Местоположение:', detail.location!),
                  const SizedBox(height: 8),
                ],

                // Author
                if (detail.author != null) ...[
                  _buildInfoRow(
                    context,
                    'Автор:',
                    '${detail.author!.lastName} ${detail.author!.firstName}${detail.author!.middleName != null ? ' ${detail.author!.middleName}' : ''}',
                  ),
                  const SizedBox(height: 8),
                ],

                // Creation Date
                _buildInfoRow(
                  context,
                  'Дата создания:',
                  dateFormat.format(detail.creationDate),
                ),
                const SizedBox(height: 8),

                // Status
                _buildInfoRow(context, 'Статус:', detail.status.name),
                const SizedBox(height: 16),

                // Description
                if (detail.description != null) ...[
                  Text(
                    'Описание',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detail.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                ],

                // Booking Status
                if (detail.bookingFinish) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Забронировано',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (detail.finishDateReservation != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'До ${dateFormat.format(detail.finishDateReservation!)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red[700],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Book Button
                if (!detail.bookingFinish)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ResellDetailBloc>().add(
                          const ResellDetailEvent.bookResellItem(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Забронировать',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
