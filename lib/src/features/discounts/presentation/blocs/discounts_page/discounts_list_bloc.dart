import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/base_types/result.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../../../shared/files/domain/domain.dart';
import '../../../domain/domain.dart';
import 'discounts_list_event.dart';
import 'discounts_list_state.dart';

class DiscountsListBloc extends Bloc<DiscountsListEvent, DiscountsListState> {
  final GetDiscountsUsecase _getDiscountsUsecase;
  final DownloadFileUsecase _downloadFileUsecase;
  final ToggleDiscountLikeUsecase _toggleDiscountLikeUsecase;

  DiscountsListBloc({
    required GetDiscountsUsecase getDiscountsUsecase,
    required DownloadFileUsecase downloadFileUsecase,
    required ToggleDiscountLikeUsecase toggleDiscountLikeUsecase,
  }) : _getDiscountsUsecase = getDiscountsUsecase,
       _downloadFileUsecase = downloadFileUsecase,
       _toggleDiscountLikeUsecase = toggleDiscountLikeUsecase,
       super(const DiscountsListState()) {
    on<LoadDiscounts>(_onLoadDiscounts);
    on<RefreshDiscounts>(_onRefreshDiscounts);
    on<LoadMoreDiscounts>(_onLoadMoreDiscounts);
    on<ToggleDiscountLike>(_onToggleDiscountLike);
  }

  Future<void> _onLoadDiscounts(
    LoadDiscounts event,
    Emitter<DiscountsListState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadDiscounts(
      emit,
      page: 0,
      category: event.category,
      source: event.source,
      categoryName: event.categoryName,
    );
  }

  Future<void> _onRefreshDiscounts(
    RefreshDiscounts event,
    Emitter<DiscountsListState> emit,
  ) async {
    // Keep current state while refreshing, then reload from page 0
    await _loadDiscounts(
      emit,
      page: 0,
      category: event.category,
      source: event.source,
      categoryName: event.categoryName,
    );
  }

  Future<void> _onLoadMoreDiscounts(
    LoadMoreDiscounts event,
    Emitter<DiscountsListState> emit,
  ) async {
    // Guard clauses - simple and clear
    if (state.isLoadingMore || !state.hasMorePages) return;

    // Show loading indicator
    emit(state.copyWith(isLoadingMore: true));

    // Load next page
    await _loadMoreDiscounts(
      emit,
      currentDiscounts: state.discounts,
      currentCoverImages: state.coverImages,
      nextPage: state.currentPage + 1,
      category: state.category,
      source: state.source,
      categoryName: state.categoryName,
    );
  }

  Future<void> _loadDiscounts(
    Emitter<DiscountsListState> emit, {
    required int page,
    int? category,
    int? source,
    String? categoryName,
  }) async {
    final result = await _getDiscountsUsecase(
      category: category ?? 0,
      source: source ?? 0,
      page: page,
    );

    await result.fold(
      (error) async => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.message,
        ),
      ),
      (discounts) async {
        emit(
          state.copyWith(
            status: LoadingStatus.success,
            discounts: discounts,
            currentPage: page,
            hasMorePages: discounts.isNotEmpty,
            isLoadingMore: false,
            category: category,
            source: source,
            categoryName: categoryName,
          ),
        );
        await _loadCoverImages(discounts, emit);
      },
    );
  }

  Future<void> _loadMoreDiscounts(
    Emitter<DiscountsListState> emit, {
    required List<Discount> currentDiscounts,
    required Map<int, Uint8List> currentCoverImages,
    required int nextPage,
    int? category,
    int? source,
    String? categoryName,
  }) async {
    final result = await _getDiscountsUsecase(
      category: category ?? 0,
      source: source ?? 0,
      page: nextPage,
    );

    await result.fold(
      (error) async {
        // On error, revert isLoadingMore flag
        emit(
          state.copyWith(
            status: LoadingStatus.error,
            errorMessage: error.message,
            isLoadingMore: false,
          ),
        );
      },
      (newDiscounts) async {
        final allDiscounts = [...currentDiscounts, ...newDiscounts];
        emit(
          state.copyWith(
            status: LoadingStatus.success,
            discounts: allDiscounts,
            currentPage: nextPage,
            hasMorePages: newDiscounts.isNotEmpty,
            isLoadingMore: false,
          ),
        );
        // Load cover images for new discounts only
        await _loadCoverImages(newDiscounts, emit);
      },
    );
  }

  Future<void> _loadCoverImages(
    List<Discount> discounts,
    Emitter<DiscountsListState> emit,
  ) async {
    final coverImages = <int, Uint8List>{};

    // Download images in parallel for discounts that have image
    final futures = discounts
        .where(
          (discount) => discount.image != null && discount.image!.isNotEmpty,
        )
        .map((discount) async {
          final result = await _downloadFileUsecase(
            systemType: SystemType.kp,
            download: false,
            uriFile: discount.image,
          );

          result.fold(
            (error) {
              // Silently fail for individual image downloads
            },
            (imageBytes) {
              coverImages[discount.id] = imageBytes;
            },
          );
        });

    await Future.wait(futures);

    // Emit updated state with cover images, merging with existing ones
    final mergedCoverImages = {...state.coverImages, ...coverImages};
    emit(state.copyWith(coverImages: mergedCoverImages));
  }

  Future<void> _onToggleDiscountLike(
    ToggleDiscountLike event,
    Emitter<DiscountsListState> emit,
  ) async {
    // Find the discount to update
    final discountIndex = state.discounts.indexWhere(
      (d) => d.id == event.discountId,
    );
    if (discountIndex == -1) return;

    final discount = state.discounts[discountIndex];

    // Optimistic update
    final updatedDiscounts = List<Discount>.from(state.discounts);
    updatedDiscounts[discountIndex] = discount.copyWith(
      like: !discount.like,
      likeCount: discount.like
          ? discount.likeCount - 1
          : discount.likeCount + 1,
    );

    emit(state.copyWith(discounts: updatedDiscounts));

    // Store original discounts for potential revert
    final originalDiscounts = state.discounts;

    // Make API call
    final result = await _toggleDiscountLikeUsecase(event.discountId);

    result.fold(
      (error) {
        // Revert on error
        emit(state.copyWith(discounts: originalDiscounts));
      },
      (_) {
        // Success - state already updated optimistically
      },
    );
  }
}
