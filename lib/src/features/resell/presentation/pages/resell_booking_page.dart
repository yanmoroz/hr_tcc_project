import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/domain.dart';
import '../blocs/resell_booking_page/bloc.dart';

class ResellBookingPage extends StatefulWidget {
  const ResellBookingPage({super.key});

  @override
  State<ResellBookingPage> createState() => _ResellBookingPageState();
}

class _ResellBookingPageState extends State<ResellBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _innController = TextEditingController();
  final _addressController = TextEditingController();
  final _employeePlaceController = TextEditingController();

  BookingTransition _selectedTransition = BookingTransition.confirm;
  bool _pickupLotMyself = false;

  @override
  void dispose() {
    _innController.dispose();
    _addressController.dispose();
    _employeePlaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResellBookingBloc, ResellBookingState>(
      listenWhen: (previous, current) =>
          previous.status != current.status,
      listener: (context, state) {
        // Handle successful booking
        if (state.status == LoadingStatus.success && !state.isConfirming) {
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            builder: (dialogContext) => SubmitResultWidget(
              message: 'Товар забронирован',
              isSuccess: true,
              onClose: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                context.go('/resell'); // Navigate back to applications list
              },
            ),
          );
        }

        // Handle error
        if (state.status == LoadingStatus.error) {
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            builder: (dialogContext) => SubmitResultWidget(
              message: 'Ошибка: ${state.errorMessage ?? 'Unknown error'}',
              isSuccess: false,
              onClose: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Подтверждение бронирования')),
        body: BlocBuilder<ResellBookingBloc, ResellBookingState>(
          builder: (context, state) {
            final isLoading = state.isConfirming;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking Info
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Информация о бронировании',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Transition Dropdown
                    Text(
                      'Переход',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<BookingTransition>(
                      initialValue: _selectedTransition,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Выберите переход',
                      ),
                      items: BookingTransition.values.map((transition) {
                        return DropdownMenuItem(
                          value: transition,
                          child: Text(_getTransitionLabel(transition)),
                        );
                      }).toList(),
                      onChanged: isLoading
                          ? null
                          : (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedTransition = value;
                                });
                              }
                            },
                      validator: (value) {
                        if (value == null) {
                          return 'Выберите переход';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // INN Field
                    Text(
                      'ИНН',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _innController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Введите ИНН',
                      ),
                      enabled: !isLoading,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Address Field
                    Text(
                      'Адрес',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Введите адрес',
                      ),
                      enabled: !isLoading,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    // Employee Place Field
                    Text(
                      'Место работы сотрудника',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _employeePlaceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Введите место работы',
                      ),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Pickup Checkbox
                    CheckboxListTile(
                      title: const Text('Забрать лот самостоятельно'),
                      value: _pickupLotMyself,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _pickupLotMyself = value ?? false;
                              });
                            },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Подтвердить бронирование',
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
            );
          },
        ),
      ),
    );
  }

  String _getTransitionLabel(BookingTransition transition) {
    switch (transition) {
      case BookingTransition.confirm:
        return 'Подтвердить';
      case BookingTransition.cancel:
        return 'Отменить';
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final confirmation = ConfirmResellBookingParams(
        id: context.read<ResellBookingBloc>().itemId,
        transition: _selectedTransition,
        inn: _innController.text.isEmpty ? null : _innController.text,
        address: _addressController.text.isEmpty
            ? null
            : _addressController.text,
        employeePlace: _employeePlaceController.text.isEmpty
            ? null
            : _employeePlaceController.text,
        pickupLotMyself: _pickupLotMyself,
      );

      context.read<ResellBookingBloc>().add(
        ResellBookingEvent.confirmBooking(params: confirmation),
      );
    }
  }
}
