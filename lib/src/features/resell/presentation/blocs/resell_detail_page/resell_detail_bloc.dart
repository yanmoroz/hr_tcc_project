import 'package:flutter_bloc/flutter_bloc.dart';

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
  })  : _getResellDetailUsecase = getResellDetailUsecase,
        _bookResellItemUsecase = bookResellItemUsecase,
        super(const ResellDetailState.initial()) {
    on<LoadResellDetail>(_onLoadResellDetail);
    on<BookResellItem>(_onBookResellItem);
  }

  Future<void> _onLoadResellDetail(
    LoadResellDetail event,
    Emitter<ResellDetailState> emit,
  ) async {
    emit(const ResellDetailState.loading());

    final result = await _getResellDetailUsecase(itemId);

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to load resell detail: ${error.toString()}');
          emit(ResellDetailState.error(error.toString()));
        },
        (detail) {
          emit(ResellDetailState.loaded(detail));
        },
      );
    }
  }

  Future<void> _onBookResellItem(
    BookResellItem event,
    Emitter<ResellDetailState> emit,
  ) async {
    // Get current detail from state
    final currentDetail = state.mapOrNull(loaded: (state) => state.detail);
    if (currentDetail == null) return;

    emit(const ResellDetailState.bookingInProgress());

    final result = await _bookResellItemUsecase(itemId);

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to book resell item: ${error.toString()}');
          // Return to loaded state with the detail
          emit(ResellDetailState.loaded(currentDetail));
          emit(ResellDetailState.error(error.toString()));
        },
        (_) {
          AppLogger.d('Booking successful');
          emit(ResellDetailState.bookingSuccess());
        },
      );
    }
  }
}
