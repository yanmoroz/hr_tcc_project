# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter HR/TCC application built with **Clean Architecture** principles, featuring resell marketplace, news, discounts, polls, applications, and notification systems.

## Common Commands

### Development
```bash
# Get dependencies
flutter pub get

# Run code generation (Freezed + JSON Serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous code generation
flutter pub run build_runner watch --delete-conflicting-outputs

# Run the app
flutter run

# Run with specific device
flutter run -d <device-id>
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/src/features/resell/data/datasources/resell_remote_data_source_test.dart

# Run tests with coverage
flutter test --coverage
```

### Code Quality
```bash
# Run linter
flutter analyze

# Format code
flutter format lib test
```

## Architecture

This project follows **Clean Architecture** with strict layer separation:

```
lib/src/
├── core/          # Shared infrastructure (networking, DI, error handling)
├── features/      # Feature modules (resell, news, discounts, polls, etc.)
└── shared/        # Reusable cross-feature modules (comments, files, master_data)
```

### Feature Structure

Each feature follows a **3-layer architecture**:

```
features/<feature_name>/
├── data/                        # Data layer
│   ├── datasources/            # API clients (interfaces + implementations)
│   ├── models/                 # DTOs with JSON serialization (Freezed + json_serializable)
│   ├── repositories/           # Repository implementations
│   └── data.dart               # Barrel export
├── domain/                      # Business logic layer
│   ├── entities/               # Pure business objects (Freezed)
│   ├── repositories/           # Repository interfaces
│   ├── usecases/               # Business operations
│   ├── value_objects/          # Domain value objects (enums, sealed classes)
│   └── domain.dart             # Barrel export
└── presentation/                # UI layer
    ├── bloc/                   # State management
    │   ├── <page_name>/        # BLoCs organized by page
    │   │   ├── *_bloc.dart
    │   │   ├── *_event.dart    # Freezed sealed unions
    │   │   └── *_state.dart    # Freezed sealed unions
    ├── pages/                  # Screen widgets
    ├── widgets/                # Feature-specific widgets
    └── presentation.dart       # Barrel export
```

**Dependency Rule:** Domain → Data → Presentation (domain has NO dependencies on other layers)

### Data Flow

```
API → DataSource → Repository → UseCase → BLoC → UI
       (Model)    (Model→Entity) (Entity)  (State) (Widget)
```

**Error Handling Pattern:**
- All async operations return `Result<T>` (type alias for `Either<Exception, T>` from fpdart)
- `ApiCallExecutor.executeApiCall()` wraps all network calls and returns `Either<Exception, T>`
- BLoCs use `.fold()` to handle success/error cases
- Error types: `NetworkException`, `MappingException`

Example:
```dart
// Data Source
Future<Result<ResellListResponseModel>> getResellItems(...) async {
  return ApiCallExecutor.executeApiCall(
    apiCall: () => _apiClient.get(endpoint, queryParameters: {...}),
    successParser: (response) => ResellListResponseModel.fromJson(response.data),
  );
}

// Repository (Model → Entity conversion)
Future<Result<List<ResellItem>>> getResellItems(...) async {
  final result = await _remoteDataSource.getResellItems(...);
  return result.map((response) =>
    response.items.map((model) => model.toDomain()).toList()
  );
}

// BLoC
final result = await _usecase(...);
result.fold(
  (error) => emit(State.error(error.toString())),
  (data) => emit(State.loaded(data: data)),
);
```

### State Management

**BLoC Pattern (flutter_bloc):**
- Events and States are Freezed sealed unions
- BLoCs created via `BlocFactory` (in `core/di/bloc_factory.dart`)
- BLoCs provided per-route using `BlocProvider` in `main.dart`
- Initial events dispatched immediately: `..add(const Event.load())`

**Pagination Pattern:**
- State tracks: `currentPage`, `hasMorePages`, `isLoadingMore`
- Events: `load()`, `loadMore()`, `refresh()`

### Dependency Injection

**GetIt Service Locator** (`core/di/service_locator.dart`):

```dart
// Registration pattern
sl.registerLazySingleton<DataSource>(() => DataSourceImpl(sl()));  // Singletons
sl.registerLazySingleton<Repository>(() => RepositoryImpl(sl()));  // Singletons
sl.registerFactory<UseCase>(() => UseCase(sl()));                 // New instance each time

// Named instances for feature-specific shared services
sl.registerFactory<CommentsBloc>(
  () => CommentsBloc(sl(), sl()),
  instanceName: 'newsComments',
);
```

**When adding new features:**
1. Create `_initialize<Feature>Dependencies()` function in `service_locator.dart`
2. Register data sources (lazy singleton), repositories (lazy singleton), use cases (factory)
3. Optionally register BLoCs (factory) in `bloc_factory.dart`

### Code Generation

Uses **Freezed** + **json_serializable**:

