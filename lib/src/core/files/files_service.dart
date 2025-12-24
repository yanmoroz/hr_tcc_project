import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../base_types/result.dart';
import '../value_objects/system_type.dart';
import '../value_objects/tcc_image_destination_type.dart';
import 'entities/uploaded_file.dart';
import 'value_objects/file_group.dart';

/// Core file service providing upload/download with caching.
abstract class FilesService {
  /// Cleans up expired cache entries (24-hour TTL)
  Future<void> cleanupExpiredCache();

  /// Downloads file with optional disk caching
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

  /// Uploads file with progress tracking
  Future<Result<UploadedFile>> uploadFile({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    TccImageDestinationType? imageDestination,
    String? destinationId,
    ProgressCallback? onProgress,
  });
}
