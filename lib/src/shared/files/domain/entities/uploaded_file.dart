import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/value_objects/system_type.dart';

part 'uploaded_file.freezed.dart';

/// Unified uploaded file entity that handles all system types
/// Uses sealed union type for type safety - each system type has its own variant
@freezed
sealed class UploadedFile with _$UploadedFile {
  /// ELMA system uploaded file
  const factory UploadedFile.elma({
    required String idFile, // UUID
  }) = ElmaUploadedFile;

  /// KP system uploaded file
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

  /// JIRA system uploaded file
  const factory UploadedFile.jira({
    required String id,
    required String filename,
    required String self,
    required DateTime created,
    required int size,
    required String content,
    String? mimeType,
    String? thumbnail,
    Map<String, dynamic>? author,
  }) = JiraUploadedFile;

  /// TCC system uploaded file
  const factory UploadedFile.tcc({
    required String id, // UUID
    required int size,
  }) = TccUploadedFile;

  /// _1C system uploaded file (minimal support)
  const factory UploadedFile.oneC() = OneCUploadedFile;
}

/// Extension for backward compatibility and convenience methods
extension UploadedFileX on UploadedFile {
  /// Get system type from the uploaded file variant
  SystemType get systemType {
    return switch (this) {
      ElmaUploadedFile() => SystemType.elma,
      KpUploadedFile() => SystemType.kp,
      JiraUploadedFile() => SystemType.jira,
      TccUploadedFile() => SystemType.tcc,
      OneCUploadedFile() => SystemType.oneC,
    };
  }

  /// Get file size if available
  int? get size {
    return switch (this) {
      KpUploadedFile(:final size) => size,
      JiraUploadedFile(:final size) => size,
      TccUploadedFile(:final size) => size,
      _ => null,
    };
  }

  /// Get file ID if available
  String? get id {
    return switch (this) {
      ElmaUploadedFile(:final idFile) => idFile,
      KpUploadedFile(:final id) => id.toString(),
      JiraUploadedFile(:final id) => id,
      TccUploadedFile(:final id) => id,
      _ => null,
    };
  }

  /// Get KP-specific fields (for backward compatibility)
  KpUploadedFile? get asKp {
    return switch (this) {
      KpUploadedFile() => this as KpUploadedFile,
      _ => null,
    };
  }

  /// Get JIRA-specific fields (for backward compatibility)
  JiraUploadedFile? get asJira {
    return switch (this) {
      JiraUploadedFile() => this as JiraUploadedFile,
      _ => null,
    };
  }

  /// Get ELMA-specific fields (for backward compatibility)
  ElmaUploadedFile? get asElma {
    return switch (this) {
      ElmaUploadedFile() => this as ElmaUploadedFile,
      _ => null,
    };
  }

  /// Get TCC-specific fields (for backward compatibility)
  TccUploadedFile? get asTcc {
    return switch (this) {
      TccUploadedFile() => this as TccUploadedFile,
      _ => null,
    };
  }
}
