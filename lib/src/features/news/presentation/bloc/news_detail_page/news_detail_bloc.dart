import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/files/domain/entities/system_type.dart';
import '../../../../../shared/files/domain/usecases/usecases.dart';
import '../../../../../core/base_types/result.dart';
import '../../../domain/domain.dart';
import 'news_detail_event.dart';
import 'news_detail_state.dart';

class NewsDetailBloc extends Bloc<NewsDetailEvent, NewsDetailState> {
  final int newsId;
  final GetNewsDetailUsecase _getNewsDetailUsecase;
  final GetNewsStatsUsecase _getNewsStatsUsecase;
  final ToggleNewsLikeUsecase _toggleNewsLikeUsecase;
  final DownloadFileUsecase _downloadFileUsecase;

  NewsDetailBloc({
    required this.newsId,
    required GetNewsDetailUsecase getNewsDetailUsecase,
    required GetNewsStatsUsecase getNewsStatsUsecase,
    required ToggleNewsLikeUsecase toggleNewsLikeUsecase,
    required DownloadFileUsecase downloadFileUsecase,
  }) : _getNewsDetailUsecase = getNewsDetailUsecase,
       _getNewsStatsUsecase = getNewsStatsUsecase,
       _toggleNewsLikeUsecase = toggleNewsLikeUsecase,
       _downloadFileUsecase = downloadFileUsecase,
       super(const NewsDetailState.initial()) {
    on<LoadDetail>(_onLoadDetail);
    on<ToggleLike>(_onToggleLike);
    on<RefreshDetail>(_onRefreshDetail);
  }

  Future<void> _onLoadDetail(
    LoadDetail event,
    Emitter<NewsDetailState> emit,
  ) async {
    emit(const NewsDetailState.loading());
    await _loadDetail(emit);
  }

  Future<void> _onRefreshDetail(
    RefreshDetail event,
    Emitter<NewsDetailState> emit,
  ) async {
    await _loadDetail(emit);
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<NewsDetailState> emit,
  ) async {
    // Optimistic update
    state.maybeWhen(
      loaded: (newsDetail, likeCount, liked, commentCount, coverImage) {
        emit(
          NewsDetailState.loaded(
            newsDetail: newsDetail,
            likeCount: liked ? likeCount - 1 : likeCount + 1,
            liked: !liked,
            commentCount: commentCount,
            coverImage: coverImage,
          ),
        );
      },
      orElse: () {},
    );

    // Make API call
    final result = await _toggleNewsLikeUsecase(newsId);

    result.fold(
      (error) {
        // Revert on error
        state.maybeWhen(
          loaded: (newsDetail, likeCount, liked, commentCount, coverImage) {
            emit(
              NewsDetailState.loaded(
                newsDetail: newsDetail,
                likeCount: liked ? likeCount - 1 : likeCount + 1,
                liked: !liked,
                commentCount: commentCount,
                coverImage: coverImage,
              ),
            );
          },
          orElse: () {},
        );
      },
      (_) {
        // Success - state already updated optimistically
      },
    );
  }

  Future<void> _loadDetail(Emitter<NewsDetailState> emit) async {
    final detailResult = await _getNewsDetailUsecase(newsId);
    final statsResult = await _getNewsStatsUsecase(newsId);

    final detailError = detailResult.fold((e) => e.message, (_) => null);
    final statsError = statsResult.fold((e) => e.message, (_) => null);

    if (detailError != null || statsError != null) {
      emit(NewsDetailState.error(detailError ?? statsError!));
      return;
    }

    await detailResult.fold((_) async => null, (newsDetail) async {
      await statsResult.fold((_) async => null, (stats) async {
        emit(
          NewsDetailState.loaded(
            newsDetail: newsDetail,
            likeCount: stats.likeCount,
            liked: stats.like,
            commentCount: stats.commentCount,
          ),
        );
        await _loadCoverImage(newsDetail, emit);
      });
    });
  }

  Future<void> _loadCoverImage(
    NewsDetail newsDetail,
    Emitter<NewsDetailState> emit,
  ) async {
    if (newsDetail.image == null || newsDetail.image!.isEmpty) {
      return;
    }

    final result = await _downloadFileUsecase(
      systemType: SystemType.kp,
      download: false,
      uriFile: newsDetail.image,
    );

    result.fold(
      (error) {
        // Silently fail for image download
      },
      (imageBytes) {
        state.maybeWhen(
          loaded: (newsDetail, likeCount, liked, commentCount, _) {
            emit(
              NewsDetailState.loaded(
                newsDetail: newsDetail,
                likeCount: likeCount,
                liked: liked,
                commentCount: commentCount,
                coverImage: imageBytes,
              ),
            );
          },
          orElse: () {},
        );
      },
    );
  }
}
