import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/logging/app_logger.dart';
import '../../../domain/domain.dart';

import 'resell_booking_event.dart';
import 'resell_booking_state.dart';

class ResellBookingBloc extends Bloc<ResellBookingEvent, ResellBookingState> {
  final String itemId;
  final ConfirmResellBookingUsecase _confirmResellBookingUsecase;

  ResellBookingBloc(this.itemId, this._confirmResellBookingUsecase)
    : super(const ResellBookingState.initial()) {
    on<ConfirmBooking>(_onConfirmBooking);
  }

  Future<void> _onConfirmBooking(
    ConfirmBooking event,
    Emitter<ResellBookingState> emit,
  ) async {
    emit(const ResellBookingState.confirmingBooking());

    final result = await _confirmResellBookingUsecase(
      params: event.params.copyWith(id: itemId),
    );

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to confirm booking: ${error.toString()}');
          emit(ResellBookingState.error(error.toString()));
        },
        (booking) {
          AppLogger.d('Booking confirmed successfully');
          emit(const ResellBookingState.bookingConfirmed());
        },
      );
    }
  }
}