```dart
// Entity (domain)
@freezed
class ResellItem with _$ResellItem {
  const factory ResellItem({
    required String id,
    required int price,
  }) = _ResellItem;
}

// Model (data) - includes JSON + domain conversion
@freezed
class ResellItemModel with _$ResellItemModel {
  const ResellItemModel._();  // Private constructor for methods

  const factory ResellItemModel({
    required String id,
    required int price,
  }) = _ResellItemModel;

  factory ResellItemModel.fromJson(Map<String, dynamic> json) =>
    _$ResellItemModelFromJson(json);

  // Conversion to domain entity
  ResellItem toDomain() => ResellItem(id: id, price: price);
}
```

**After creating/modifying Freezed classes, run:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Core Infrastructure

**Networking (`core/network/`):**
- `ApiClient` - Dio-based HTTP client with auth interceptors
  - `SecureApiClient` - Production (enforces SSL)
  - `InsecureApiClient` - Development (bypasses SSL, controlled via `.env`)
- `ApiCallExecutor` - Centralized error handling wrapper
- `ApiConstants` - Endpoint definitions

**Authentication:**
- `AuthTokenProvider` - Manages auth tokens (from `.env`)
- Token automatically injected via Dio interceptor

**Shared Services (`shared/`):**
- `comments/` - Full comment system (CRUD + likes)
- `files/` - File upload/download

**Master Data / Reference Data:**

**NEW APPROACH (Recommended):**
- **Location:** `core/master_data/`
- **Access Pattern:** Direct repository injection (no use cases)
- **Single Repository:** `MasterDataRepository` - unified access to all dictionaries
- **Built-in Caching:** `MasterDataCache` with 1-hour TTL
- **Usage:**
  ```dart
  // In BLoC or elsewhere
  class MyBloc {
    final MasterDataRepository _masterData;

    MyBloc(this._masterData);

    Future<void> loadDropdowns() async {
      final officesResult = await _masterData.getOffices();
      final formsResult = await _masterData.getApplicationForms();
      // ... handle results
    }
  }

  // In service_locator.dart - already registered as singleton
  sl<MasterDataRepository>()
  ```

**OLD APPROACH (Legacy - Being Phased Out):**
- **Location:** `shared/master_data/`
- **Pattern:** Full Clean Architecture with repositories, use cases, data sources
- **Problem:** Over-engineered (108 files for 24 simple lookup types)
- **Migration:** Gradually moving features to use core `MasterDataRepository` instead

**Available Master Data Types:**
- `ApplicationForm`, `ApplicationFormGroup` - Application form types
- `Office` - Office locations
- `SystemStatus`, `SystemStatusGroup` - System-wide statuses
- `TripPurpose` - Business trip purposes
- `TrainingType`, `TrainingForm`, `TrainingMonth` - Training-related
- `AlpinaDigitalPrevAccess` - Digital access privileges

**Environment Configuration:**
- `.env` file (not in git) - contains `API_BASE_URL`, `AUTH_TOKEN`, `USE_INSECURE_HTTP`
- Loaded via `flutter_dotenv` in `main.dart`

### Routing

Simple **MaterialApp routing** (in `main.dart`):
- Routes defined in `routes` map
- BLoCs created and provided per-route
- Route arguments passed via `ModalRoute.of(context)!.settings.arguments`

Example:
```dart
'/resell-detail': (context) {
  final args = ModalRoute.of(context)!.settings.arguments as int;  // resellId
  return BlocProvider(
    create: (context) => BlocFactory.createResellDetailBloc(args)
      ..add(const ResellDetailEvent.load()),
    child: ResellDetailPage(resellId: args),
  );
},
```

### Naming Conventions

**Files:**
- `*_model.dart` - Data layer DTOs
- `*.dart` (entities) - Domain entities
- `*_usecase.dart` - Use cases
- `*_bloc.dart`, `*_event.dart`, `*_state.dart` - BLoC components
- `*_page.dart` - Full screen widgets
- `*_remote_data_source.dart` - API interfaces
- `*_remote_data_source_impl.dart` - API implementations
- `*_repository.dart` - Repository interfaces
- `*_repository_impl.dart` - Repository implementations

**Classes:**
- Entities: Descriptive names (`ResellItem`, `NewsArticle`)
- Models: Entity name + `Model` suffix
- Use cases: Action + `Usecase` suffix (`GetResellItemsUsecase`)
- BLoCs: Feature + `Bloc` suffix (`ResellItemsBloc`)

**Generated Files (ignored by git/linter):**
- `*.freezed.dart` - Freezed generated code
- `*.g.dart` - json_serializable generated code

### Testing

**Test Structure:**
- Mirrors `lib/` structure
- Currently focuses on data source layer tests
- Uses standard Flutter test package

**Running Specific Tests:**
```bash
# Test a specific feature's data source
flutter test test/src/features/resell/data/datasources/resell_remote_data_source_test.dart

# Test all data sources
flutter test test/src/features/*/data/datasources/
```

## Key Implementation Patterns

### Adding a New Feature

1. **Create folder structure:**
   ```
   lib/src/features/<feature>/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   └── presentation/
       ├── bloc/
       ├── pages/
       └── widgets/
   ```

2. **Domain layer (start here):**
   - Define entities (`@freezed` classes)
   - Create repository interface
   - Implement use cases

