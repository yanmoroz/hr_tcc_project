import 'dart:typed_data';

import '../../../value_objects/system_type.dart';
import '../../../value_objects/tcc_image_destination_type.dart';

/// Local data source for file caching operations.
///
/// Provides disk-based caching with TTL expiration for downloaded files.
abstract class FileLocalDataSource {
  /// Gets cached file bytes if valid (not expired).
  ///
  /// Returns null if cache doesn't exist or is expired.
  Future<Uint8List?> getCached(String cacheKey);

  /// Saves file bytes to cache with metadata.
  Future<void> cache(String cacheKey, Uint8List data);

  /// Generates a cache key from file identifiers.
  String generateCacheKey({
    required SystemType systemType,
    required bool download,
    String? idFile,
    String? uriFile,
    String? urlFile,
    TccImageDestinationType? imageDestination,
    String? destinationId,
  });

  /// Removes expired cache entries.
  Future<void> cleanupExpired();

  /// Clears all cached files.
  Future<void> clearAll();
}
