import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../../logging/app_logger.dart';

/// Use case for clearing the file download cache
class ClearFileCacheUsecase {
  /// Clears all cached files
  Future<void> call() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFiles = cacheDir.listSync().where((file) => file.path.contains('file_cache_'));

      int deletedCount = 0;
      for (final file in cacheFiles) {
        try {
          await file.delete();
          deletedCount++;
        } catch (e) {
          AppLogger.e('Error deleting cache file: ${file.path}', e);
        }
      }

      AppLogger.i('Cleared $deletedCount cached files');
    } catch (e, stackTrace) {
      AppLogger.e('Error clearing file cache', e, stackTrace);
      rethrow;
    }
  }

  /// Gets the total size of cached files in bytes
  Future<int> getCacheSize() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFiles = cacheDir.listSync().where((file) => file.path.contains('file_cache_'));

      int totalSize = 0;
      for (final file in cacheFiles) {
        if (file is File) {
          totalSize += await file.length();
        }
      }

      return totalSize;
    } catch (e, stackTrace) {
      AppLogger.e('Error calculating cache size', e, stackTrace);
      return 0;
    }
  }

  /// Gets the number of cached files
  Future<int> getCachedFileCount() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFiles = cacheDir.listSync().where((file) => file.path.contains('file_cache_'));
      return cacheFiles.length;
    } catch (e, stackTrace) {
      AppLogger.e('Error counting cached files', e, stackTrace);
      return 0;
    }
  }
}
