import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/files/domain/entities/system_type.dart';
import '../../../../../core/files/domain/usecases/usecases.dart';
import '../../../../../core/types/result.dart';
import '../../../domain/domain.dart';
import 'discount_detail_event.dart';
import 'discount_detail_state.dart';

class DiscountDetailBloc extends Bloc<DiscountDetailEvent, DiscountDetailState> {
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
  })  : _getDiscountDetailUsecase = getDiscountDetailUsecase,
        _getDiscountStatsUsecase = getDiscountStatsUsecase,
        _toggleDiscountLikeUsecase = toggleDiscountLikeUsecase,
        _downloadFileUsecase = downloadFileUsecase,
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
      loaded: (discount, likeCount, liked, commentCount, coverImage) {
        emit(DiscountDetailState.loaded(
          discount: discount,
          likeCount: liked ? likeCount - 1 : likeCount + 1,
          liked: !liked,
          commentCount: commentCount,
          coverImage: coverImage,
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
          loaded: (discount, likeCount, liked, commentCount, coverImage) {
            emit(DiscountDetailState.loaded(
              discount: discount,
              likeCount: liked ? likeCount - 1 : likeCount + 1,
              liked: !liked,
              commentCount: commentCount,
              coverImage: coverImage,
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

    await detailResult.fold(
      (_) async => null,
      (discount) async {
        await statsResult.fold(
          (_) async => null,
          (stats) async {
            emit(DiscountDetailState.loaded(
              discount: discount,
              likeCount: stats.likeCount,
              liked: stats.like,
              commentCount: stats.commentCount,
            ));
            await _loadCoverImage(discount, emit);
          },
        );
      },
    );
  }

  Future<void> _loadCoverImage(DiscountDetail discount, Emitter<DiscountDetailState> emit) async {
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
        state.maybeWhen(
          loaded: (discount, likeCount, liked, commentCount, _) {
            emit(DiscountDetailState.loaded(
              discount: discount,
              likeCount: likeCount,
              liked: liked,
              commentCount: commentCount,
              coverImage: imageBytes,
            ));
          },
          orElse: () {},
        );
      },
    );
  }
}
