import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/logging/app_logger.dart';
import '../../../domain/domain.dart';

import 'resell_items_event.dart';
import 'resell_items_state.dart';

class ResellItemsBloc extends Bloc<ResellItemsEvent, ResellItemsState> {
  final GetResellItemsUsecase _getResellItemsUsecase;

  static const int _pageSize = 20;

  ResellItemsBloc(this._getResellItemsUsecase)
    : super(const ResellItemsState.initial()) {
    on<LoadResellItems>(_onLoadResellItems);
    on<LoadMore>(_onLoadMore);
    on<RefreshItems>(_onRefreshItems);
    on<FilterByStatus>(_onFilterByStatus);
  }

  Future<void> _onLoadResellItems(
    LoadResellItems event,
    Emitter<ResellItemsState> emit,
  ) async {
    emit(const ResellItemsState.loading());
    await _loadItems(emit, 0, 1); // Default status = 1 (Active)
  }

  Future<void> _onLoadMore(
    LoadMore event,
    Emitter<ResellItemsState> emit,
  ) async {
    await state.maybeWhen(
      loaded: (items, page, hasMore, isLoadingMore, status) async {
        if (!isLoadingMore && hasMore) {
          emit(
            ResellItemsState.loaded(
              items: items,
              currentPage: page,
              hasMorePages: hasMore,
              isLoadingMore: true,
              currentStatus: status,
            ),
          );

          await _loadItems(emit, page + 1, status, existingItems: items);
        }
      },
      orElse: () async {},
    );
  }

  Future<void> _onRefreshItems(
    RefreshItems event,
    Emitter<ResellItemsState> emit,
  ) async {
    final currentStatus = state.maybeWhen(
      loaded: (_, __, ___, ____, status) => status,
      orElse: () => 1,
    );

    emit(const ResellItemsState.loading());
    await _loadItems(emit, 1, currentStatus);
  }

  Future<void> _onFilterByStatus(
    FilterByStatus event,
    Emitter<ResellItemsState> emit,
  ) async {
    emit(const ResellItemsState.loading());
    await _loadItems(emit, 1, event.status);
  }

  Future<void> _loadItems(
    Emitter<ResellItemsState> emit,
    int page,
    int status, {
    List<ResellItem>? existingItems,
  }) async {
    final result = await _getResellItemsUsecase(
      status: ResellStatus.fromValue(status),
      page: page,
      pageSize: _pageSize,
    );

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to load resell items: ${error.toString()}');
          if (existingItems != null) {
            // If loading more failed, revert to previous state
            emit(
              ResellItemsState.loaded(
                items: existingItems,
                currentPage: page - 1,
                hasMorePages: true,
                isLoadingMore: false,
                currentStatus: status,
              ),
            );
          } else {
            emit(ResellItemsState.error(error.toString()));
          }
        },
        (items) {
          final allItems = existingItems != null
              ? [...existingItems, ...items]
              : items;

          emit(
            ResellItemsState.loaded(
              items: allItems,
              currentPage: page,
              hasMorePages: items.length == _pageSize,
              isLoadingMore: false,
              currentStatus: status,
            ),
          );
        },
      );
    }
  }
}
