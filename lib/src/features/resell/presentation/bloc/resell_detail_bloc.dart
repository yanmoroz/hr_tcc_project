import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/features/resell/domain/domain.dart';

import 'resell_detail_event.dart';
import 'resell_detail_state.dart';

class ResellDetailBloc extends Bloc<ResellDetailEvent, ResellDetailState> {
  final GetResellDetailUsecase _getResellDetailUsecase;
  final BookResellItemUsecase _bookResellItemUsecase;

  ResellDetail? _currentDetail;

  ResellDetailBloc(
    this._getResellDetailUsecase,
    this._bookResellItemUsecase,
  ) : super(const ResellDetailState.initial()) {
    on<LoadResellDetail>(_onLoadResellDetail);
    on<BookResellItem>(_onBookResellItem);
  }

  Future<void> _onLoadResellDetail(LoadResellDetail event, Emitter<ResellDetailState> emit) async {
    emit(const ResellDetailState.loading());

    final result = await _getResellDetailUsecase(event.id);

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to load resell detail: ${error.toString()}');
          emit(ResellDetailState.error(error.toString()));
        },
        (detail) {
          _currentDetail = detail;
          emit(ResellDetailState.loaded(detail));
        },
      );
    }
  }

  Future<void> _onBookResellItem(BookResellItem event, Emitter<ResellDetailState> emit) async {
    if (_currentDetail == null) return;

    emit(const ResellDetailState.bookingInProgress());

    final result = await _bookResellItemUsecase(event.id);

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to book resell item: ${error.toString()}');
          // Return to loaded state with the detail
          emit(ResellDetailState.loaded(_currentDetail!));
          emit(ResellDetailState.error(error.toString()));
        },
        (booking) {
          AppLogger.d('Booking successful: ${booking.id}');
          emit(ResellDetailState.bookingSuccess(booking));
        },
      );
    }
  }
}
