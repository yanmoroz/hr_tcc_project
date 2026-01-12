import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/widgets.dart';
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

  bool _pickupLotMyself = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _innController.addListener(_validateForm);
    _addressController.addListener(_validateForm);
    _employeePlaceController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _innController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _employeePlaceController.text.isNotEmpty;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResellBookingBloc, ResellBookingState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        // Handle successful booking
        if (state.status == LoadingStatus.success && !state.isConfirming) {
          SubmitResultWidget.show(
            context: context,
            message: 'Товар забронирован',
            isSuccess: true,
            onClose: () {
              context.go('/home/resell'); // Navigate back to resell list
            },
          );
        }

        // Handle error
        if (state.status == LoadingStatus.error) {
          SubmitResultWidget.show(
            context: context,
            message: 'Ошибка: ${state.errorMessage ?? 'Unknown error'}',
            isSuccess: false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text('Бронирование'),
          automaticallyImplyLeading: false,
          actions: [
            BlocBuilder<ResellBookingBloc, ResellBookingState>(
              builder: (context, state) {
                return IconButton(
                  icon: SvgPicture.asset(Assets.icons.closeIcon),
                  onPressed: () => _showCancelBookingDialog(
                    context,
                    state.itemId,
                    state.itemName,
                  ),
                  // onPressed: () => context.pop(),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ResellBookingBloc, ResellBookingState>(
          builder: (context, state) {
            final isLoading = state.isConfirming;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section heading
                          Text(
                            'Заполните персональные данные',
                            style: AppTypography.titleBold2,
                          ),
                          const SizedBox(height: 16),

                          // Info banner
                          Builder(
                            builder: (context) {
                              final deadline = DateTime.now().add(
                                const Duration(minutes: 30),
                              );
                              final deadlineTime =
                                  '${deadline.hour}:${deadline.minute.toString().padLeft(2, '0')}';
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: AppTypography.textRegular2.copyWith(
                                      color: AppColors.black,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Заполнить данные необходимо ',
                                      ),
                                      TextSpan(
                                        text:
                                            'в течении 30 минут (до $deadlineTime)',
                                        style: AppTypography.textSemibold2,
                                      ),
                                      const TextSpan(
                                        text:
                                            ', по истечении этого времени бронь снимается.',
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // Product section
                          Text(
                            'Товар',
                            style: AppTypography.captionMedium2.copyWith(
                              color: AppColors.grey700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(state.itemName, style: AppTypography.textRegular1),
                          const SizedBox(height: 16),

                          // INN Field
                          AppTextFormField(
                            controller: _innController,
                            labelText: 'ИНН',
                            enabled: !isLoading,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // Address Field
                          AppTextFormField(
                            controller: _addressController,
                            labelText: 'Адрес регистрации',
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),

                          // Employee Place Field
                          AppTextFormField(
                            controller: _employeePlaceController,
                            labelText: 'Рабочее место',
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),

                          // Pickup Switch
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Самостоятельно заберу товар',
                                style: AppTypography.textRegular1,
                              ),
                              Switch.adaptive(
                                value: _pickupLotMyself,
                                onChanged: isLoading
                                    ? null
                                    : (value) =>
                                        setState(() => _pickupLotMyself = value),
                                activeTrackColor: AppColors.blue500,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Pinned bottom button
                _buildBottomButtonContainer(context, state, isLoading),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomButtonContainer(
    BuildContext context,
    ResellBookingState state,
    bool isLoading,
  ) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SafeArea(
        top: false,
        child: PrimaryButton(
          label: 'Отправить',
          size: PrimaryButtonSize.large,
          style: PrimatyButtonStyle.colored,
          enabled: _isFormValid,
          isLoading: isLoading,
          onPressed: () => _submitForm(context, state),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _innController.dispose();
    _addressController.dispose();
    _employeePlaceController.dispose();
    super.dispose();
  }

  Future<void> _showCancelBookingDialog(
    BuildContext context,
    String itemId,
    String itemName,
  ) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Прекратить бронирование товара?',
      content: itemName,
      confirmText: 'Прекратить',
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      context.read<ResellBookingBloc>().add(
        ResellBookingEvent.cancelBooking(itemId),
      );
    }
  }

  void _submitForm(BuildContext context, ResellBookingState state) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ResellBookingBloc>().add(
        ResellBookingEvent.confirmBooking(
          inn: _innController.text.isEmpty ? null : _innController.text,
          address: _addressController.text.isEmpty
              ? null
              : _addressController.text,
          employeePlace: _employeePlaceController.text.isEmpty
              ? null
              : _employeePlaceController.text,
          pickupLotMyself: _pickupLotMyself,
        ),
      );
    }
  }
}
