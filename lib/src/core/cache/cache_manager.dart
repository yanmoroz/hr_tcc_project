class CacheManager<T> {
  T? _cachedData;
  DateTime? _cacheTimestamp;
  final Duration _cacheDuration;

  CacheManager({Duration cacheDuration = const Duration(hours: 1)})
    : _cacheDuration = cacheDuration;

  Duration? get age {
    if (_cacheTimestamp == null) return null;
    return DateTime.now().difference(_cacheTimestamp!);
  }

  DateTime? get expiresAt {
    if (_cacheTimestamp == null) return null;
    return _cacheTimestamp!.add(_cacheDuration);
  }

  bool get hasData => _cachedData != null;

  bool get _isValid {
    if (_cachedData == null || _cacheTimestamp == null) {
      return false;
    }
    return DateTime.now().difference(_cacheTimestamp!) < _cacheDuration;
  }

  void clear() {
    _cachedData = null;
    _cacheTimestamp = null;
  }

  T? get() {
    if (_isValid) {
      return _cachedData;
    }
    return null;
  }

  void set(T data) {
    _cachedData = data;
    _cacheTimestamp = DateTime.now();
  }
}
