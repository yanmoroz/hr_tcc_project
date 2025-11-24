import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
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
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.isCanceling != current.isCanceling,
        listener: (context, state) {
          // Handle successful cancellation
          if (state.status == LoadingStatus.success &&
              !state.isCanceling &&
              state.detail == null) {
            // Show success modal and navigate back
            SubmitResultWidget.show(
              context: context,
              message: 'Заявка отменена',
              isSuccess: true,
              onClose: () {
                context.pop(); // Navigate back to applications list
              },
            );
          }

          // Handle error
          if (state.status == LoadingStatus.error) {
            SubmitResultWidget.show(
              context: context,
              message: state.errorMessage ?? 'Unknown error',
              isSuccess: false,
            );
          }
        },
        child: BlocBuilder<ApplicationDetailBloc, ApplicationDetailState>(
          builder: (context, state) {
            // Initial state - trigger loading
            if (state.status == LoadingStatus.initial) {
              context.read<ApplicationDetailBloc>().add(
                const ApplicationDetailEvent.loadDetail(),
              );
              return const Center(child: CircularProgressIndicator());
            }

            // Loading or canceling
            if (state.status == LoadingStatus.loading || state.isCanceling) {
              return const Center(child: CircularProgressIndicator());
            }

            // Error state
            if (state.status == LoadingStatus.error) {
              return Center(
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
                      'Ошибка: ${state.errorMessage ?? 'Unknown error'}',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Success state with detail
            if (state.detail != null) {
              return _buildDetailContent(context, state.detail!);
            }

            // Fallback
            return const Center(child: CircularProgressIndicator());
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
