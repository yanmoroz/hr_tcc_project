import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/features/resell/domain/domain.dart';

import 'resell_booking_event.dart';
import 'resell_booking_state.dart';

class ResellBookingBloc extends Bloc<ResellBookingEvent, ResellBookingState> {
  final ConfirmResellBookingUsecase _confirmResellBookingUsecase;

  ResellBookingBloc(
    this._confirmResellBookingUsecase,
    ResellBooking initialBooking,
  ) : super(ResellBookingState.initial(initialBooking)) {
    on<ConfirmBooking>(_onConfirmBooking);
  }

  Future<void> _onConfirmBooking(ConfirmBooking event, Emitter<ResellBookingState> emit) async {
    emit(const ResellBookingState.confirmingBooking());

    final result = await _confirmResellBookingUsecase(
      id: event.itemId,
      confirmation: event.confirmation,
    );

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to confirm booking: ${error.toString()}');
          emit(ResellBookingState.error(error.toString()));
        },
        (booking) {
          AppLogger.d('Booking confirmed successfully: ${booking.id}');
          emit(ResellBookingState.bookingConfirmed(booking));
        },
      );
    }
  }
}
