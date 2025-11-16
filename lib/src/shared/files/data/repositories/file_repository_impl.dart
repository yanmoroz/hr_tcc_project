import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/base_types/result.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/base_types/base_repository.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/value_objects/system_type.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/data_sources.dart';
import '../models/uploaded_file_model.dart';

class FileRepositoryImpl with BaseRepository implements FileRepository {
  final FileRemoteDataSource _remoteDataSource;

  FileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<UploadedFile>> uploadFile({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    ProgressCallback? onProgress,
  }) async {
    final result = await _remoteDataSource.uploadFile(
      file: file,
      systemType: systemType,
      group: group,
      issueIdOrKey: issueIdOrKey,
      onProgress: onProgress,
    );

    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<Uint8List>> downloadFile({
    required SystemType systemType,
    required bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    ProgressCallback? onProgress,
  }) async {
    // Generate cache key based on file identifiers
    final cacheKey = _generateCacheKey(systemType, idFile, uriFile, urlFile);

    // Try to load from cache first
    final cachedData = await _loadFromCache(cacheKey);
    if (cachedData != null) {
      AppLogger.d('File loaded from cache: $cacheKey');
      return Right(cachedData);
    }

    // Download from remote if not in cache
    final result = await _remoteDataSource.downloadFile(
      systemType: systemType,
      download: download,
      idFile: idFile,
      uriFile: uriFile,
      urlFile: urlFile,
      onProgress: onProgress,
    );

    // Save to cache if download was successful and has content
    result.fold(
      (error) {
        // Don't cache errors
      },
      (data) async {
        if (data.isNotEmpty) {
          await _saveToCache(cacheKey, data);
        }
      },
    );

    return result;
  }

  /// Generate a unique cache key based on system type and file identifiers
  String _generateCacheKey(
    SystemType systemType,
    String? idFile,
    String? uriFile,
    String? urlFile,
  ) {
    final identifier = idFile ?? uriFile ?? urlFile ?? '';
    final input = '${systemType.value}_$identifier';
    final bytes = utf8.encode(input);
    final hash = md5.convert(bytes);
    return hash.toString();
  }

  /// Load file data from cache
  Future<Uint8List?> _loadFromCache(String cacheKey) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFile = File('${cacheDir.path}/file_cache_$cacheKey');

      if (await cacheFile.exists()) {
        return await cacheFile.readAsBytes();
      }
    } catch (e, stackTrace) {
      AppLogger.e('Error loading from cache', e, stackTrace);
    }
    return null;
  }

  /// Save file data to cache
  Future<void> _saveToCache(String cacheKey, Uint8List data) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFile = File('${cacheDir.path}/file_cache_$cacheKey');
      await cacheFile.writeAsBytes(data);
      AppLogger.d('File saved to cache: $cacheKey (${data.length} bytes)');
    } catch (e, stackTrace) {
      AppLogger.e('Error saving to cache', e, stackTrace);
    }
  }
}
