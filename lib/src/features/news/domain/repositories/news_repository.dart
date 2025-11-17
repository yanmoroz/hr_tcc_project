import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../entities/kp_news_category.dart';
import '../entities/news_item.dart';
import '../entities/news_detail.dart';
import '../entities/gallery_image.dart';

abstract class NewsRepository {
  Future<Result<List<NewsItem>>> getNewsList({
    int? category,
    String? search,
    required int page,
  });

  Future<Result<NewsDetail>> getNewsDetail(int newsId);

  Future<Result<({int likeCount, bool like, int commentCount})>> getNewsStats(
    int newsId,
  );

  Future<Result<List<GalleryImage>>> getNewsGallery(int galleryId);

  Future<Result<List<KpNewsCategory>>> getKpNewsCategories();

  Future<Result<bool>> toggleNewsLike(int newsId);
}
