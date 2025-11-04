import 'package:hr_tcc_project/src/core/types/result.dart';
import '../../domain/domain.dart';
import '../data.dart';

class NewsRepositoryImpl implements NewsRepository {
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

    return result.map((response) => response.items.map((model) => model.toDomain()).toList());
  }

  @override
  Future<Result<NewsDetail>> getNewsDetail(int newsId) async {
    final result = await _remoteDataSource.getNewsDetail(newsId);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<NewsStats>> getNewsStats(int newsId) async {
    final result = await _remoteDataSource.getNewsStats(newsId);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<List<GalleryImage>>> getNewsGallery(int galleryId) async {
    final result = await _remoteDataSource.getNewsGallery(galleryId);
    return result.map((response) => response.items.map((model) => model.toDomain()).toList());
  }
}