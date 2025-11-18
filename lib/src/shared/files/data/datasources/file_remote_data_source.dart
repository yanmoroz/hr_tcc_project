import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../../../../core/base_types/result.dart';

import '../../../../core/value_objects/system_type.dart';
import '../../domain/domain.dart';
import '../models/uploaded_file_model.dart';

abstract class FileRemoteDataSource {
  /// Uploads a file to the server
  Future<Result<UploadedFileModel>> uploadFile({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    ProgressCallback? onProgress,
  });

  /// Downloads a file from the server
  Future<Result<Uint8List>> downloadFile({
    required SystemType systemType,
    required bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    ProgressCallback? onProgress,
  });
}
