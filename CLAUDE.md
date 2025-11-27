# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter mobile application for HR/employee services following Clean Architecture with BLoC state management. The app includes news feeds, discount offers, polls, applications management, and user profiles.

## Essential Commands

### Development
```bash
# Run code generation (after modifying freezed/json_serializable classes)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous code generation during development
flutter pub run build_runner watch --delete-conflicting-outputs

# Run linter
flutter analyze

# Run tests
flutter test

# Run specific test file
flutter test test/src/news_test.dart
```

### Building
```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Build for Android
flutter build apk

# Build for iOS
flutter build ios
```

## Architecture

### Clean Architecture + BLoC Pattern

All features follow a strict 3-layer architecture:

```
lib/src/features/{feature_name}/
├── data/           # Models, data sources, repository implementations
├── domain/         # Entities, repository interfaces, use cases
└── presentation/   # BLoCs, pages, widgets
```

**Data Flow**: UI Event → BLoC → UseCase → Repository → DataSource → ApiClient → API

**Key Principles**:
- Domain layer has NO dependencies on Flutter or external packages (pure Dart)
- Data models use `freezed` + `json_serializable`, entities use `freezed` only
- Repository implementations map models to entities via `toDomain()` extensions
- All async operations return `Result<T>` (Either from fpdart), never throw exceptions

### State Management: BLoC

- All features use BLoC/Cubit from `flutter_bloc`
- Events and states are immutable data classes using `freezed`
- BLoCs are created via `BlocFactory` (not registered in DI)
- Shared state uses singleton Cubits registered in GetIt
- All states include `LoadingStatus` enum (initial, loading, success, error)

**Creating BLoCs**:
```dart
// In BlocFactory (lib/src/core/di/bloc_factory.dart)
static NewsListBloc createNewsListBloc() => NewsListBloc(
  getNewsListUsecase: sl<GetNewsListUsecase>(),
);

// In route definition (lib/src/core/navigation/app_router.dart)
BlocProvider(
  create: (context) => BlocFactory.createNewsListBloc(),
  child: NewsPage(),
)
```

### Dependency Injection: GetIt

**Location**: [lib/src/core/di/service_locator.dart](lib/src/core/di/service_locator.dart)

- Use `sl.registerLazySingleton` for long-lived services (repositories, API clients)
- Use `sl.registerFactory` for short-lived instances (use cases)
- BLoCs are NOT registered in DI - use `BlocFactory` instead
- All dependencies initialized in `initializeDependencies()` called from `main.dart`

### Navigation: GoRouter

**Location**: [lib/src/core/navigation/app_router.dart](lib/src/core/navigation/app_router.dart)

- Uses `StatefulShellRoute.indexedStack` for bottom navigation with 4 tabs
- Each tab maintains independent navigation stack
- BLoCs provided at route level via `BlocProvider`
- Shared BLoCs (CurrentUserBloc, UnreadNotificationsCubit) provided at shell level

### Network Layer

**Location**: [lib/src/core/network/](lib/src/core/network/)

- All API calls wrapped in `ApiCallExecutor` which returns `Result<T>` (Either)
- `ApiClient` is a Dio-based HTTP client with bearer token auth
- Bearer token loaded from `.env` file via `AuthTokenProvider`
- API endpoints defined in `ApiConstants`
- Error types: `NetworkException` (HTTP/network errors), `MappingException` (JSON parsing errors)

**Making API Calls**:
```dart
// In data source
Future<Result<NewsItemModel>> fetchNews(int id) {
  return executeApiCall(
    apiCall: () => _apiClient.get<Map<String, dynamic>>(
      ApiConstants.newsDetailEndpoint(id),
    ),
    parser: (json) => NewsItemModel.fromJson(json),
  );
}
```

### Code Generation

**Files requiring code generation**:
- BLoC events/states (`.freezed.dart`)
- Data models (`.freezed.dart` + `.g.dart`)
- Domain entities (`.freezed.dart` only)
- Assets (`lib/gen/assets.gen.dart`, `lib/gen/fonts.gen.dart`)

**After modifying any freezed or json_serializable classes**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**VSCode Settings**: Generated files (`*.freezed.dart`, `*.g.dart`) are hidden in file explorer and search.

### Dictionaries (Reference Data)

**Location**: [lib/src/core/dictionaries/](lib/src/core/dictionaries/)

