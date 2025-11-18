import '../cache/cache_manager.dart';

class DictionariesCache {
  final Map<Type, CacheManager> _caches = {};

  DictionariesCache({Duration cacheDuration = const Duration(hours: 1)});

  T? get<T>() => _caches[T]?.get() as T?;

  void set<T>(T data) => (_caches[T] ??= CacheManager()).set(data);

  void clearAll() {
    _caches.clear();
  }
}
