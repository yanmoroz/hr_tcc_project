import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/base_types/result.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../../../shared/files/domain/domain.dart';
import '../../../domain/domain.dart';
import 'news_list_event.dart';
import 'news_list_state.dart';

class NewsListBloc extends Bloc<NewsListEvent, NewsListState> {
  final GetNewsListUsecase _getNewsListUsecase;
  final DownloadFileUsecase _downloadFileUsecase;

  NewsListBloc({
    required GetNewsListUsecase getNewsListUsecase,
    required DownloadFileUsecase downloadFileUsecase,
  }) : _getNewsListUsecase = getNewsListUsecase,
       _downloadFileUsecase = downloadFileUsecase,
       super(const NewsListState()) {
    on<LoadNews>(_onLoadNews);
    on<RefreshNews>(_onRefreshNews);
    on<LoadMoreNews>(_onLoadMoreNews);
  }

  Future<void> _loadCoverImages(
    List<NewsItem> newsItems,
    Emitter<NewsListState> emit,
  ) async {
    final coverImages = <int, Uint8List>{};

    // Download images in parallel for news items that have image
    final futures = newsItems
        .where(
          (newsItem) => newsItem.image != null && newsItem.image!.isNotEmpty,
        )
        .map((newsItem) async {
          final result = await _downloadFileUsecase(
            systemType: SystemType.kp,
            download: false,
            uriFile: newsItem.image,
          );

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
    if (state.status == LoadingStatus.success) {
      final mergedCoverImages = {...state.coverImages, ...coverImages};
      emit(state.copyWith(coverImages: mergedCoverImages));
    }
  }

  Future<void> _loadMoreNews(
    Emitter<NewsListState> emit, {
    required List<NewsItem> currentNewsItems,
    required Map<int, Uint8List> currentCoverImages,
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
            coverImages: currentCoverImages,
            category: category,
            search: search,
          ),
        );
      },
      (newNewsItems) async {
        final allNewsItems = [...currentNewsItems, ...newNewsItems];
        emit(
          state.copyWith(
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
          errorMessage: error.message,
        ),
      ),
      (newsItems) async {
        emit(
          state.copyWith(
            status: LoadingStatus.success,
            newsItems: newsItems,
            currentPage: page,
            hasMorePages:
                newsItems.isNotEmpty, // Assume more pages if we got results
            isLoadingMore: false,
            category: category,
            search: search,
          ),
        );
        await _loadCoverImages(newsItems, emit);
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
      currentCoverImages: state.coverImages,
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
