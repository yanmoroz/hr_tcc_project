import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/network/network_exception.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';

abstract class FileRemoteDataSource {
  /// Uploads a file to the server
  Future<Either<NetworkException, UploadedFileModel>> uploadFile({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    ProgressCallback? onProgress,
  });

  /// Downloads a file from the server
  Future<Either<NetworkException, Uint8List>> downloadFile({
    required SystemType systemType,
    required bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    ProgressCallback? onProgress,
  });
}
