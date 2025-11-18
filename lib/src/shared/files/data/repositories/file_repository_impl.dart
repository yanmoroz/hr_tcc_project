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
import '../../../../core/value_objects/tcc_image_destination_type.dart';
import '../../domain/domain.dart';
import '../datasources/file_remote_data_source.dart';
import '../models/uploaded_file_model.dart';

class FileRepositoryImpl with BaseRepository implements FileRepository {
  final FileRemoteDataSource _remoteDataSource;

  /// Cache TTL duration - files older than this will be re-downloaded
  static const Duration _cacheTtl = Duration(hours: 24);

  FileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<UploadedFile>> uploadFile({
    required File file,
    required SystemType systemType,
    FileGroup? group,
    String? issueIdOrKey,
    TccImageDestinationType? imageDestination,
    String? destinationId,
    ProgressCallback? onProgress,
  }) async {
    final result = await _remoteDataSource.uploadFile(
      file: file,
      systemType: systemType,
      group: group,
      issueIdOrKey: issueIdOrKey,
      imageDestination: imageDestination,
      destinationId: destinationId,
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
    TccImageDestinationType? imageDestination,
    String? destinationId,
    ProgressCallback? onProgress,
  }) async {
    // Generate cache key based on file identifiers
    final cacheKey = _generateCacheKey(
      systemType,
      download,
      idFile,
      uriFile,
      urlFile,
      imageDestination,
      destinationId,
    );

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
      imageDestination: imageDestination,
      destinationId: destinationId,
      onProgress: onProgress,
    );

    // Save to cache if download was successful and has content
    await result.fold(
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
    bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    TccImageDestinationType? imageDestination,
    String? destinationId,
  ) {
    final identifier = idFile ?? uriFile ?? urlFile ?? destinationId ?? '';
    final imageDestStr = imageDestination?.value ?? '';
    final input = '${systemType.value}_${download ? 'dl' : 'view'}_$identifier\_$imageDestStr';
    final bytes = utf8.encode(input);
    final hash = md5.convert(bytes);
    return hash.toString();
  }

  /// Load file data from cache
  /// Returns null if file doesn't exist, is expired, or has invalid metadata
  Future<Uint8List?> _loadFromCache(String cacheKey) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFile = File('${cacheDir.path}/file_cache_$cacheKey');
      final metadataFile = File('${cacheDir.path}/file_cache_${cacheKey}_meta');

      // Check if both cache and metadata files exist
      if (!await cacheFile.exists() || !await metadataFile.exists()) {
        return null;
      }

      // Read and validate metadata
      final metadataJson = await metadataFile.readAsString();
      final metadata = jsonDecode(metadataJson) as Map<String, dynamic>;
      final cachedAtMs = metadata['cachedAt'] as int?;

      if (cachedAtMs == null) {
        AppLogger.w('Invalid cache metadata for $cacheKey, removing');
        await _deleteCacheFiles(cacheKey);
        return null;
      }

      final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedAtMs);
      final age = DateTime.now().difference(cachedAt);

      // Check if cache is expired
      if (age > _cacheTtl) {
        AppLogger.d('Cache expired for $cacheKey (age: ${age.inHours}h)');
        await _deleteCacheFiles(cacheKey);
        return null;
      }

      // Cache is valid, return data
      final data = await cacheFile.readAsBytes();
      AppLogger.d(
        'Cache hit for $cacheKey (age: ${age.inMinutes}m, size: ${data.length} bytes)',
      );
      return data;
    } catch (e, stackTrace) {
      AppLogger.e('Error loading from cache', e, stackTrace);
      // Try to clean up potentially corrupted cache
      try {
        await _deleteCacheFiles(cacheKey);
      } catch (_) {
        // Ignore cleanup errors
      }
    }
    return null;
  }

  /// Save file data to cache with metadata
  Future<void> _saveToCache(String cacheKey, Uint8List data) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFile = File('${cacheDir.path}/file_cache_$cacheKey');
      final metadataFile = File('${cacheDir.path}/file_cache_${cacheKey}_meta');

      // Save file data
      await cacheFile.writeAsBytes(data);

      // Save metadata with timestamp
      final metadata = {
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
        'size': data.length,
      };
      await metadataFile.writeAsString(jsonEncode(metadata));

      AppLogger.d('File saved to cache: $cacheKey (${data.length} bytes)');
    } catch (e, stackTrace) {
      AppLogger.e('Error saving to cache', e, stackTrace);
    }
  }

  /// Delete cache files (data and metadata) for a given cache key
  Future<void> _deleteCacheFiles(String cacheKey) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFile = File('${cacheDir.path}/file_cache_$cacheKey');
      final metadataFile = File('${cacheDir.path}/file_cache_${cacheKey}_meta');

      if (await cacheFile.exists()) {
        await cacheFile.delete();
      }
      if (await metadataFile.exists()) {
        await metadataFile.delete();
      }
    } catch (e, stackTrace) {
      AppLogger.e('Error deleting cache files for $cacheKey', e, stackTrace);
    }
  }

  /// Clean up expired cache files
  /// This can be called periodically to free up storage
  Future<void> cleanupExpiredCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final files = await cacheDir.list().toList();
      int deletedCount = 0;
      int bytesFreed = 0;

      for (final entity in files) {
        if (entity is File && entity.path.contains('file_cache_')) {
          final fileName = entity.path.split('/').last;

          // Skip metadata files, we'll check them when processing data files
          if (fileName.endsWith('_meta')) continue;

          // Extract cache key from file name
          final cacheKey = fileName.replaceFirst('file_cache_', '');
          final metadataFile =
              File('${cacheDir.path}/file_cache_${cacheKey}_meta');

          bool shouldDelete = false;

          // Delete if metadata is missing
          if (!await metadataFile.exists()) {
            shouldDelete = true;
          } else {
            try {
              // Check if cache is expired
              final metadataJson = await metadataFile.readAsString();
              final metadata = jsonDecode(metadataJson) as Map<String, dynamic>;
              final cachedAtMs = metadata['cachedAt'] as int?;

              if (cachedAtMs == null) {
                shouldDelete = true;
              } else {
                final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedAtMs);
                final age = DateTime.now().difference(cachedAt);
                if (age > _cacheTtl) {
                  shouldDelete = true;
                }
              }
            } catch (e) {
              // Invalid metadata, delete the cache
              shouldDelete = true;
            }
          }

          if (shouldDelete) {
            final fileSize = await entity.length();
            await _deleteCacheFiles(cacheKey);
            deletedCount++;
            bytesFreed += fileSize;
          }
        }
      }

      if (deletedCount > 0) {
        AppLogger.d(
          'Cleaned up $deletedCount expired cache files (freed ${(bytesFreed / 1024).toStringAsFixed(2)} KB)',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.e('Error cleaning up expired cache', e, stackTrace);
    }
  }
}
