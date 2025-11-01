import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'jira_upload_file_response_model.freezed.dart';
part 'jira_upload_file_response_model.g.dart';

/// JIRA system upload response model
@freezed
abstract class JiraUploadFileResponseModel with _$JiraUploadFileResponseModel {
  const factory JiraUploadFileResponseModel({
    required String id,
    required String filename,
    required String self,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime created,
    required int size,
    required String content,
    required String systemType,
    String? mimeType,
    String? thumbnail,
    Map<String, dynamic>? author,
  }) = _JiraUploadFileResponseModel;

  factory JiraUploadFileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$JiraUploadFileResponseModelFromJson(json);
}

DateTime _dateTimeFromJson(dynamic value) {
  if (value is String) {
    return DateTime.parse(value);
  }
  return DateTime.now();
}

extension JiraUploadFileResponseModelX on JiraUploadFileResponseModel {
  UploadedFile toDomain() {
    return UploadedFile.fromJira(
      id: id,
      filename: filename,
      self: self,
      created: created,
      size: size,
      content: content,
      mimeType: mimeType,
      thumbnail: thumbnail,
      author: author,
    );
  }
}
