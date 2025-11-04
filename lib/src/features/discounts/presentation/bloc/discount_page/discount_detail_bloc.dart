import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/types/result.dart';
import '../../../domain/domain.dart';
import 'discount_detail_event.dart';
import 'discount_detail_state.dart';

class DiscountDetailBloc extends Bloc<DiscountDetailEvent, DiscountDetailState> {
  final int discountId;
  final GetDiscountDetailUsecase _getDiscountDetailUsecase;
  final GetDiscountStatsUsecase _getDiscountStatsUsecase;
  final ToggleDiscountLikeUsecase _toggleDiscountLikeUsecase;

  DiscountDetailBloc({
    required this.discountId,
    required GetDiscountDetailUsecase getDiscountDetailUsecase,
    required GetDiscountStatsUsecase getDiscountStatsUsecase,
    required ToggleDiscountLikeUsecase toggleDiscountLikeUsecase,
  })  : _getDiscountDetailUsecase = getDiscountDetailUsecase,
        _getDiscountStatsUsecase = getDiscountStatsUsecase,
        _toggleDiscountLikeUsecase = toggleDiscountLikeUsecase,
        super(const DiscountDetailState.initial()) {
    on<LoadDetail>(_onLoadDetail);
    on<ToggleLike>(_onToggleLike);
    on<RefreshDetail>(_onRefreshDetail);
  }

  Future<void> _onLoadDetail(
    LoadDetail event,
    Emitter<DiscountDetailState> emit,
  ) async {
    emit(const DiscountDetailState.loading());
    await _loadDetail(emit);
  }

  Future<void> _onRefreshDetail(
    RefreshDetail event,
    Emitter<DiscountDetailState> emit,
  ) async {
    await _loadDetail(emit);
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<DiscountDetailState> emit,
  ) async {
    // Optimistic update
    state.maybeWhen(
      loaded: (discount, likeCount, liked, commentCount) {
        emit(DiscountDetailState.loaded(
          discount: discount,
          likeCount: liked ? likeCount - 1 : likeCount + 1,
          liked: !liked,
          commentCount: commentCount,
        ));
      },
      orElse: () {},
    );

    // Make API call
    final result = await _toggleDiscountLikeUsecase(discountId);

    result.fold(
      (error) {
        // Revert on error
        state.maybeWhen(
          loaded: (discount, likeCount, liked, commentCount) {
            emit(DiscountDetailState.loaded(
              discount: discount,
              likeCount: liked ? likeCount - 1 : likeCount + 1,
              liked: !liked,
              commentCount: commentCount,
            ));
          },
          orElse: () {},
        );
      },
      (_) {
        // Success - state already updated optimistically
      },
    );
  }

  Future<void> _loadDetail(Emitter<DiscountDetailState> emit) async {
    final detailResult = await _getDiscountDetailUsecase(discountId);
    final statsResult = await _getDiscountStatsUsecase(discountId);

    final detailError = detailResult.fold((e) => e.message, (_) => null);
    final statsError = statsResult.fold((e) => e.message, (_) => null);

    if (detailError != null || statsError != null) {
      emit(DiscountDetailState.error(detailError ?? statsError!));
      return;
    }

    detailResult.fold(
      (_) => null,
      (discount) {
        statsResult.fold(
          (_) => null,
          (stats) {
            emit(DiscountDetailState.loaded(
              discount: discount,
              likeCount: stats.likeCount,
              liked: stats.like,
              commentCount: stats.commentCount,
            ));
          },
        );
      },
    );
  }
}
