import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/widgets.dart';
import '../../domain/domain.dart';
import '../blocs/application_detail_page/bloc.dart';
import '../widgets/application_details/alpina_access_detail.dart';

class ApplicationDetailPage extends StatelessWidget {
  const ApplicationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заявка'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<ApplicationDetailBloc, ApplicationDetailState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            loaded: (_) {},
            canceling: () {},
            canceled: () {
              // Show success modal and navigate back
              showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.transparent,
                builder: (dialogContext) => SubmitResultWidget(
                  message: 'Заявка отменена',
                  isSuccess: true,
                  onClose: () {
                    Navigator.of(dialogContext).pop(); // Close dialog
                    context.pop(); // Navigate back to applications list
                  },
                ),
              );
            },
            error: (message) {
              // Show error modal
              showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.transparent,
                builder: (dialogContext) => SubmitResultWidget(
                  message: message,
                  isSuccess: false,
                  onClose: () {
                    Navigator.of(dialogContext).pop(); // Close dialog
                  },
                ),
              );
            },
          );
        },
        child: BlocBuilder<ApplicationDetailBloc, ApplicationDetailState>(
          builder: (context, state) {
            return state.when(
              initial: () {
                // Trigger loading on initial state
                context.read<ApplicationDetailBloc>().add(
                  ApplicationDetailEvent.loadDetail(),
                );
                return const Center(child: CircularProgressIndicator());
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (detail) => _buildDetailContent(context, detail),
              canceling: () => const Center(child: CircularProgressIndicator()),
              canceled: () => const Center(child: CircularProgressIndicator()),
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ошибка: $message',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
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

  Widget _buildDetailContent(BuildContext context, ApplicationDetail detail) {
    return Column(
      children: [
        // Detail content based on application type
        Expanded(
          child: detail.when(
            alpinaDigitalAccess:
                (
                  id,
                  applicationFormCode,
                  applicationDate,
                  systemStatus,
                  desiredStartDate,
                  comment,
                  alpinaDigitalPrevAccess,
                  agreementAcceptance,
                ) => AlpinaAccessDetail(
                  applicationDate: applicationDate,
                  systemStatus: systemStatus,
                  desiredStartDate: desiredStartDate,
                  comment: comment,
                  alpinaDigitalPrevAccess: alpinaDigitalPrevAccess,
                  agreementAcceptance: agreementAcceptance,
                ),
            courierDelivery:
                (
                  id,
                  applicationFormCode,
                  applicationDate,
                  systemStatus,
                  deliveryType,
                  deliveryAddress,
                  deliveryDate,
                  legalEntity,
                  office,
                  recepientCompanyName,
                  recepientNameContact,
                  recepientPhoneNumber,
                  tripPurpose,
                  urgency,
                  recepientEmail,
                  comments,
                  choiceExplanation,
                  contentDescription,
                ) =>
                    const Center(child: Text('Courier Delivery details (TBD)')),
            businessTrip:
                (
                  id,
                  applicationFormCode,
                  applicationDate,
                  systemStatus,
                  activityType,
                  country,
                  startDate,
                  endDate,
                  departure,
                  destination,
                  travelers,
                  financeDivisionTripCode,
                  financeDivisionTripString,
                  tripPurposeId,
                  tripPurposeString,
                  plannedEvents,
                  urgency,
                  selectionHelpTripCode,
                  comment,
                  files,
                  legalEntity,
                ) => const Center(child: Text('Business Trip details (TBD)')),
            referralProgram:
                (id, applicationFormCode, applicationDate, systemStatus) =>
                    const Center(child: Text('Referral Program details (TBD)')),
            unplannedTraining:
                (id, applicationFormCode, applicationDate, systemStatus) =>
                    const Center(
                      child: Text('Unplanned Training details (TBD)'),
                    ),
            violation:
                (id, applicationFormCode, applicationDate, systemStatus) =>
                    const Center(child: Text('Violation details (TBD)')),
            absence: (id, applicationFormCode, applicationDate, systemStatus) =>
                const Center(child: Text('Absence details (TBD)')),
          ),
        ),

        // Cancel button (only if cancelable)
        detail.map(
          alpinaDigitalAccess: (d) => d.systemStatus.cancelable
              ? _buildCancelButton(context)
              : const SizedBox.shrink(),
          courierDelivery: (d) => d.systemStatus.cancelable
              ? _buildCancelButton(context)
              : const SizedBox.shrink(),
          businessTrip: (d) => d.systemStatus.cancelable
              ? _buildCancelButton(context)
              : const SizedBox.shrink(),
          referralProgram: (d) => d.systemStatus.cancelable
              ? _buildCancelButton(context)
              : const SizedBox.shrink(),
          unplannedTraining: (d) => d.systemStatus.cancelable
              ? _buildCancelButton(context)
              : const SizedBox.shrink(),
          violation: (d) => d.systemStatus.cancelable
              ? _buildCancelButton(context)
              : const SizedBox.shrink(),
          absence: (d) => d.systemStatus.cancelable
              ? _buildCancelButton(context)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Отменить заявку?'),
                content: const Text(
                  'Вы уверены, что хотите отменить эту заявку?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Нет'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.read<ApplicationDetailBloc>().add(
                        const ApplicationDetailEvent.cancelApplication(),
                      );
                    },
                    child: const Text(
                      'Да, отменить',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Colors.red, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Отменить заявку',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
