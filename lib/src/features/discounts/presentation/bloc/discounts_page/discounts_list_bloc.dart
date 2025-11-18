import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/value_objects/system_type.dart';
import '../../../../../core/base_types/result.dart';
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
       super(const DiscountsListState.initial()) {
    on<LoadDiscounts>(_onLoadDiscounts);
    on<RefreshDiscounts>(_onRefreshDiscounts);
    on<LoadMoreDiscounts>(_onLoadMoreDiscounts);
    on<ToggleLike>(_onToggleLike);
  }

  Future<void> _onLoadDiscounts(
    LoadDiscounts event,
    Emitter<DiscountsListState> emit,
  ) async {
    emit(const DiscountsListState.loading());
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
    // Extract state values first
    List<Discount>? discounts;
    int? currentPage;
    bool? hasMorePages;
    bool? isLoadingMore;
    Map<int, Uint8List>? coverImages;
    int? category;
    int? source;
    String? categoryName;

    state.maybeWhen(
      loaded:
          (
            loadedDiscounts,
            loadedCurrentPage,
            loadedHasMorePages,
            loadedIsLoadingMore,
            loadedCoverImages,
            loadedCategory,
            loadedSource,
            loadedCategoryName,
          ) {
            discounts = loadedDiscounts;
            currentPage = loadedCurrentPage;
            hasMorePages = loadedHasMorePages;
            isLoadingMore = loadedIsLoadingMore;
            coverImages = loadedCoverImages;
            category = loadedCategory;
            source = loadedSource;
            categoryName = loadedCategoryName;
          },
      orElse: () {},
    );

    // Only load more if we're in loaded state and not already loading more
    if (discounts != null &&
        currentPage != null &&
        hasMorePages != null &&
        !(isLoadingMore ?? false) &&
        hasMorePages!) {
      // Emit state with isLoadingMore = true
      emit(
        DiscountsListState.loaded(
          discounts: discounts!,
          currentPage: currentPage!,
          hasMorePages: hasMorePages!,
          isLoadingMore: true,
          coverImages: coverImages ?? {},
          category: category,
          source: source,
          categoryName: categoryName,
        ),
      );

      // Load next page
      await _loadMoreDiscounts(
        emit,
        currentDiscounts: discounts!,
        currentCoverImages: coverImages ?? {},
        nextPage: currentPage! + 1,
        category: category,
        source: source,
        categoryName: categoryName,
      );
    }
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
      (error) async => emit(DiscountsListState.error(error.message)),
      (discounts) async {
        emit(
          DiscountsListState.loaded(
            discounts: discounts,
            currentPage: page,
            hasMorePages:
                discounts.isNotEmpty, // Assume more pages if we got results
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
        // On error, revert to previous state without isLoadingMore
        emit(
          DiscountsListState.loaded(
            discounts: currentDiscounts,
            currentPage: nextPage - 1,
            hasMorePages: true,
            isLoadingMore: false,
            coverImages: currentCoverImages,
            category: category,
            source: source,
            categoryName: categoryName,
          ),
        );
      },
      (newDiscounts) async {
        final allDiscounts = [...currentDiscounts, ...newDiscounts];
        emit(
          DiscountsListState.loaded(
            discounts: allDiscounts,
            currentPage: nextPage,
            hasMorePages: newDiscounts.isNotEmpty, // No more pages if empty
            isLoadingMore: false,
            coverImages: currentCoverImages,
            category: category,
            source: source,
            categoryName: categoryName,
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
    state.maybeWhen(
      loaded:
          (
            discounts,
            currentPage,
            hasMorePages,
            isLoadingMore,
            existingCoverImages,
            category,
            source,
            categoryName,
          ) {
            final mergedCoverImages = {...existingCoverImages, ...coverImages};
            emit(
              DiscountsListState.loaded(
                discounts: discounts,
                currentPage: currentPage,
                hasMorePages: hasMorePages,
                isLoadingMore: isLoadingMore,
                coverImages: mergedCoverImages,
                category: category,
                source: source,
                categoryName: categoryName,
              ),
            );
          },
      orElse: () {},
    );
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<DiscountsListState> emit,
  ) async {
    // Extract current state values
    List<Discount>? discounts;
    int? currentPage;
    bool? hasMorePages;
    bool? isLoadingMore;
    Map<int, Uint8List>? coverImages;
    int? category;
    int? source;
    String? categoryName;

    state.maybeWhen(
      loaded:
          (
            loadedDiscounts,
            loadedCurrentPage,
            loadedHasMorePages,
            loadedIsLoadingMore,
            loadedCoverImages,
            loadedCategory,
            loadedSource,
            loadedCategoryName,
          ) {
            discounts = loadedDiscounts;
            currentPage = loadedCurrentPage;
            hasMorePages = loadedHasMorePages;
            isLoadingMore = loadedIsLoadingMore;
            coverImages = loadedCoverImages;
            category = loadedCategory;
            source = loadedSource;
            categoryName = loadedCategoryName;
          },
      orElse: () {},
    );

    // Only proceed if we're in loaded state
    if (discounts == null || currentPage == null || hasMorePages == null)
      return;

    // Find the discount to update
    final discountIndex = discounts!.indexWhere(
      (d) => d.id == event.discountId,
    );
    if (discountIndex == -1) return;

    final discount = discounts![discountIndex];

    // Optimistic update
    final updatedDiscounts = List<Discount>.from(discounts!);
    updatedDiscounts[discountIndex] = discount.copyWith(
      like: !discount.like,
      likeCount: discount.like
          ? discount.likeCount - 1
          : discount.likeCount + 1,
    );

    emit(
      DiscountsListState.loaded(
        discounts: updatedDiscounts,
        currentPage: currentPage!,
        hasMorePages: hasMorePages!,
        isLoadingMore: isLoadingMore ?? false,
        coverImages: coverImages ?? {},
        category: category,
        source: source,
        categoryName: categoryName,
      ),
    );

    // Store original discounts for potential revert
    final originalDiscounts = discounts!;

    // Make API call
    final result = await _toggleDiscountLikeUsecase(event.discountId);

    result.fold(
      (error) {
        // Revert on error
        emit(
          DiscountsListState.loaded(
            discounts: originalDiscounts,
            currentPage: currentPage!,
            hasMorePages: hasMorePages!,
            isLoadingMore: isLoadingMore ?? false,
            coverImages: coverImages ?? {},
            category: category,
            source: source,
            categoryName: categoryName,
          ),
        );
      },
      (_) {
        // Success - state already updated optimistically
      },
    );
  }
}