Dictionaries provide cached reference data from backend (offices, application forms, statuses, etc.).

- 11 dictionary types available via `DictionariesRepository`
- In-memory caching with 1-hour expiration
- Load all dictionaries: `await dictionariesRepository.fetchAndCacheAllDictionaries()`
- Access specific dictionary: `await dictionariesRepository.getOffices()`

## Adding New Features

1. **Create feature structure**:
   ```
   lib/src/features/new_feature/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   └── presentation/
       ├── blocs/
       ├── pages/
       └── widgets/
   ```

2. **Define domain layer** (entities, repository interface, use cases)

3. **Implement data layer** (models with freezed + json_serializable, data source, repository)

4. **Create presentation layer** (BLoC with events/states, pages, widgets)

5. **Register in DI** ([lib/src/core/di/service_locator.dart](lib/src/core/di/service_locator.dart)):
   ```dart
   // Data sources
   sl.registerLazySingleton<NewFeatureRemoteDataSource>(
     () => NewFeatureRemoteDataSourceImpl(sl()),
   );

   // Repositories
   sl.registerLazySingleton<NewFeatureRepository>(
     () => NewFeatureRepositoryImpl(sl()),
   );

   // Use cases
   sl.registerFactory(() => GetNewFeatureUsecase(sl()));
   ```

6. **Add BLoC factory** ([lib/src/core/di/bloc_factory.dart](lib/src/core/di/bloc_factory.dart)):
   ```dart
   static NewFeatureBloc createNewFeatureBloc() => NewFeatureBloc(
     getNewFeatureUsecase: sl<GetNewFeatureUsecase>(),
   );
   ```

7. **Add routes** ([lib/src/core/navigation/app_router.dart](lib/src/core/navigation/app_router.dart))

8. **Run code generation**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Authentication

- Currently uses static bearer token from `.env` file
- No login screen implemented yet
- Token automatically injected into all API requests
- Token provider: [lib/src/core/auth/auth_token_provider.dart](lib/src/core/auth/auth_token_provider.dart)

**.env file** (not in git):
```env
ACCESS_TOKEN=your_token_here
API_BASE_URL=https://api.example.com
```

## Important Conventions

### Freezed Classes
- **Data models**: Use `@freezed` with `fromJson`/`toJson` factories
- **Domain entities**: Use `@freezed` without JSON serialization
- **BLoC events/states**: Use `@freezed` without JSON serialization
- Always include `part` directives for generated files

### Error Handling
- Never use `try-catch` with API calls - use `ApiCallExecutor` which returns `Result<T>`
- Pattern match on `Result<T>` using `.fold()` or `.match()`
- All exceptions are caught and converted to `NetworkException` or `MappingException`

### File Organization
- Each layer (data/domain/presentation) has a barrel file (`data.dart`, `domain.dart`, `presentation.dart`)
- Feature-level barrel file exports all layers
- Import from barrel files, not individual files

### Naming Conventions
- BLoCs: `{FeatureName}Bloc` (e.g., `NewsListBloc`)
- Events: `{FeatureName}Event` (e.g., `NewsListEvent`)
- States: `{FeatureName}State` (e.g., `NewsListState`)
- Use cases: `{Action}Usecase` (e.g., `GetNewsListUsecase`)
- Repositories: `{FeatureName}Repository` (interface), `{FeatureName}RepositoryImpl` (implementation)

## Testing

Test files mirror the `lib/src` structure in `test/src`.

Run all tests:
```bash
flutter test
```

Run specific test:
```bash
flutter test test/src/news_test.dart
```

## Key Files Reference

- **App entry**: [lib/main.dart](lib/main.dart)
- **DI setup**: [lib/src/core/di/service_locator.dart](lib/src/core/di/service_locator.dart)
- **BLoC factories**: [lib/src/core/di/bloc_factory.dart](lib/src/core/di/bloc_factory.dart)
- **Routes**: [lib/src/core/navigation/app_router.dart](lib/src/core/navigation/app_router.dart)
- **API client**: [lib/src/core/network/api_client.dart](lib/src/core/network/api_client.dart)
- **API constants**: [lib/src/core/network/api_constants.dart](lib/src/core/network/api_constants.dart)
- **Error handling**: [lib/src/core/network/api_call_executor.dart](lib/src/core/network/api_call_executor.dart)
- **Base types**: [lib/src/core/base_types/](lib/src/core/base_types/)