3. **Data layer:**
   - Create models (`@freezed` with `fromJson` and `toDomain()`)
   - Implement data source (interface + implementation)
   - Implement repository (model → entity conversion)

4. **Presentation layer:**
   - Create BLoC (events, states, bloc)
   - Build page widgets
   - Wire up BLoC in `main.dart` routes

5. **Dependency Injection:**
   - Register in `service_locator.dart`:
     ```dart
     // Data sources & repositories (lazy singletons)
     sl.registerLazySingleton<FeatureDataSource>(() => FeatureDataSourceImpl(sl()));
     sl.registerLazySingleton<FeatureRepository>(() => FeatureRepositoryImpl(sl()));

     // Use cases (factories)
     sl.registerFactory<GetFeatureUsecase>(() => GetFeatureUsecase(sl()));
     ```
   - Optionally add BLoC factory in `bloc_factory.dart`

6. **Run code generation:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Model-Entity Conversion Pattern

Always implement `toDomain()` in models:

```dart
@freezed
class ResellItemModel with _$ResellItemModel {
  const ResellItemModel._();  // Required for methods

  const factory ResellItemModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'price') required int price,
    @JsonKey(name: 'equipment_type') required ResellEquipmentTypeModel equipmentType,
  }) = _ResellItemModel;

  factory ResellItemModel.fromJson(Map<String, dynamic> json) =>
    _$ResellItemModelFromJson(json);

  ResellItem toDomain() => ResellItem(
    id: id,
    price: price,
    equipmentType: equipmentType.toDomain(),  // Nested conversion
  );
}
```

### Shared Services Usage

For features that need comments (news, discounts):

1. **Register named instance in `service_locator.dart`:**
   ```dart
   sl.registerFactory<CommentsBloc>(
     () => CommentsBloc(sl(), sl()),
     instanceName: 'newsComments',
   );
   ```

2. **Use in BLoC factory:**
   ```dart
   static CommentsBloc createCommentsBloc({required String feature, required int entityId}) {
     return sl<CommentsBloc>(instanceName: '${feature}Comments');
   }
   ```

3. **Navigate to comments page:**
   ```dart
   Navigator.pushNamed(
     context,
     '/comments',
     arguments: {'entityId': newsId, 'feature': 'news'},
   );
   ```

### Master Data Migration Guide

**Context:** The legacy `shared/master_data/` was over-engineered (108 files for 24 lookup types). The new `core/master_data/` approach simplifies this.

**When adding new features:**
1. **Use `MasterDataRepository` directly** - inject it into your BLoC/use case
2. **No need for use cases** - master data has no business logic
3. **Caching is automatic** - built into the repository

**When refactoring existing features:**
1. Remove use case injection (e.g., `GetKpDiscountCategoriesUsecase`)
2. Inject `MasterDataRepository` instead
3. Call repository methods directly: `_masterData.getOffices()`
4. Keep using the same entities (they haven't changed)

**Example Migration:**

Before (old):
```dart
class MyBloc {
  final GetApplicationFormsUsecase _getFormsUsecase;
  final GetOfficesUsecase _getOfficesUsecase;

  MyBloc(this._getFormsUsecase, this._getOfficesUsecase);

  // Load dropdowns via use cases
  Future<void> load() async {
    final forms = await _getFormsUsecase();
    final offices = await _getOfficesUsecase();
  }
}
```

After (new):
```dart
class MyBloc {
  final MasterDataRepository _masterData;

  MyBloc(this._masterData);  // Single dependency!

  // Load dropdowns directly from repository
  Future<void> load() async {
    final forms = await _masterData.getApplicationForms();
    final offices = await _masterData.getOffices();
  }
}
```

**Note:** For now, both approaches work (backwards compatible). The old infrastructure will be removed once all features migrate.

## Important Notes

- **Never commit `.env` file** - contains sensitive API credentials
- **Run code generation after modifying Freezed classes** - use watch mode during active development
- **Domain layer is pure** - no dependencies on Flutter, Dio, or other frameworks
- **All BLoCs must be provided via `BlocProvider`** - typically in route definitions
- **Use `ApiCallExecutor`** for all API calls - ensures consistent error handling
- **Image caching in BLoCs** - many features cache images in state (`Map<int, Uint8List>`)
- **Linter ignores** - `constant_identifier_names` ignored for API constants, `invalid_annotation_target` for Freezed
- **Master Data:** Use new `core/master_data/MasterDataRepository` for all dictionary/reference data

## Environment Setup

Create `.env` file in project root:
```
API_BASE_URL=https://your-api-url.com
AUTH_TOKEN=your-auth-token
USE_INSECURE_HTTP=false  # Set to 'true' for development (bypasses SSL)
```

## Code Style

- Use Freezed for all data classes (entities, models, events, states)
- Use `const` constructors where possible
- Prefer composition over inheritance
- Use functional error handling (`Either<Exception, T>`)
- Follow feature-based folder structure
- Use barrel exports (`data.dart`, `domain.dart`, `presentation.dart`)
