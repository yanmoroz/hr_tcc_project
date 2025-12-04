import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/base_types/result.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../../../shared/files/domain/domain.dart';
import '../../../domain/domain.dart';
import 'discount_detail_event.dart';
import 'discount_detail_state.dart';

class DiscountDetailBloc
    extends Bloc<DiscountDetailEvent, DiscountDetailState> {
  final int discountId;
  final GetDiscountDetailUsecase _getDiscountDetailUsecase;
  final GetDiscountStatsUsecase _getDiscountStatsUsecase;
  final ToggleDiscountLikeUsecase _toggleDiscountLikeUsecase;
  final DownloadFileUsecase _downloadFileUsecase;

  DiscountDetailBloc({
    required this.discountId,
    required GetDiscountDetailUsecase getDiscountDetailUsecase,
    required GetDiscountStatsUsecase getDiscountStatsUsecase,
    required ToggleDiscountLikeUsecase toggleDiscountLikeUsecase,
    required DownloadFileUsecase downloadFileUsecase,
  }) : _getDiscountDetailUsecase = getDiscountDetailUsecase,
       _getDiscountStatsUsecase = getDiscountStatsUsecase,
       _toggleDiscountLikeUsecase = toggleDiscountLikeUsecase,
       _downloadFileUsecase = downloadFileUsecase,
       super(const DiscountDetailState()) {
    on<LoadDetail>(_onLoadDetail);
    on<ToggleLike>(_onToggleLike);
    on<RefreshDetail>(_onRefreshDetail);
  }

  Future<void> _onLoadDetail(
    LoadDetail event,
    Emitter<DiscountDetailState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
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
    emit(
      state.copyWith(
        likeCount: state.liked ? state.likeCount - 1 : state.likeCount + 1,
        liked: !state.liked,
      ),
    );

    // Make API call
    final result = await _toggleDiscountLikeUsecase(discountId);

    result.fold(
      (error) {
        // Revert on error
        emit(
          state.copyWith(
            likeCount: state.liked ? state.likeCount - 1 : state.likeCount + 1,
            liked: !state.liked,
          ),
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
      emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: detailError ?? statsError!,
        ),
      );
      return;
    }

    await detailResult.fold((_) async => null, (discount) async {
      await statsResult.fold((_) async => null, (stats) async {
        emit(
          state.copyWith(
            status: LoadingStatus.success,
            discount: discount,
            likeCount: stats.likeCount,
            liked: stats.like,
            commentCount: stats.commentCount,
          ),
        );
        await _loadCoverImage(discount, emit);
      });
    });
  }

  Future<void> _loadCoverImage(
    DiscountDetail discount,
    Emitter<DiscountDetailState> emit,
  ) async {
    if (discount.image == null || discount.image!.isEmpty) {
      return;
    }

    final result = await _downloadFileUsecase(
      systemType: SystemType.kp,
      download: false,
      uriFile: discount.image,
    );

    result.fold(
      (error) {
        // Silently fail for image download
      },
      (imageBytes) {
        emit(state.copyWith(coverImage: imageBytes));
      },
    );
  }
}
