import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/base_types/result.dart';
import '../../../../../core/files/files_service.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../domain/domain.dart';
import 'news_detail_event.dart';
import 'news_detail_state.dart';

class NewsDetailBloc extends Bloc<NewsDetailEvent, NewsDetailState> {
  final int newsId;
  final GetNewsDetailUsecase _getNewsDetailUsecase;
  final GetNewsStatsUsecase _getNewsStatsUsecase;
  final ToggleNewsLikeUsecase _toggleNewsLikeUsecase;
  final FilesService _filesService;

  NewsDetailBloc({
    required this.newsId,
    required GetNewsDetailUsecase getNewsDetailUsecase,
    required GetNewsStatsUsecase getNewsStatsUsecase,
    required ToggleNewsLikeUsecase toggleNewsLikeUsecase,
    required FilesService filesService,
  }) : _getNewsDetailUsecase = getNewsDetailUsecase,
       _getNewsStatsUsecase = getNewsStatsUsecase,
       _toggleNewsLikeUsecase = toggleNewsLikeUsecase,
       _filesService = filesService,
       super(const NewsDetailState()) {
    on<LoadDetail>(_onLoadDetail);
    on<ToggleLike>(_onToggleLike);
    on<RefreshDetail>(_onRefreshDetail);
  }

  Future<void> _loadCoverImage(
    NewsDetail newsDetail,
    Emitter<NewsDetailState> emit,
  ) async {
    if (newsDetail.image == null || newsDetail.image!.isEmpty) {
      return;
    }

    final result = await _filesService.downloadFile(
      systemType: SystemType.kp,
      download: false,
      uriFile: newsDetail.image,
    );

    result.fold(
      (error) {
        // Silently fail for image download
      },
      (imageBytes) {
        if (state.status == LoadingStatus.success) {
          emit(state.copyWith(coverImage: imageBytes));
        }
      },
    );
  }

  Future<void> _loadDetail(Emitter<NewsDetailState> emit) async {
    final detailResult = await _getNewsDetailUsecase(newsId);
    final statsResult = await _getNewsStatsUsecase(newsId);

    final detailError = detailResult.fold((e) => e.message, (_) => null);
    final statsError = statsResult.fold((e) => e.message, (_) => null);

    if (detailError != null || statsError != null) {
      emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: detailError ?? statsError!,
        ),
      );
      return;
    }

    await detailResult.fold((_) async => null, (newsDetail) async {
      await statsResult.fold((_) async => null, (stats) async {
        emit(
          state.copyWith(
            status: LoadingStatus.success,
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

  Future<void> _onLoadDetail(
    LoadDetail event,
    Emitter<NewsDetailState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
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
    if (state.status == LoadingStatus.success) {
      emit(
        state.copyWith(
          likeCount: state.liked ? state.likeCount - 1 : state.likeCount + 1,
          liked: !state.liked,
        ),
      );
    }

    // Make API call
    final result = await _toggleNewsLikeUsecase(newsId);

    result.fold(
      (error) {
        // Revert on error
        if (state.status == LoadingStatus.success) {
          emit(
            state.copyWith(
              likeCount: state.liked
                  ? state.likeCount - 1
                  : state.likeCount + 1,
              liked: !state.liked,
            ),
          );
        }
      },
      (_) {
        // Success - state already updated optimistically
      },
    );
  }
}
