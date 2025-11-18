import '../../../../core/base_types/result.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/gallery_response_model.dart';
import '../models/kp_news_category_model.dart';
import '../models/news_detail_model.dart';
import '../models/news_list_response_model.dart';
import 'news_remote_data_source.dart';

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiClient _apiClient;

  NewsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<NewsListResponseModel>> getNewsList({
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
        return NewsListResponseModel.fromJson(data);
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
  Future<Result<({int likeCount, bool like, int commentCount})>> getNewsStats(
    int newsId,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.newsStatsEndpoint(newsId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return (
          likeCount: data['likeCount'] as int,
          like: data['like'] as bool,
          commentCount: data['commentCount'] as int,
        );
      },
    );
  }

  @override
  Future<Result<GalleryResponseModel>> getNewsGallery(int galleryId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () =>
          _apiClient.get(ApiConstants.newsGalleryEndpoint(galleryId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return GalleryResponseModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<List<KpNewsCategoryModel>>> getKpNewsCategories() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.kpNewsCategoryEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final newsCategoriesJson = data['newsCategories'] as List<dynamic>;
        return newsCategoriesJson
            .map(
              (json) =>
                  KpNewsCategoryModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      },
    );
  }

  @override
  Future<Result<bool>> toggleNewsLike(int newsId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(ApiConstants.newsLikeEndpoint(newsId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return data['like'] as bool;
      },
    );
  }
}
