import 'dart:typed_data';

import '../../shared/files/domain/domain.dart';
import '../base_types/result.dart';
import '../value_objects/system_type.dart';

class ImageCacheService {
  final FileRepository _fileRepository;

  final Map<String, Uint8List> _cache = {};
  final Map<String, Future<Uint8List?>> _pendingRequests = {};
  final Set<String> _failedKeys = {};

  ImageCacheService(this._fileRepository);

  /// Get image by file ID (for resell, elma system, etc.)
  Future<Uint8List?> getImageById({
    required String fileId,
    required SystemType systemType,
  }) async {
    return _getOrFetch(
      cacheKey: fileId,
      download: () => _fileRepository.downloadFile(
        systemType: systemType,
        download: false,
        idFile: fileId,
      ),
    );
  }

  /// Get image by URI (for news, kp system, etc.)
  Future<Uint8List?> getImageByUri({
    required String uri,
    required SystemType systemType,
  }) async {
    return _getOrFetch(
      cacheKey: uri,
      download: () => _fileRepository.downloadFile(
        systemType: systemType,
        download: false,
        uriFile: uri,
      ),
    );
  }

  /// Get cached image if available (synchronous)
  Uint8List? getCached(String cacheKey) => _cache[cacheKey];

  /// Clear all cached images
  void clearCache() {
    _cache.clear();
    _pendingRequests.clear();
    _failedKeys.clear();
  }

  Future<Uint8List?> _getOrFetch({
    required String cacheKey,
    required Future<Result<Uint8List>> Function() download,
  }) async {
    // Return cached image
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey];

    // Skip if previously failed
    if (_failedKeys.contains(cacheKey)) return null;

    // Wait for pending request
    if (_pendingRequests.containsKey(cacheKey)) {
      return _pendingRequests[cacheKey];
    }

    // Create new request
    final future = _fetchImage(cacheKey, download);
    _pendingRequests[cacheKey] = future;

    final result = await future;
    _pendingRequests.remove(cacheKey);

    return result;
  }

  Future<Uint8List?> _fetchImage(
    String cacheKey,
    Future<Result<Uint8List>> Function() download,
  ) async {
    final result = await download();

    return result.fold(
      (error) {
        _failedKeys.add(cacheKey);
        return null;
      },
      (imageBytes) {
        _cache[cacheKey] = imageBytes;
        return imageBytes;
      },
    );
  }
}
