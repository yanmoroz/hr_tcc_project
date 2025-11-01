import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'kp_upload_file_response_model.freezed.dart';
part 'kp_upload_file_response_model.g.dart';

/// KP system upload response model (matches AttachmentFile structure)
@freezed
abstract class KpUploadFileResponseModel with _$KpUploadFileResponseModel {
  const factory KpUploadFileResponseModel({
    required int id,
    required String name,
    required String url,
    required String folder,
    required String extension,
    required int size,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime created,
    required int fileType,
    required String systemType,
    String? icon,
    int? width,
    int? height,
    String? thumbnail,
  }) = _KpUploadFileResponseModel;

  factory KpUploadFileResponseModel.fromJson(Map<String, dynamic> json) => _$KpUploadFileResponseModelFromJson(json);
}

DateTime _dateTimeFromJson(dynamic value) {
  if (value is String) {
    return DateTime.parse(value);
  }
  return DateTime.now();
}

extension KpUploadFileResponseModelX on KpUploadFileResponseModel {
  UploadedFile toDomain() {
    return UploadedFile.fromKp(
      id: id,
      name: name,
      url: url,
      folder: folder,
      extension: extension,
      size: size,
      created: created,
      fileType: fileType,
      icon: icon,
      width: width,
      height: height,
      thumbnail: thumbnail,
    );
  }
}
