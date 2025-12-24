import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../value_objects/system_type.dart';
import '../../entities/uploaded_file.dart';
import 'jira_author_model.dart';

part 'uploaded_file_model.freezed.dart';
part 'uploaded_file_model.g.dart';

DateTime _dateTimeFromJson(dynamic value) {
  if (value is String) {
    return DateTime.parse(value);
  }
  return DateTime.now();
}

@Freezed(unionKey: 'systemType', unionValueCase: FreezedUnionCase.none)
sealed class UploadedFileModel with _$UploadedFileModel {
  @FreezedUnionValue('ELMA')
  const factory UploadedFileModel.elma({
    required String idFile,
    required String systemType,
  }) = ElmaUploadedFileModel;

  factory UploadedFileModel.fromJson(Map<String, dynamic> json) =>
      _$UploadedFileModelFromJson(json);

  @FreezedUnionValue('JIRA')
  const factory UploadedFileModel.jira({
    required String id,
    required String self,
    required String filename,
    required JiraAuthorModel author,
    required String created,
    required int size,
    required String mimeType,
    required String content,
    required String thumbnail,
    required String systemType,
  }) = JiraUploadedFileModel;

  @FreezedUnionValue('KP')
  const factory UploadedFileModel.kp({
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
    int? priority,
  }) = KpUploadedFileModel;

  @FreezedUnionValue('_1C')
  const factory UploadedFileModel.oneC({
    required String systemType,
    Map<String, dynamic>? rawData,
  }) = OneCUploadedFileModel;

  @FreezedUnionValue('TCC')
  const factory UploadedFileModel.tcc({
    required String id,
    required int size,
    required String systemType,
  }) = TccUploadedFileModel;
}

extension UploadedFileModelX on UploadedFileModel {
  SystemType get systemType {
    return switch (this) {
      ElmaUploadedFileModel() => SystemType.elma,
      JiraUploadedFileModel() => SystemType.jira,
      KpUploadedFileModel() => SystemType.kp,
      TccUploadedFileModel() => SystemType.tcc,
      OneCUploadedFileModel() => SystemType.oneC,
    };
  }

  UploadedFile toDomain() {
    return switch (this) {
      ElmaUploadedFileModel(:final idFile) => UploadedFile.elma(idFile: idFile),
      JiraUploadedFileModel(
        :final id,
        :final self,
        :final filename,
        :final author,
        :final created,
        :final size,
        :final mimeType,
        :final content,
        :final thumbnail,
      ) =>
        UploadedFile.jira(
          id: id,
          self: self,
          filename: filename,
          author: author.toDomain(),
          created: DateTime.parse(created),
          size: size,
          mimeType: mimeType,
          content: content,
          thumbnail: thumbnail,
        ),
      KpUploadedFileModel(
        :final id,
        :final name,
        :final url,
        :final folder,
        :final extension,
        :final size,
        :final created,
        :final fileType,
        :final icon,
        :final width,
        :final height,
        :final thumbnail,
        :final priority,
      ) =>
        UploadedFile.kp(
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
          priority: priority,
        ),
      TccUploadedFileModel(:final id, :final size) => UploadedFile.tcc(
        id: id,
        size: size,
      ),
      OneCUploadedFileModel() => UploadedFile.oneC(),
    };
  }
}
