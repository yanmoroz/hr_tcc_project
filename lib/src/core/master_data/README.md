# Core Master Data

Simplified, unified access to all master/reference data (dictionaries, lookups, etc.).

## Why This Exists

The legacy `shared/master_data/` infrastructure was over-engineered:
- **108 files** for 24 simple lookup types
- **23 trivial use cases** that just passed through to repositories
- Inconsistent caching
- Massive DI registration overhead

This new approach consolidates everything into **3 clean components**:
- `MasterDataRemoteDataSource` - Fetches from API, converts models to entities
- `MasterDataCache` - Caches domain entities (1-hour TTL)
- `MasterDataRepository` - Orchestrates cache + remote data source
- **~70% fewer files**, simpler maintenance, better separation of concerns

## Usage

### In BLoCs

```dart
class MyBloc extends Bloc<MyEvent, MyState> {
  final MasterDataRepository _masterData;

  MyBloc(this._masterData) : super(MyState.initial());

  Future<void> _onLoadDropdowns(event, emit) async {
    // Get offices
    final officesResult = await _masterData.getOffices();
    officesResult.fold(
      (error) => emit(MyState.error(error.toString())),
      (offices) => emit(MyState.loaded(offices: offices)),
    );

    // Get application forms
    final formsResult = await _masterData.getApplicationForms();
    // ...
  }
}
```

### In Dependency Injection

Already registered in `service_locator.dart`:

```dart
// Cache (singleton)
sl.registerLazySingleton<MasterDataCache>(() => MasterDataCache());

// Repository (singleton)
sl.registerLazySingleton<MasterDataRepository>(
  () => MasterDataRepository(sl(), sl()),
);
```

Inject into your BLoC:

```dart
// In BLoC constructor
MyBloc(sl<MasterDataRepository>())

// Or register BLoC in service_locator
sl.registerFactory<MyBloc>(() => MyBloc(sl()));
```

## Available Methods

### Core Dictionaries (Bundled Endpoint `/dictionaries`)

All fetched in a single API call and cached together:

- `getApplicationFormGroups()` → `List<ApplicationFormGroup>`
- `getApplicationForms()` → `List<ApplicationForm>`
- `getSystemStatusGroups()` → `List<SystemStatusGroup>`
- `getSystemStatuses()` → `List<SystemStatus>`
- `getTripPurposes()` → `List<TripPurpose>`
- `getTrainingTypes()` → `List<TrainingType>`
- `getTrainingForms()` → `List<TrainingForm>`
- `getTrainingMonths()` → `List<TrainingMonth>`
- `getAlpinaDigitalPrevAccesses()` → `List<AlpinaDigitalPrevAccess>`
- `getOffices()` → `List<Office>`

### Feature-Specific Dictionaries

**TODO:** These should be added to the repository or moved to their respective features:
- `KpDiscountCategory` → should move to `features/discounts/`
- `KpDiscountSource` → should move to `features/discounts/`
- `KpNewsCategory` → should move to `features/news/`
- Other feature-specific types

## Caching

- **Automatic caching** with 1-hour TTL
- **Entity-based caching** - caches domain entities, not data models (maintains layer separation)
- **Single fetch** for all core dictionaries (bundled endpoint fetches all at once)
- **Individual cache checks** - each dictionary type is cached separately
- Call `clearCache()` to force refresh:

```dart
masterDataRepository.clearCache();
```

### How Caching Works

1. **First call** to any dictionary method (e.g., `getOffices()`) triggers a fetch of ALL core dictionaries
2. **Models are converted to entities** and each type is cached separately
3. **Subsequent calls** to any dictionary method return from cache (no API call)
4. **Cache expires** after 1 hour, then next call fetches fresh data
5. **Layer separation** is maintained - cache layer only knows about domain entities, not data models

## Migration from Legacy

If you're updating a feature that uses the old `shared/master_data/` approach:

### Before (Old)

```dart
class MyBloc {
  final GetOfficesUsecase _getOfficesUsecase;
  final GetApplicationFormsUsecase _getFormsUsecase;

  // Multiple use case injections
  MyBloc(this._getOfficesUsecase, this._getFormsUsecase);

  Future<void> load() async {
    final offices = await _getOfficesUsecase();
    final forms = await _getFormsUsecase();
  }
}
```

### After (New)

```dart
class MyBloc {
  final MasterDataRepository _masterData;

  // Single repository injection
  MyBloc(this._masterData);

  Future<void> load() async {
    final offices = await _masterData.getOffices();
    final forms = await _masterData.getApplicationForms();
  }
}
```

**Benefits:**
- Fewer dependencies to inject
- No trivial use case layer
- Automatic caching
- Simpler to understand and maintain

## Architecture

### 3-Component Design

```
┌─────────────────────────────────────────────────────────────┐
│                  MasterDataRepository                        │
│  (Orchestrates cache + remote data source)                  │
│                                                              │
│  • Checks cache first                                       │
│  • Fetches from remote on cache miss                        │
│  • Returns Result<List<Entity>>                             │
└──────────────┬─────────────────────────────┬────────────────┘
               │                             │
       ┌───────▼──────────┐         ┌────────▼──────────────┐
       │ MasterDataCache  │         │ MasterDataRemoteData  │
       │                  │         │ Source                │
       │ • Entity-based   │         │                       │
       │ • 1-hour TTL     │         │ • Wraps legacy API    │
       │ • Per-type cache │         │ • Converts models     │
       └──────────────────┘         │   to entities         │
                                    └───────────────────────┘
```

### Component Responsibilities

**MasterDataRemoteDataSource:**
- Wraps legacy `CoreDictionariesRemoteDataSource`
- Fetches from API
- Converts models to domain entities using `toDomain()`
- Returns `Result<CoreDictionaries>` (all types bundled)

**MasterDataCache:**
- Stores domain entities (NOT models)
- Separate cache per entity type
- 1-hour TTL per cache
- Maintains layer separation (cache doesn't know about data models)

**MasterDataRepository:**
- Orchestrates cache + remote data source
- Simple logic: check cache → fetch if miss → cache result
- Returns `Result<List<Entity>>` for each dictionary type
- Clean, focused responsibility

## Implementation Details

- **Reuses Legacy Infrastructure:** `CoreDictionariesRemoteDataSource` from `shared/master_data/`
- **Models:** Existing models with `toDomain()` extensions (no changes)
- **Entities:** Existing domain entities (no changes)
- **Layer Separation:**
  - Cache works with entities (domain layer)
  - Remote data source handles model conversion (data layer)
  - Repository orchestrates (doesn't know about models)
- **Backwards Compatible:** Old `shared/master_data/` still works during migration

## Future Work

1. Add feature-specific dictionary methods (or move to features)
2. Migrate all features to use this approach
3. Remove legacy `shared/master_data/` infrastructure
4. Consider moving truly shared entities to `core/domain/entities/`
