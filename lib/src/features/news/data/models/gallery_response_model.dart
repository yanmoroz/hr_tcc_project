import 'package:freezed_annotation/freezed_annotation.dart';

import 'gallery_image_model.dart';

part 'gallery_response_model.freezed.dart';
part 'gallery_response_model.g.dart';

@freezed
abstract class GalleryResponseModel with _$GalleryResponseModel {
  const factory GalleryResponseModel({required List<GalleryImageModel> items}) =
      _GalleryResponseModel;

  factory GalleryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GalleryResponseModelFromJson(json);
}
