import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../../../../core/base_types/result.dart';
import '../../../../core/value_objects/system_type.dart';
import '../../../../core/value_objects/tcc_image_destination_type.dart';
import '../domain.dart';

abstract class FileRepository {
  /// Uploads a file to the server
  ///
  /// [file] - The file to upload
  /// [systemType] - The target system (ELMA, KP, JIRA, TCC, _1C)
  /// [group] - Optional file group for KP system (NEWS, DISCOUNT, PASS)
  /// [issueIdOrKey] - Optional JIRA issue ID/key
  /// [imageDestination] - Required for TCC system (APPLICATION_FORM, PERSON)
  /// [destinationId] - Required for TCC system (UUID of entity)
  /// [onProgress] - Optional progress callback
  Future<Result<UploadedFile>> uploadFile({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    TccImageDestinationType? imageDestination,
    String? destinationId,
    ProgressCallback? onProgress,
  });

  /// Downloads a file from the server
  ///
  /// [systemType] - The source system (ELMA, KP, JIRA, TCC, _1C)
  /// [download] - true to force download, false to display
  /// [idFile] - File ID from system (ELMA/KP)
  /// [uriFile] - URI path for ELMA system
  /// [urlFile] - Full URL for JIRA system
  /// [imageDestination] - Required for TCC system (APPLICATION_FORM, PERSON)
  /// [destinationId] - Required for TCC system (UUID of entity)
  /// [onProgress] - Optional progress callback
  Future<Result<Uint8List>> downloadFile({
    required SystemType systemType,
    required bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    TccImageDestinationType? imageDestination,
    String? destinationId,
    ProgressCallback? onProgress,
  });

  /// Clean up expired cache files
  /// Call this periodically to free up storage space
  Future<void> cleanupExpiredCache();
}
