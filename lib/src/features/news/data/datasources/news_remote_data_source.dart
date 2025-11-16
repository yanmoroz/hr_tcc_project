import '../../../../core/base_types/result.dart';
import '../models/kp_news_category_model.dart';
import '../models/news_list_response.dart';
import '../models/news_detail_model.dart';
import '../models/gallery_response.dart';

abstract class NewsRemoteDataSource {
  Future<Result<NewsListResponse>> getNewsList({
    int? category,
    String? search,
    required int page,
  });

  Future<Result<NewsDetailModel>> getNewsDetail(int newsId);

  Future<Result<({int likeCount, bool like, int commentCount})>> getNewsStats(
    int newsId,
  );

  Future<Result<GalleryResponse>> getNewsGallery(int galleryId);

  Future<Result<List<KpNewsCategoryModel>>> getKpNewsCategories();

  Future<Result<bool>> toggleNewsLike(int newsId);

  Future<Result<bool>> toggleNewsCommentLike(int newsId, int commentId);
}
