import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'gallery_image_model.freezed.dart';
part 'gallery_image_model.g.dart';

@freezed
abstract class GalleryImageModel with _$GalleryImageModel {
  const factory GalleryImageModel({
    required int id,
    required String name,
    required String url,
    required String folder,
    @JsonKey(name: 'extension') required String fileExtension,
    required int size,
    required int width,
    required int height,
    String? thumbnail,
    required DateTime createdData,
    required int fileType,
    int? priority,
  }) = _GalleryImageModel;

  factory GalleryImageModel.fromJson(Map<String, dynamic> json) =>
      _$GalleryImageModelFromJson(json);
}

extension GalleryImageModelX on GalleryImageModel {
  GalleryImage toDomain() => GalleryImage(
    id: id,
    name: name,
    url: url,
    folder: folder,
    fileExtension: fileExtension,
    size: size,
    width: width,
    height: height,
    thumbnail: thumbnail,
    createdData: createdData,
    fileType: fileType,
    priority: priority,
  );
}
