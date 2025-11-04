import 'package:hr_tcc_project/src/core/network/api_call_executor.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/network/api_constants.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import '../models/news_list_response.dart';
import '../models/news_detail_model.dart';
import '../models/news_stats_model.dart';
import '../models/gallery_response.dart';

abstract class NewsRemoteDataSource {
  Future<Result<NewsListResponse>> getNewsList({
    int? category,
    String? search,
    required int page,
  });

  Future<Result<NewsDetailModel>> getNewsDetail(int newsId);

  Future<Result<NewsStatsModel>> getNewsStats(int newsId);

  Future<Result<GalleryResponse>> getNewsGallery(int galleryId);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiClient _apiClient;

  NewsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<NewsListResponse>> getNewsList({
    int? category,
    String? search,
    required int page,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        final queryParams = <String, dynamic>{
          'page': page,
          if (category != null) 'category': category,
          if (search != null) 'search': search,
        };
        return _apiClient.get(
          ApiConstants.newsEndpoint,
          queryParameters: queryParams,
        );
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return NewsListResponse.fromJson(data);
      },
    );
  }

  @override
  Future<Result<NewsDetailModel>> getNewsDetail(int newsId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.newsDetailEndpoint(newsId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return NewsDetailModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<NewsStatsModel>> getNewsStats(int newsId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.newsStatsEndpoint(newsId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return NewsStatsModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<GalleryResponse>> getNewsGallery(int galleryId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.newsGalleryEndpoint(galleryId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return GalleryResponse.fromJson(data);
      },
    );
  }
}