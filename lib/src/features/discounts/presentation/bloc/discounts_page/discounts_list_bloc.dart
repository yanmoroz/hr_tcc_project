import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/types/result.dart';
import '../../../domain/domain.dart';
import 'discounts_list_event.dart';
import 'discounts_list_state.dart';

class DiscountsListBloc extends Bloc<DiscountsListEvent, DiscountsListState> {
  final GetDiscountsUsecase _getDiscountsUsecase;

  DiscountsListBloc({required GetDiscountsUsecase getDiscountsUsecase})
    : _getDiscountsUsecase = getDiscountsUsecase,
      super(const DiscountsListState.initial()) {
    on<LoadDiscounts>(_onLoadDiscounts);
    on<RefreshDiscounts>(_onRefreshDiscounts);
    on<LoadMoreDiscounts>(_onLoadMoreDiscounts);
  }

  Future<void> _onLoadDiscounts(LoadDiscounts event, Emitter<DiscountsListState> emit) async {
    emit(const DiscountsListState.loading());
    await _loadDiscounts(emit, page: 0, category: event.category, source: event.source);
  }

  Future<void> _onRefreshDiscounts(RefreshDiscounts event, Emitter<DiscountsListState> emit) async {
    // Keep current state while refreshing, then reload from page 0
    await _loadDiscounts(emit, page: 0, category: event.category, source: event.source);
  }

  Future<void> _onLoadMoreDiscounts(LoadMoreDiscounts event, Emitter<DiscountsListState> emit) async {
    // Extract state values first
    List<Discount>? discounts;
    int? currentPage;
    bool? hasMorePages;
    bool? isLoadingMore;
    int? category;
    int? source;

    state.maybeWhen(
      loaded:
          (loadedDiscounts, loadedCurrentPage, loadedHasMorePages, loadedIsLoadingMore, loadedCategory, loadedSource) {
            discounts = loadedDiscounts;
            currentPage = loadedCurrentPage;
            hasMorePages = loadedHasMorePages;
            isLoadingMore = loadedIsLoadingMore;
            category = loadedCategory;
            source = loadedSource;
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
          category: category,
          source: source,
        ),
      );

      // Load next page
      await _loadMoreDiscounts(
        emit,
        currentDiscounts: discounts!,
        nextPage: currentPage! + 1,
        category: category,
        source: source,
      );
    }
  }

  Future<void> _loadDiscounts(Emitter<DiscountsListState> emit, {required int page, int? category, int? source}) async {
    final result = await _getDiscountsUsecase(category: category ?? 0, source: source ?? 0, page: page);

    result.fold((error) => emit(DiscountsListState.error(error.message)), (discounts) {
      emit(
        DiscountsListState.loaded(
          discounts: discounts,
          currentPage: page,
          hasMorePages: discounts.isNotEmpty, // Assume more pages if we got results
          isLoadingMore: false,
          category: category,
          source: source,
        ),
      );
    });
  }

  Future<void> _loadMoreDiscounts(
    Emitter<DiscountsListState> emit, {
    required List<Discount> currentDiscounts,
    required int nextPage,
    int? category,
    int? source,
  }) async {
    final result = await _getDiscountsUsecase(category: category ?? 0, source: source ?? 0, page: nextPage);

    result.fold(
      (error) {
        // On error, revert to previous state without isLoadingMore
        emit(
          DiscountsListState.loaded(
            discounts: currentDiscounts,
            currentPage: nextPage - 1,
            hasMorePages: true,
            isLoadingMore: false,
            category: category,
            source: source,
          ),
        );
      },
      (newDiscounts) {
        final allDiscounts = [...currentDiscounts, ...newDiscounts];
        emit(
          DiscountsListState.loaded(
            discounts: allDiscounts,
            currentPage: nextPage,
            hasMorePages: newDiscounts.isNotEmpty, // No more pages if empty
            isLoadingMore: false,
            category: category,
            source: source,
          ),
        );
      },
    );
  }
}
