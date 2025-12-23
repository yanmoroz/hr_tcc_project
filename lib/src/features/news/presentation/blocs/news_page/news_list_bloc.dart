import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/cache/image_cache_service.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../domain/domain.dart';
import '../../view_models/news_item_view_model.dart';
import 'news_list_event.dart';
import 'news_list_state.dart';

class NewsListBloc extends Bloc<NewsListEvent, NewsListState> {
  final GetNewsListUsecase _getNewsListUsecase;
  final ImageCacheService _imageCacheService;

  NewsListBloc({
    required GetNewsListUsecase getNewsListUsecase,
    required ImageCacheService imageCacheService,
  }) : _getNewsListUsecase = getNewsListUsecase,
       _imageCacheService = imageCacheService,
       super(const NewsListState()) {
    on<LoadNews>(_onLoadNews);
    on<RefreshNews>(_onRefreshNews);
    on<LoadMoreNews>(_onLoadMoreNews);
  }

  Future<void> _loadCoverImages(Emitter<NewsListState> emit) async {
    final coverImages = <int, Uint8List>{};

    // Download images in parallel for news items that have image
    final futures = state.newsItems
        .where(
          (vm) => vm.newsItem.image != null && vm.newsItem.image!.isNotEmpty,
        )
        .map((vm) async {
          final imageUri = vm.newsItem.image!;

          // Check cache first
          final cached = _imageCacheService.getCached(imageUri);
          if (cached != null) {
            coverImages[vm.newsItem.id] = cached;
            return;
          }

          // Fetch via cache service
          final imageBytes = await _imageCacheService.getImageByUri(
            uri: imageUri,
            systemType: SystemType.kp,
          );

          if (imageBytes != null) {
            coverImages[vm.newsItem.id] = imageBytes;
          }
        });

    await Future.wait(futures);

    // Update ViewModels with loaded cover images
    if (state.status == LoadingStatus.success && coverImages.isNotEmpty) {
      final updatedNewsItems = state.newsItems.map((vm) {
        final coverImage = coverImages[vm.newsItem.id];
        if (coverImage != null) {
          return vm.copyWith(coverImage: coverImage);
        }
        return vm;
      }).toList();

      emit(state.copyWith(newsItems: updatedNewsItems));
    }
  }

  Future<void> _loadMoreNews(
    Emitter<NewsListState> emit, {
    required List<NewsItemViewModel> currentNewsItems,
    required int nextPage,
    int? category,
    String? search,
  }) async {
    final result = await _getNewsListUsecase(
      page: nextPage,
      category: category,
      search: search,
    );

    await result.fold(
      (error) async {
        // On error, revert to previous state without isLoadingMore
        emit(
          state.copyWith(
            newsItems: currentNewsItems,
            currentPage: nextPage - 1,
            hasMorePages: true,
            isLoadingMore: false,
            category: category,
            search: search,
          ),
        );
      },
      (newNewsItems) async {
        final newViewModels = newNewsItems
            .map((item) => NewsItemViewModel(newsItem: item))
            .toList();
        final allNewsItems = [...currentNewsItems, ...newViewModels];
        emit(
          state.copyWith(
            newsItems: allNewsItems,
            currentPage: nextPage,
            hasMorePages: newNewsItems.isNotEmpty,
            isLoadingMore: false,
            category: category,
            search: search,
          ),
        );
        // Load cover images for new news items
        await _loadCoverImages(emit);
      },
    );
  }

  Future<void> _loadNews(
    Emitter<NewsListState> emit, {
    required int page,
    int? category,
    String? search,
  }) async {
    final result = await _getNewsListUsecase(
      page: page,
      category: category,
      search: search,
    );

    await result.fold(
      (error) async => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.toString(),
        ),
      ),
      (newsItems) async {
        final viewModels = newsItems
            .map((item) => NewsItemViewModel(newsItem: item))
            .toList();
        emit(
          state.copyWith(
            status: LoadingStatus.success,
            newsItems: viewModels,
            currentPage: page,
            hasMorePages: newsItems.isNotEmpty,
            isLoadingMore: false,
            category: category,
            search: search,
          ),
        );
        await _loadCoverImages(emit);
      },
    );
  }

  Future<void> _onLoadMoreNews(
    LoadMoreNews event,
    Emitter<NewsListState> emit,
  ) async {
    // Only load more if we're in success state and not already loading more
    if (state.status != LoadingStatus.success ||
        state.isLoadingMore ||
        !state.hasMorePages) {
      return;
    }

    // Emit state with isLoadingMore = true
    emit(state.copyWith(isLoadingMore: true));

    // Load next page
    await _loadMoreNews(
      emit,
      currentNewsItems: state.newsItems,
      nextPage: state.currentPage + 1,
      category: state.category,
      search: state.search,
    );
  }

  Future<void> _onLoadNews(LoadNews event, Emitter<NewsListState> emit) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadNews(
      emit,
      page: 0,
      category: event.category,
      search: event.search,
    );
  }

  Future<void> _onRefreshNews(
    RefreshNews event,
    Emitter<NewsListState> emit,
  ) async {
    // Keep current state while refreshing, then reload from page 0
    await _loadNews(
      emit,
      page: 0,
      category: event.category,
      search: event.search,
    );
  }
}
