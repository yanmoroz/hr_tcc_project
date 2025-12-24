import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

import '../../../logging/app_logger.dart';
import '../../../value_objects/system_type.dart';
import '../../../value_objects/tcc_image_destination_type.dart';
import 'file_local_data_source.dart';

/// Implementation of [FileLocalDataSource] using disk-based caching.
///
/// Files are stored in the app's temporary directory with a 24-hour TTL.
/// Each cached file has an associated metadata file storing the cache timestamp.
class FileLocalDataSourceImpl implements FileLocalDataSource {
  static const Duration _cacheTtl = Duration(hours: 24);
  static const String _cachePrefix = 'file_cache_';
  static const String _metaSuffix = '_meta';

  @override
  Future<Uint8List?> getCached(String cacheKey) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFile = File('${cacheDir.path}/$_cachePrefix$cacheKey');
      final metadataFile = File(
        '${cacheDir.path}/$_cachePrefix$cacheKey$_metaSuffix',
      );

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
        await _deleteCacheFiles(cacheKey);
        return null;
      }

      // Cache is valid, return data
      final data = await cacheFile.readAsBytes();
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

  @override
  Future<void> cache(String cacheKey, Uint8List data) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFile = File('${cacheDir.path}/$_cachePrefix$cacheKey');
      final metadataFile = File(
        '${cacheDir.path}/$_cachePrefix$cacheKey$_metaSuffix',
      );

      // Save file data
      await cacheFile.writeAsBytes(data);

      // Save metadata with timestamp
      final metadata = {
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
        'size': data.length,
      };
      await metadataFile.writeAsString(jsonEncode(metadata));
    } catch (e, stackTrace) {
      AppLogger.e('Error saving to cache', e, stackTrace);
    }
  }

  @override
  String generateCacheKey({
    required SystemType systemType,
    required bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    TccImageDestinationType? imageDestination,
    String? destinationId,
  }) {
    final identifier = idFile ?? uriFile ?? urlFile ?? destinationId ?? '';
    final imageDestStr = imageDestination?.value ?? '';
    final input =
        '${systemType.value}_${download ? 'dl' : 'view'}_$identifier\_$imageDestStr';
    final bytes = utf8.encode(input);
    final hash = md5.convert(bytes);
    return hash.toString();
  }

  @override
  Future<void> cleanupExpired() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final files = await cacheDir.list().toList();
      int deletedCount = 0;
      int bytesFreed = 0;

      for (final entity in files) {
        if (entity is File && entity.path.contains(_cachePrefix)) {
          final fileName = entity.path.split('/').last;

          // Skip metadata files, we'll check them when processing data files
          if (fileName.endsWith(_metaSuffix)) continue;

          // Extract cache key from file name
          final cacheKey = fileName.replaceFirst(_cachePrefix, '');
          final metadataFile = File(
            '${cacheDir.path}/$_cachePrefix$cacheKey$_metaSuffix',
          );

          bool shouldDelete = false;

          // Delete if metadata is missing
          if (!await metadataFile.exists()) {
            shouldDelete = true;
          } else {
            try {
              // Check if cache is expired
              final metadataJson = await metadataFile.readAsString();
              final metadata =
                  jsonDecode(metadataJson) as Map<String, dynamic>;
              final cachedAtMs = metadata['cachedAt'] as int?;

              if (cachedAtMs == null) {
                shouldDelete = true;
              } else {
                final cachedAt = DateTime.fromMillisecondsSinceEpoch(
                  cachedAtMs,
                );
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

  @override
  Future<void> clearAll() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final files = await cacheDir.list().toList();
      int deletedCount = 0;

      for (final entity in files) {
        if (entity is File && entity.path.contains(_cachePrefix)) {
          await entity.delete();
          deletedCount++;
        }
      }

      if (deletedCount > 0) {
        AppLogger.d('Cleared $deletedCount cache files');
      }
    } catch (e, stackTrace) {
      AppLogger.e('Error clearing cache', e, stackTrace);
    }
  }

  Future<void> _deleteCacheFiles(String cacheKey) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFile = File('${cacheDir.path}/$_cachePrefix$cacheKey');
      final metadataFile = File(
        '${cacheDir.path}/$_cachePrefix$cacheKey$_metaSuffix',
      );

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
}
