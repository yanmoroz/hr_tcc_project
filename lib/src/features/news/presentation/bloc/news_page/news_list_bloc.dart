import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/files/domain/entities/system_type.dart';
import '../../../../../shared/files/domain/usecases/usecases.dart';
import '../../../../../core/types/result.dart';
import '../../../domain/domain.dart';
import 'news_list_event.dart';
import 'news_list_state.dart';

class NewsListBloc extends Bloc<NewsListEvent, NewsListState> {
  final GetNewsListUsecase _getNewsListUsecase;
  final DownloadFileUsecase _downloadFileUsecase;

  NewsListBloc({required GetNewsListUsecase getNewsListUsecase, required DownloadFileUsecase downloadFileUsecase})
    : _getNewsListUsecase = getNewsListUsecase,
      _downloadFileUsecase = downloadFileUsecase,
      super(const NewsListState.initial()) {
    on<LoadNews>(_onLoadNews);
    on<RefreshNews>(_onRefreshNews);
    on<LoadMoreNews>(_onLoadMoreNews);
  }

  Future<void> _onLoadNews(LoadNews event, Emitter<NewsListState> emit) async {
    emit(const NewsListState.loading());
    await _loadNews(emit, page: 0, category: event.category, search: event.search);
  }

  Future<void> _onRefreshNews(RefreshNews event, Emitter<NewsListState> emit) async {
    // Keep current state while refreshing, then reload from page 0
    await _loadNews(emit, page: 0, category: event.category, search: event.search);
  }

  Future<void> _onLoadMoreNews(LoadMoreNews event, Emitter<NewsListState> emit) async {
    // Extract state values first
    List<NewsItem>? newsItems;
    int? currentPage;
    bool? hasMorePages;
    bool? isLoadingMore;
    Map<int, Uint8List>? coverImages;
    int? category;
    String? search;

    state.maybeWhen(
      loaded:
          (
            loadedNewsItems,
            loadedCurrentPage,
            loadedHasMorePages,
            loadedIsLoadingMore,
            loadedCoverImages,
            loadedCategory,
            loadedSearch,
          ) {
            newsItems = loadedNewsItems;
            currentPage = loadedCurrentPage;
            hasMorePages = loadedHasMorePages;
            isLoadingMore = loadedIsLoadingMore;
            coverImages = loadedCoverImages;
            category = loadedCategory;
            search = loadedSearch;
          },
      orElse: () {},
    );

    // Only load more if we're in loaded state and not already loading more
    if (newsItems != null &&
        currentPage != null &&
        hasMorePages != null &&
        !(isLoadingMore ?? false) &&
        hasMorePages!) {
      // Emit state with isLoadingMore = true
      emit(
        NewsListState.loaded(
          newsItems: newsItems!,
          currentPage: currentPage!,
          hasMorePages: hasMorePages!,
          isLoadingMore: true,
          coverImages: coverImages ?? {},
          category: category,
          search: search,
        ),
      );

      // Load next page
      await _loadMoreNews(
        emit,
        currentNewsItems: newsItems!,
        currentCoverImages: coverImages ?? {},
        nextPage: currentPage! + 1,
        category: category,
        search: search,
      );
    }
  }

  Future<void> _loadNews(Emitter<NewsListState> emit, {required int page, int? category, String? search}) async {
    final result = await _getNewsListUsecase(page: page, category: category, search: search);

    await result.fold((error) async => emit(NewsListState.error(error.message)), (newsItems) async {
      emit(
        NewsListState.loaded(
          newsItems: newsItems,
          currentPage: page,
          hasMorePages: newsItems.isNotEmpty, // Assume more pages if we got results
          isLoadingMore: false,
          category: category,
          search: search,
        ),
      );
      await _loadCoverImages(newsItems, emit);
    });
  }

  Future<void> _loadMoreNews(
    Emitter<NewsListState> emit, {
    required List<NewsItem> currentNewsItems,
    required Map<int, Uint8List> currentCoverImages,
    required int nextPage,
    int? category,
    String? search,
  }) async {
    final result = await _getNewsListUsecase(page: nextPage, category: category, search: search);

    await result.fold(
      (error) async {
        // On error, revert to previous state without isLoadingMore
        emit(
          NewsListState.loaded(
            newsItems: currentNewsItems,
            currentPage: nextPage - 1,
            hasMorePages: true,
            isLoadingMore: false,
            coverImages: currentCoverImages,
            category: category,
            search: search,
          ),
        );
      },
      (newNewsItems) async {
        final allNewsItems = [...currentNewsItems, ...newNewsItems];
        emit(
          NewsListState.loaded(
            newsItems: allNewsItems,
            currentPage: nextPage,
            hasMorePages: newNewsItems.isNotEmpty, // No more pages if empty
            isLoadingMore: false,
            coverImages: currentCoverImages,
            category: category,
            search: search,
          ),
        );
        // Load cover images for new news items only
        await _loadCoverImages(newNewsItems, emit);
      },
    );
  }

  Future<void> _loadCoverImages(List<NewsItem> newsItems, Emitter<NewsListState> emit) async {
    final coverImages = <int, Uint8List>{};

    // Download images in parallel for news items that have image
    final futures = newsItems.where((newsItem) => newsItem.image != null && newsItem.image!.isNotEmpty).map((
      newsItem,
    ) async {
      final result = await _downloadFileUsecase(systemType: SystemType.kp, download: false, uriFile: newsItem.image);

      result.fold(
        (error) {
          // Silently fail for individual image downloads
        },
        (imageBytes) {
          coverImages[newsItem.id] = imageBytes;
        },
      );
    });

    await Future.wait(futures);

    // Emit updated state with cover images, merging with existing ones
    state.maybeWhen(
      loaded: (newsItems, currentPage, hasMorePages, isLoadingMore, existingCoverImages, category, search) {
        final mergedCoverImages = {...existingCoverImages, ...coverImages};
        emit(
          NewsListState.loaded(
            newsItems: newsItems,
            currentPage: currentPage,
            hasMorePages: hasMorePages,
            isLoadingMore: isLoadingMore,
            coverImages: mergedCoverImages,
            category: category,
            search: search,
          ),
        );
      },
      orElse: () {},
    );
  }
}
