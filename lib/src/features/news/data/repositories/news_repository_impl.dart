import '../../../../core/base_types/base_repository.dart';
import '../../../../core/base_types/result.dart';
import '../../domain/domain.dart';
import '../datasources/news_remote_data_source.dart';
import '../models/kp_news_category_model.dart';
import '../models/news_detail_model.dart';
import '../models/gallery_image_model.dart';
import '../models/news_item_model.dart';

class NewsRepositoryImpl with BaseRepository implements NewsRepository {
  final NewsRemoteDataSource _remoteDataSource;

  NewsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<NewsItem>>> getNewsList({
    int? category,
    String? search,
    required int page,
  }) async {
    final result = await _remoteDataSource.getNewsList(
      category: category,
      search: search,
      page: page,
    );

    return result.map(
      (response) => response.items.map((model) => model.toDomain()).toList(),
    );
  }

  @override
  Future<Result<NewsDetail>> getNewsDetail(int newsId) async {
    final result = await _remoteDataSource.getNewsDetail(newsId);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<({int likeCount, bool like, int commentCount})>> getNewsStats(
    int newsId,
  ) async {
    final result = await _remoteDataSource.getNewsStats(newsId);
    return result.map(
      (response) => (
        likeCount: response.likeCount,
        like: response.like,
        commentCount: response.commentCount,
      ),
    );
  }

  @override
  Future<Result<List<GalleryImage>>> getNewsGallery(int galleryId) async {
    final result = await _remoteDataSource.getNewsGallery(galleryId);
    return result.map(
      (response) => response.items.map((model) => model.toDomain()).toList(),
    );
  }

  @override
  Future<Result<List<KpNewsCategory>>> getKpNewsCategories() async {
    final result = await _remoteDataSource.getKpNewsCategories();
    return mapResultList(result, (model) => model.toDomain());
  }

  @override
  Future<Result<bool>> toggleNewsLike(int newsId) async {
    return await _remoteDataSource.toggleNewsLike(newsId);
  }
}
