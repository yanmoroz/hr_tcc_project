# Cache Manager

Generic caching layer with TTL (Time-To-Live) support.

## Features

- ✅ Generic type support (`CacheManager<T>`)
- ✅ Configurable TTL (default: 1 hour)
- ✅ Automatic expiration
- ✅ Manual cache clearing
- ✅ Cache age/expiry information
- ✅ Null-safe

## Basic Usage

```dart
// Create cache with default 1-hour TTL
final cache = CacheManager<String>();

// Set data
cache.set('Hello, World!');

// Get data (returns null if expired)
final data = cache.get(); // 'Hello, World!'

// Clear cache
cache.clear();
```

## Custom TTL

```dart
// 5-minute cache
final shortCache = CacheManager<MyData>(
  cacheDuration: Duration(minutes: 5),
);

// 24-hour cache
final longCache = CacheManager<MyData>(
  cacheDuration: Duration(hours: 24),
);
```

## Repository Integration

### Example: Using with CoreDictionariesRepository

```dart
class CoreDictionariesRepositoryImpl implements CoreDictionariesRepository {
  final CoreDictionariesRemoteDataSource _remoteDataSource;
  final CacheManager<CoreDictionariesResponse> _cache;

  CoreDictionariesRepositoryImpl(
    this._remoteDataSource, {
    CacheManager<CoreDictionariesResponse>? cache,
  }) : _cache = cache ?? CacheManager(cacheDuration: Duration(hours: 1));

  Future<Result<CoreDictionariesResponse>> _getResponse() async {
    // Try cache first
    final cached = _cache.get();
    if (cached != null) {
      return Right(cached);
    }

    // Fetch from remote
    final result = await _remoteDataSource.getCoreDictionaries();

    // Cache successful results
    result.fold(
      (failure) => null,
      (response) => _cache.set(response),
    );

    return result;
  }

  // Public method to force refresh
  void clearCache() => _cache.clear();
}
```

## Cache Information

```dart
final cache = CacheManager<String>();
cache.set('data');

// Check if has data
if (cache.hasData) {
  print('Cache contains data');
}

// Get cache age
final age = cache.age; // Duration(seconds: 30)

// Get expiry time
final expiresAt = cache.expiresAt; // DateTime
```

## Testing

Inject custom cache for testing:

```dart
// In tests
final mockCache = CacheManager<MyData>(
  cacheDuration: Duration(seconds: 1), // Short TTL for tests
);

final repository = MyRepositoryImpl(
  dataSource,
  cache: mockCache,
);

// Test cache behavior
mockCache.set(testData);
// ... assertions
```

## Benefits Over In-Repository Caching

1. **Separation of Concerns** - Caching logic is separate from business logic
2. **Reusability** - Same `CacheManager` can be used across repositories
3. **Testability** - Easy to inject mock caches
4. **Configurability** - TTL configurable per use case
5. **Maintainability** - Single place to update caching logic
