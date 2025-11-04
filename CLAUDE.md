# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter mobile application built for HR TCC (Talent & Culture Center) using Clean Architecture principles with strict layer separation and functional programming patterns.

## Implemented Features

### Discounts Feature (Complete)
Full presentation layer with Clean Architecture:
- **DiscountCategoriesPage**: Browse discount categories from master data with filtering
- **DiscountsPage**: Infinite scroll list with pagination, pull-to-refresh
- **DiscountDetailPage**: Full detail view with contact info, promo codes, optimistic like updates
- **CommentsPage**: Reusable comments module with add/delete/like functionality

Navigation flow: FeaturesPage → DiscountCategoriesPage → DiscountsPage → DiscountDetailPage → CommentsPage

BLoC implementation with:
- Pagination support for infinite scroll
- Optimistic UI updates with error reversion
- Pull-to-refresh on all pages
- Loading states and error handling with retry

### Other Features
- **Notifications**: View and manage notifications
- **Polls**: View and participate in polls with submission
- **Users**: Browse users by system type

## Essential Commands

### Development
```bash
# Run the app (development mode)
flutter run

# Run with specific device
flutter run -d <device_id>

# Hot reload: Press 'r' in terminal
# Hot restart: Press 'R' in terminal
```

### Code Generation
```bash
# Generate .freezed.dart and .g.dart files
flutter pub run build_runner build

# Watch mode (auto-regenerate on file changes)
flutter pub run build_runner watch

# Clean generated files and rebuild
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

**Run build_runner after:**
- Adding/modifying `@freezed` classes (entities, states, events, models)
- Adding/modifying `@JsonSerializable` models
- Changing `@JsonKey` annotations

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/src/features/polls/data/datasources/poll_remote_data_source_test.dart

# Run tests with coverage
flutter test --coverage
```

### Linting & Analysis
```bash
# Run static analysis
flutter analyze

# Check for linting issues
flutter pub run flutter_lints
```

### Dependencies
```bash
# Install dependencies
flutter pub get

# Update dependencies
flutter pub upgrade
```

## Architecture

### Clean Architecture Pattern

The project follows **Clean Architecture** with three layers per feature:

```
feature_name/
├── domain/               # Business logic layer (pure Dart)
│   ├── entities/         # Business objects (Freezed immutable classes)
│   ├── repositories/     # Abstract repository interfaces
│   ├── usecases/         # Business logic orchestration
│   └── domain.dart       # Barrel export
├── data/                 # Data layer
│   ├── datasources/      # Remote/local data source abstracts + implementations
│   ├── models/           # JSON-serializable DTOs with toDomain() mappers
│   ├── repositories/     # Repository implementations
│   └── data.dart         # Barrel export
└── presentation/         # UI layer (only for features with UI)
    ├── bloc/             # BLoC + Events + States
    ├── pages/            # Full-screen widgets
    ├── widgets/          # Reusable UI components
    └── presentation.dart # Barrel export
```

### Data Flow

```
User Action → BLoC Event → Use Case → Repository Interface → Repository Impl
  → Data Source → ApiCallExecutor → ApiClient (Dio) → API
  → Response → Model.fromJson() → Model.toDomain() → Entity
  → Result<Entity> (Either<Exception, Entity>) → BLoC State → UI
```

### Core Infrastructure

**Location:** `lib/src/core/`

