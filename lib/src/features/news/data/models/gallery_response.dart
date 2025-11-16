import 'package:freezed_annotation/freezed_annotation.dart';

import 'gallery_image_model.dart';

part 'gallery_response.freezed.dart';
part 'gallery_response.g.dart';

@freezed
abstract class GalleryResponse with _$GalleryResponse {
  const factory GalleryResponse({required List<GalleryImageModel> items}) =
      _GalleryResponse;

  factory GalleryResponse.fromJson(Map<String, dynamic> json) =>
      _$GalleryResponseFromJson(json);
}
