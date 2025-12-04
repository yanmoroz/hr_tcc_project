import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/value_objects/system_type.dart';
import 'jira_author.dart';

part 'uploaded_file.freezed.dart';

@freezed
sealed class UploadedFile with _$UploadedFile {
  const factory UploadedFile.elma({
    required String idFile, // UUID
  }) = ElmaUploadedFile;

  const factory UploadedFile.jira({
    required String id,
    required String filename,
    required String self,
    required DateTime created,
    required int size,
    required String content,
    String? mimeType,
    String? thumbnail,
    JiraAuthor? author,
  }) = JiraUploadedFile;

  const factory UploadedFile.kp({
    required int id,
    required String name,
    required String url,
    required String folder,
    required String extension,
    required int size,
    required DateTime created,
    required int fileType,
    String? icon,
    int? width,
    int? height,
    String? thumbnail,
    int? priority,
  }) = KpUploadedFile;

  const factory UploadedFile.oneC() = OneCUploadedFile;

  const factory UploadedFile.tcc({
    required String id, // UUID
    required int size,
  }) = TccUploadedFile;
}

extension UploadedFileX on UploadedFile {
  ElmaUploadedFile? get asElma {
    return switch (this) {
      ElmaUploadedFile() => this as ElmaUploadedFile,
      _ => null,
    };
  }

  JiraUploadedFile? get asJira {
    return switch (this) {
      JiraUploadedFile() => this as JiraUploadedFile,
      _ => null,
    };
  }

  KpUploadedFile? get asKp {
    return switch (this) {
      KpUploadedFile() => this as KpUploadedFile,
      _ => null,
    };
  }

  TccUploadedFile? get asTcc {
    return switch (this) {
      TccUploadedFile() => this as TccUploadedFile,
      _ => null,
    };
  }

  String? get id {
    return switch (this) {
      ElmaUploadedFile(:final idFile) => idFile,
      KpUploadedFile(:final id) => id.toString(),
      JiraUploadedFile(:final id) => id,
      TccUploadedFile(:final id) => id,
      _ => null,
    };
  }

  int? get size {
    return switch (this) {
      KpUploadedFile(:final size) => size,
      JiraUploadedFile(:final size) => size,
      TccUploadedFile(:final size) => size,
      _ => null,
    };
  }

  SystemType get systemType {
    return switch (this) {
      ElmaUploadedFile() => SystemType.elma,
      KpUploadedFile() => SystemType.kp,
      JiraUploadedFile() => SystemType.jira,
      TccUploadedFile() => SystemType.tcc,
      OneCUploadedFile() => SystemType.oneC,
    };
  }
}
