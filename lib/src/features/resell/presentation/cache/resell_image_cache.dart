import 'dart:typed_data';

import '../../../../core/value_objects/system_type.dart';
import '../../../../shared/files/domain/domain.dart';

class ResellImageCache {
  ResellImageCache._();
  static final ResellImageCache instance = ResellImageCache._();

  final Map<String, Uint8List> _cache = {};
  final Map<String, Future<Uint8List?>> _pendingRequests = {};
  final Set<String> _failedKeys = {};

  Future<Uint8List?> getOrFetch({
    required String itemId,
    required String? photoId,
    required DownloadFileUsecase downloadFileUsecase,
  }) async {
    if (photoId == null || photoId.isEmpty) return null;

    // Return cached image
    if (_cache.containsKey(itemId)) return _cache[itemId];

    // Skip if previously failed
    if (_failedKeys.contains(itemId)) return null;

    // Wait for pending request
    if (_pendingRequests.containsKey(itemId)) {
      return _pendingRequests[itemId];
    }

    // Create new request
    final future = _fetchImage(itemId, photoId, downloadFileUsecase);
    _pendingRequests[itemId] = future;

    final result = await future;
    _pendingRequests.remove(itemId);

    return result;
  }

  Future<Uint8List?> _fetchImage(
    String itemId,
    String photoId,
    DownloadFileUsecase downloadFileUsecase,
  ) async {
    final result = await downloadFileUsecase(
      systemType: SystemType.elma,
      download: false,
      idFile: photoId,
    );

    return result.fold(
      (error) {
        _failedKeys.add(itemId);
        return null;
      },
      (imageBytes) {
        _cache[itemId] = imageBytes;
        return imageBytes;
      },
    );
  }

  Uint8List? getCached(String itemId) => _cache[itemId];

  void clear() {
    _cache.clear();
    _pendingRequests.clear();
    _failedKeys.clear();
  }
}
