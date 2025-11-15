/// Generic cache manager with TTL support
class CacheManager<T> {
  T? _cachedData;
  DateTime? _cacheTimestamp;
  final Duration _cacheDuration;

  CacheManager({Duration cacheDuration = const Duration(hours: 1)})
    : _cacheDuration = cacheDuration;

  /// Gets cached data if valid, null otherwise
  T? get() {
    if (_isValid) {
      return _cachedData;
    }
    return null;
  }

  /// Sets data in cache with current timestamp
  void set(T data) {
    _cachedData = data;
    _cacheTimestamp = DateTime.now();
  }

  /// Clears the cache
  void clear() {
    _cachedData = null;
    _cacheTimestamp = null;
  }

  /// Checks if cache is valid (exists and not expired)
  bool get _isValid {
    if (_cachedData == null || _cacheTimestamp == null) {
      return false;
    }
    return DateTime.now().difference(_cacheTimestamp!) < _cacheDuration;
  }

  /// Checks if cache exists (regardless of expiration)
  bool get hasData => _cachedData != null;

  /// Gets the age of cached data
  Duration? get age {
    if (_cacheTimestamp == null) return null;
    return DateTime.now().difference(_cacheTimestamp!);
  }

  /// Gets cache expiry time
  DateTime? get expiresAt {
    if (_cacheTimestamp == null) return null;
    return _cacheTimestamp!.add(_cacheDuration);
  }
}