- **network/**: Dio-based API client with auth, logging, and error handling
  - `ApiClient`: Wrapper around Dio (SecureApiClient for prod, InsecureApiClient for dev)
  - `ApiConstants`: Centralized endpoint definitions
  - `ApiCallExecutor`: Generic API call wrapper with error handling

- **di/**: Dependency injection using GetIt service locator
  - `service_locator.dart`: All dependency registrations
  - `bloc_factory.dart`: Factory for creating BLoC instances

- **auth/**: Authentication token management
  - `LocalAuthTokenProvider`: Loads token from `.env` file

- **cache/**: Generic in-memory caching with TTL
  - `CacheManager<T>`: Generic cache with 1-hour default TTL

- **exceptions/**: Centralized exception handling
  - `NetworkException`: Wraps DioException with readable messages
  - `MappingException`: JSON parsing errors

- **types/**: Type definitions
  - `Result<T>`: Alias for `Either<Exception, T>` (functional error handling via fpdart)

- **files/**: File upload/download feature (Clean Architecture)

- **logging/**: Application logging
  - `AppLogger`: Wrapper around logger package

### Shared Modules

**Location:** `lib/src/shared/`

Reusable domain/data layers used across multiple features:

- **comments/**: Generic comments and likes functionality
  - **Includes presentation layer**: Reusable `CommentsPage` with BLoC
  - Configurable via endpoint factories in DI
  - Used by discounts feature (ready for news and other features)
  - Entities: `Comment`, `CommentAuthor`, `Attachment`
  - Use Cases: `GetCommentsUsecase`, `AddCommentUsecase`, `DeleteCommentUsecase`, `ToggleEntityLikeUsecase`, `ToggleCommentLikeUsecase`
  - Features: Add/delete comments, like comments, optimistic updates, error handling

- **master_data/**: Dictionary/lookup data (20+ entities)
  - Examples: `KpDiscountCategory`, `KpOffice`, `SystemStatus`, `TrainingType`
  - Each entity has its own data source → repository → use case

### Dependency Injection

All dependencies are registered in `lib/src/core/di/service_locator.dart` using GetIt.

**Pattern:**
```dart
// 1. Data sources (Singleton - reuse instance)
sl.registerLazySingleton<FeatureRemoteDataSource>(
  () => FeatureRemoteDataSourceImpl(sl())
);

// 2. Repositories (Singleton - reuse instance)
sl.registerLazySingleton<FeatureRepository>(
  () => FeatureRepositoryImpl(sl())
);

// 3. Use cases (Factory - new instance each time)
sl.registerFactory<GetFeatureUsecase>(
  () => GetFeatureUsecase(sl())
);

// 4. BLoCs (Factory - new instance per page)
// Created via BlocFactory in presentation layer
```

**Lifecycle:**
- `registerLazySingleton`: Single instance created on first access (data sources, repositories)
- `registerFactory`: New instance each time (use cases, BLoCs)

### Error Handling

The project uses functional error handling with **Either** type from fpdart:

```dart
typedef Result<T> = Either<Exception, T>;

// In use cases/repositories/data sources:
Future<Result<Entity>> getData() async {
  try {
    final data = await apiClient.get(endpoint);
    return Right(data.toDomain());
  } catch (e) {
    return Left(NetworkException.from(e));
  }
}

// In BLoC:
final result = await useCase();
result.fold(
  (error) => emit(ErrorState(error.message)),
  (data) => emit(SuccessState(data)),
);
```

**Never throw exceptions** - always wrap in Result<T>.

### Code Generation

The project uses **Freezed** and **JSON Serializable**:

**Freezed** (`@freezed`):
- Generates: `.freezed.dart` files
- Used for: Entities, BLoC States, BLoC Events, Models
- Provides: `copyWith()`, `toString()`, `==`, `hashCode`, pattern matching

**JSON Serializable** (`@JsonSerializable`):
- Generates: `.g.dart` files
- Used for: All models (DTOs)
- Provides: `fromJson()`, `toJson()`

**Example Model:**
```dart
@freezed
class DiscountModel with _$DiscountModel {
  const factory DiscountModel({
    required int id,
    @JsonKey(name: 'category') CategoryModel? categoryModel,
  }) = _DiscountModel;

  factory DiscountModel.fromJson(Map<String, dynamic> json)
    => _$DiscountModelFromJson(json);
}

// Manual mapping to domain entity
extension DiscountModelX on DiscountModel {
  Discount toDomain() => Discount(
    id: id,
    category: categoryModel?.toDomain(),
  );
}
```

### Barrel Exports

Each layer uses barrel files (`domain.dart`, `data.dart`, `presentation.dart`) to export all public APIs:

```dart
// lib/src/features/discounts/domain/domain.dart
export 'entities/discount.dart';
export 'entities/author.dart';
export 'repositories/discount_repository.dart';
export 'usecases/get_discounts_usecase.dart';
export '../../../shared/comments/domain/domain.dart'; // Shared entities

// Usage in other files:
import 'package:hr_tcc_project/src/features/discounts/domain/domain.dart';
// Now you have access to all domain layer exports
```

**Always update barrel files when adding new files.**

## Adding a New Feature

1. **Create feature directory structure:**
   ```
   lib/src/features/feature_name/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   ├── usecases/
   │   └── domain.dart
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   ├── repositories/
   │   └── data.dart
   └── presentation/          # If feature has UI
       ├── bloc/
       ├── pages/
       ├── widgets/
       └── presentation.dart
   ```

2. **Define entities** (domain layer) using `@freezed`

3. **Define repository interface** (domain layer)

4. **Create use cases** (domain layer) that depend on repository interface

5. **Create models** (data layer) with `@freezed` and `@JsonSerializable`
   - Add `toDomain()` extension for mapping models to entities

6. **Create data source** (data layer) using `ApiCallExecutor`

7. **Implement repository** (data layer) that calls data source

8. **Register dependencies** in `lib/src/core/di/service_locator.dart`:
   ```dart
   void _initializeFeatureDependencies() {
     // Data source
     sl.registerLazySingleton<FeatureRemoteDataSource>(
       () => FeatureRemoteDataSourceImpl(sl())
     );

     // Repository
     sl.registerLazySingleton<FeatureRepository>(
       () => FeatureRepositoryImpl(sl())
     );

     // Use cases
     sl.registerFactory<GetFeatureUsecase>(
       () => GetFeatureUsecase(sl())
     );
   }
   ```

9. **Run code generation:**
   ```bash
   flutter pub run build_runner build
   ```

10. **If feature has UI:**
    - Create BLoC with events and states (using `@freezed`)
    - Create pages and widgets
    - Register routes in `lib/main.dart`

11. **Write tests** for data sources (integration tests against real API)

## Environment Configuration

The app loads configuration from `.env` file in the project root:

```bash
API_BASE_URL=https://dev-memp-hr-tcc-service.stoloto.su/api/v1
ACCESS_TOKEN=<JWT_TOKEN>
```

**Never commit real tokens to git.** The `.env` file should be in `.gitignore`.

Access via:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['API_BASE_URL'];
final token = dotenv.env['ACCESS_TOKEN'];
```

## Testing Strategy

Tests are integration tests that hit the real API (no mocks):

```dart
void main() {
  group('FeatureRemoteDataSource', () {
    late FeatureRemoteDataSource dataSource;
    late ApiClient apiClient;
    late AuthTokenProvider authTokenProvider;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = FeatureRemoteDataSourceImpl(apiClient);
    });

    test('should fetch data from API', () async {
      final result = await dataSource.getData();

      result.fold(
        (error) => fail('Unexpected error: ${error.message}'),
        (data) {
          expect(data, isA<List<FeatureModel>>());
          AppLogger.d('Fetched data: ${data.length}');
        },
      );
    });
  });
}
```

## Code Style Guidelines

- Use `@freezed` for all entities, states, events, and models
- Use `Result<T>` (Either type) for all async operations - never throw exceptions
- Always provide `toDomain()` extension methods on models
- Use barrel files (`domain.dart`, `data.dart`, `presentation.dart`) for exports
- Follow naming convention:
  - Entities: `Discount`, `Author`
  - Models: `DiscountModel`, `AuthorModel`
  - Repositories: `DiscountRepository` (interface), `DiscountRepositoryImpl` (implementation)
  - Data sources: `DiscountRemoteDataSource` (interface), `DiscountRemoteDataSourceImpl` (implementation)
  - Use cases: `GetDiscountsUsecase`, `AddCommentUsecase`
- Use `ApiCallExecutor.executeApiCall()` for all API calls
- Register data sources and repositories as singletons, use cases and BLoCs as factories
- Avoid print statements (linter rule: `avoid_print: true`) - use `AppLogger` instead

## Key Dependencies

- **flutter_bloc**: State management
- **freezed** + **freezed_annotation**: Immutable classes with code generation
- **json_serializable** + **json_annotation**: JSON serialization
- **dio** + **pretty_dio_logger**: HTTP client with logging
- **get_it**: Dependency injection
- **fpdart**: Functional programming (Either type for error handling)
- **equatable**: Value equality
- **go_router**: Navigation (imported but not yet used, routes in main.dart)
- **flutter_dotenv**: Environment variables
- **connectivity_plus**: Network connectivity status
- **logger**: Logging

## API Integration

All API endpoints are defined in `lib/src/core/network/api_constants.dart`:

```dart
class ApiConstants {
  static const String polls = '/polls';
  static String pollDetailEndpoint(int pollId) => '/polls/$pollId';
  static String discountCommentsEndpoint(int discountId) => '/discount/$discountId/comments';
}
```

Generic API call pattern using `ApiCallExecutor`:

```dart
Future<Result<List<Model>>> fetchData() async {
  return ApiCallExecutor.executeApiCall(
    apiCall: () => _apiClient.get(ApiConstants.endpoint),
    successParser: (response) {
      final data = response.data as List;
      return data.map((json) => Model.fromJson(json)).toList();
    },
  );
}
```

## Shared Functionality

When multiple features need the same functionality (e.g., comments, likes), use the **shared module pattern**:

1. Create shared module in `lib/src/shared/module_name/`
2. Implement domain and data layers (no presentation layer)
3. Make data sources configurable via constructor parameters (e.g., endpoint factories)
4. Register in DI with feature-specific configuration:

```dart
// In service_locator.dart for discounts feature
sl.registerLazySingleton<CommentRemoteDataSource>(
  () => CommentRemoteDataSourceImpl(
    apiClient: sl(),
    getCommentsEndpoint: ApiConstants.discountCommentsEndpoint,
    addCommentEndpoint: ApiConstants.discountCommentsEndpoint,
    deleteCommentEndpoint: ApiConstants.discountCommentEndpoint,
  ),
  instanceName: 'discountComments', // Unique instance name
);

// In service_locator.dart for news feature
sl.registerLazySingleton<CommentRemoteDataSource>(
  () => CommentRemoteDataSourceImpl(
    apiClient: sl(),
    getCommentsEndpoint: ApiConstants.newsCommentsEndpoint,
    addCommentEndpoint: ApiConstants.newsCommentsEndpoint,
    deleteCommentEndpoint: ApiConstants.newsCommentEndpoint,
  ),
  instanceName: 'newsComments', // Different instance name
);
```

This pattern ensures DRY while maintaining flexibility.

## BLoC Best Practices

### Avoiding Async Issues in Event Handlers

**IMPORTANT**: When calling async operations in BLoC event handlers, always `await` them properly to avoid emit-after-completion errors.

**BAD - Causes assertion error:**
```dart
on<Event>((event, emit) {
  future.then((result) {
    emit(State.loaded(result)); // Error: emit called after handler completed
  });
});
```

**GOOD - Properly awaited:**
```dart
on<Event>((event, emit) async {
  emit(State.loading());
  final result = await future;
  if (!emit.isDone) {
    result.fold(
      (error) => emit(State.error(error.message)),
      (data) => emit(State.loaded(data)),
    );
  }
});
```

### Example: Adding Comments with Proper Async Handling

```dart
Future<void> _onAddComment(AddComment event, Emitter<State> emit) async {
  // Extract current state
  List<Comment>? comments;
  state.maybeWhen(
    loaded: (loadedComments, _) => comments = loadedComments,
    orElse: () {},
  );

  if (comments != null) {
    emit(State.loaded(comments: comments!, isAddingComment: true));

    // Await the async operation
    final result = await _addCommentUsecase(
      entityId: entityId,
      content: event.content,
    );

    // Check result and reload if successful
    if (result.isRight()) {
      await _loadComments(emit); // Await this too!
    } else {
      emit(State.loaded(comments: comments!, isAddingComment: false));
    }
  }
}
```

### Optimistic Updates with Revert on Error

For like/unlike actions, use optimistic updates to provide instant feedback:

```dart
Future<void> _onToggleLike(ToggleLike event, Emitter<State> emit) async {
  // 1. Optimistically update UI
  state.maybeWhen(
    loaded: (items, _) {
      final updated = items.map((item) {
        if (item.id == event.itemId) {
          return item.copyWith(
            liked: !item.liked,
            likeCount: item.liked ? item.likeCount - 1 : item.likeCount + 1,
          );
        }
        return item;
      }).toList();
      emit(State.loaded(items: updated));
    },
    orElse: () {},
  );

  // 2. Make API call
  final result = await _toggleLikeUsecase(event.itemId);

  // 3. Revert on error
  result.fold(
    (error) {
      state.maybeWhen(
        loaded: (items, _) {
          final reverted = items.map((item) {
            if (item.id == event.itemId) {
              return item.copyWith(
                liked: !item.liked,
                likeCount: item.liked ? item.likeCount - 1 : item.likeCount + 1,
              );
            }
            return item;
          }).toList();
          emit(State.loaded(items: reverted));
        },
        orElse: () {},
      );
    },
    (_) {}, // Success - no action needed, already updated
  );
}
```

## Pagination Implementation

For infinite scroll lists, implement pagination in the BLoC:

```dart
@freezed
class ListState with _$ListState {
  const factory ListState.loaded({
    required List<Item> items,
    required int currentPage,
    required bool hasMorePages,
    required bool isLoadingMore,
  }) = ListLoaded;
}

// In BLoC:
on<LoadMore>((event, emit) async {
  state.maybeWhen(
    loaded: (items, page, hasMore, isLoadingMore) {
      if (!isLoadingMore && hasMore) {
        // Set loading flag
        emit(ListState.loaded(
          items: items,
          currentPage: page,
          hasMorePages: hasMore,
          isLoadingMore: true,
        ));

        // Load next page
        _loadMore(emit, items, page + 1);
      }
    },
    orElse: () {},
  );
});
```

In the UI, use `ScrollController` to detect scroll position:

```dart
void _onScroll() {
  if (_isBottom) {
    context.read<Bloc>().add(Event.loadMore());
  }
}

bool get _isBottom {
  if (!_scrollController.hasClients) return false;
  final maxScroll = _scrollController.position.maxScrollExtent;
  final currentScroll = _scrollController.offset;
  return currentScroll >= (maxScroll * 0.9); // Trigger at 90%
}
```
