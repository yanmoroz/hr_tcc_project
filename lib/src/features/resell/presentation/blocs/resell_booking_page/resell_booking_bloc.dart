import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/logging/app_logger.dart';
import '../../../domain/domain.dart';
import 'resell_booking_event.dart';
import 'resell_booking_state.dart';

class ResellBookingBloc extends Bloc<ResellBookingEvent, ResellBookingState> {
  final ConfirmResellBookingUsecase _confirmResellBookingUsecase;

  ResellBookingBloc(
    String itemId,
    String itemName,
    this._confirmResellBookingUsecase,
  ) : super(ResellBookingState(itemId: itemId, itemName: itemName)) {
    on<ConfirmBooking>(_onConfirmBooking);
    on<CancelBooking>(_onCancelBooking);
  }

  Future<void> _onConfirmBooking(
    ConfirmBooking event,
    Emitter<ResellBookingState> emit,
  ) async {
    emit(state.copyWith(isConfirming: true));

    final params = ConfirmResellBookingParams(
      id: state.itemId,
      transition: BookingTransition.confirm,
      inn: event.inn,
      address: event.address,
      employeePlace: event.employeePlace,
      pickupLotMyself: event.pickupLotMyself,
    );

    final result = await _confirmResellBookingUsecase(params: params);

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to confirm booking: ${error.toString()}');
          emit(
            state.copyWith(
              status: LoadingStatus.error,
              errorMessage: error.toString(),
              isConfirming: false,
            ),
          );
        },
        (booking) {
          AppLogger.d('Booking confirmed successfully');
          emit(
            state.copyWith(status: LoadingStatus.success, isConfirming: false),
          );
        },
      );
    }
  }

  Future<void> _onCancelBooking(
    CancelBooking event,
    Emitter<ResellBookingState> emit,
  ) async {
    emit(state.copyWith(isConfirming: true));

    final params = ConfirmResellBookingParams(
      id: event.itemId,
      transition: BookingTransition.cancel,
    );

    final result = await _confirmResellBookingUsecase(params: params);

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to cancel booking: ${error.toString()}');
          emit(
            state.copyWith(
              status: LoadingStatus.error,
              errorMessage: error.toString(),
              isConfirming: false,
            ),
          );
        },
        (booking) {
          AppLogger.d('Booking canceled successfully');
          emit(
            state.copyWith(
              status: LoadingStatus.success,
              isConfirming: false,
              isCanceled: true,
            ),
          );
        },
      );
    }
  }
}
