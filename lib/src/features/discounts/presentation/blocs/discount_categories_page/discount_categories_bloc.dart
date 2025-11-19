import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/result.dart';
import '../../../domain/domain.dart';
import 'discount_categories_event.dart';
import 'discount_categories_state.dart';

class DiscountCategoriesBloc
    extends Bloc<DiscountCategoriesEvent, DiscountCategoriesState> {
  final GetKpDiscountCategoriesUsecase _getKpDiscountCategoriesUsecase;
  final GetKpDiscountSourcesUsecase _getKpDiscountSourcesUsecase;

  DiscountCategoriesBloc({
    required GetKpDiscountCategoriesUsecase getKpDiscountCategoriesUsecase,
    required GetKpDiscountSourcesUsecase getKpDiscountSourcesUsecase,
  }) : _getKpDiscountCategoriesUsecase = getKpDiscountCategoriesUsecase,
       _getKpDiscountSourcesUsecase = getKpDiscountSourcesUsecase,
       super(const DiscountCategoriesState.initial()) {
    on<LoadCategories>(_onLoadCategories);
    on<RefreshCategories>(_onRefreshCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<DiscountCategoriesState> emit,
  ) async {
    emit(const DiscountCategoriesState.loading());
    await _loadCategoriesAndSources(emit);
  }

  Future<void> _onRefreshCategories(
    RefreshCategories event,
    Emitter<DiscountCategoriesState> emit,
  ) async {
    // Keep current state while refreshing, then reload
    await _loadCategoriesAndSources(emit);
  }

  Future<void> _loadCategoriesAndSources(
    Emitter<DiscountCategoriesState> emit,
  ) async {
    // Load both categories and sources in parallel
    final categoriesResult = await _getKpDiscountCategoriesUsecase();
    final sourcesResult = await _getKpDiscountSourcesUsecase();

    // Check if either call failed
    final categoriesError = categoriesResult.fold(
      (e) => e.message,
      (_) => null,
    );
    final sourcesError = sourcesResult.fold((e) => e.message, (_) => null);

    if (categoriesError != null || sourcesError != null) {
      emit(DiscountCategoriesState.error(categoriesError ?? sourcesError!));
      return;
    }

    // Both succeeded, emit loaded state
    categoriesResult.fold((_) => null, (categories) {
      sourcesResult.fold((_) => null, (sources) {
        emit(
          DiscountCategoriesState.loaded(
            categories: categories,
            sources: sources,
          ),
        );
      });
    });
  }
}
