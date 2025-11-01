import 'package:freezed_annotation/freezed_annotation.dart';

import 'system_type.dart';

part 'uploaded_file.freezed.dart';

/// Unified uploaded file entity that handles all system types
@freezed
abstract class UploadedFile with _$UploadedFile {
  const factory UploadedFile({
    required SystemType systemType,
    // KP system fields
    int? id,
    String? name,
    String? url,
    String? folder,
    String? extension,
    int? size,
    DateTime? created,
    int? fileType,
    String? icon,
    int? width,
    int? height,
    String? thumbnail,
    // ELMA system fields
    String? idFile, // UUID
    // JIRA system fields
    String? jiraId,
    String? filename,
    String? self,
    String? content,
    String? mimeType,
    Map<String, dynamic>? author,
  }) = _UploadedFile;

  /// Converts KP response to AttachmentFile-like structure
  factory UploadedFile.fromKp({
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
  }) {
    return UploadedFile(
      systemType: SystemType.kp,
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

  /// Creates from ELMA response
  factory UploadedFile.fromElma({required String idFile}) {
    return UploadedFile(systemType: SystemType.elma, idFile: idFile);
  }

  /// Creates from JIRA response
  factory UploadedFile.fromJira({
    required String id,
    required String filename,
    required String self,
    required DateTime created,
    required int size,
    required String content,
    String? mimeType,
    String? thumbnail,
    Map<String, dynamic>? author,
  }) {
    return UploadedFile(
      systemType: SystemType.jira,
      jiraId: id,
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
