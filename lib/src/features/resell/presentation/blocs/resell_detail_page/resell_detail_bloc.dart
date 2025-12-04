import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/logging/app_logger.dart';
import '../../../domain/domain.dart';

import 'resell_detail_event.dart';
import 'resell_detail_state.dart';

class ResellDetailBloc extends Bloc<ResellDetailEvent, ResellDetailState> {
  final String itemId;
  final GetResellDetailUsecase _getResellDetailUsecase;
  final BookResellItemUsecase _bookResellItemUsecase;

  ResellDetailBloc({
    required this.itemId,
    required GetResellDetailUsecase getResellDetailUsecase,
    required BookResellItemUsecase bookResellItemUsecase,
  }) : _getResellDetailUsecase = getResellDetailUsecase,
       _bookResellItemUsecase = bookResellItemUsecase,
       super(const ResellDetailState()) {
    on<LoadResellDetail>(_onLoadResellDetail);
    on<BookResellItem>(_onBookResellItem);
  }

  Future<void> _onLoadResellDetail(
    LoadResellDetail event,
    Emitter<ResellDetailState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await _getResellDetailUsecase(itemId);

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to load resell detail: ${error.toString()}');
          emit(
            state.copyWith(
              status: LoadingStatus.error,
              errorMessage: error.toString(),
            ),
          );
        },
        (detail) {
          emit(state.copyWith(status: LoadingStatus.success, detail: detail));
        },
      );
    }
  }

  Future<void> _onBookResellItem(
    BookResellItem event,
    Emitter<ResellDetailState> emit,
  ) async {
    // Get current detail from state
    if (state.detail == null) return;

    emit(state.copyWith(isBooking: true));

    final result = await _bookResellItemUsecase(itemId);

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to book resell item: ${error.toString()}');
          emit(
            state.copyWith(
              status: LoadingStatus.error,
              errorMessage: error.toString(),
              isBooking: false,
            ),
          );
        },
        (_) {
          AppLogger.d('Booking successful');
          emit(state.copyWith(status: LoadingStatus.success, isBooking: false));
        },
      );
    }
  }
}
