import 'package:hr_tcc_project/src/core/base_types/result.dart';
import '../entities/gallery_image.dart';
import '../repositories/news_repository.dart';

class GetNewsGalleryUsecase {
  final NewsRepository repository;

  GetNewsGalleryUsecase(this.repository);

  Future<Result<List<GalleryImage>>> call(int galleryId) async {
    return await repository.getNewsGallery(galleryId);
  }
}
