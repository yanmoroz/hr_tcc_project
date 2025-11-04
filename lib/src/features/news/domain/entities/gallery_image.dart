import 'package:freezed_annotation/freezed_annotation.dart';

part 'gallery_image.freezed.dart';

/// Gallery image entity
@freezed
abstract class GalleryImage with _$GalleryImage {
  const factory GalleryImage({
    required int id,
    required String name,
    required String url,
    required String folder,
    required String fileExtension,
    required int size,
    required int width,
    required int height,
    String? thumbnail,
    required DateTime createdData,
    required int fileType,
    int? priority,
  }) = _GalleryImage;
}
