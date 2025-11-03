# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter mobile application for HR TCC (HR Technical Coordination Center) that provides features for managing notifications, polls, and various HR-related functionalities. The app integrates with multiple backend systems (JIRA, ELMA, KP) and uses Clean Architecture principles.

## Development Commands

### Setup
```bash
# Install dependencies
flutter pub get

# Load environment variables from .env file
# API_BASE_URL and ACCESS_TOKEN are required
```

### Code Generation
```bash
# Generate freezed and json_serializable files
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation during development
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Running the App
```bash
# Run on connected device/simulator
flutter run

# Run with specific device
flutter run -d <device_id>
```

### Testing & Quality
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/path/to/test_file.dart

# Run tests with verbose output
flutter test --verbose

# Analyze code
flutter analyze

# Check linting rules (defined in analysis_options.yaml)
```

## Architecture

### Clean Architecture Pattern

The codebase follows Clean Architecture with clear separation of concerns:

**Feature Structure:**
```
features/<feature_name>/
├── data/
│   ├── datasources/     # API calls via ApiClient
│   ├── models/          # DTOs with Freezed + JsonSerializable
│   └── repositories/    # Repository implementations (extend BaseRepository mixin)
├── domain/
│   ├── entities/        # Business objects with Freezed
│   ├── repositories/    # Abstract repository interfaces
│   └── usecases/        # Single-responsibility business logic
└── presentation/
    ├── bloc/            # BLoC state management
    ├── pages/           # Screen widgets
    └── widgets/         # Reusable UI components
```

**Core Structure:**
```
core/
├── di/                  # Dependency injection (GetIt)
│   ├── service_locator.dart  # Manual DI registration
│   └── bloc_factory.dart     # Factory for creating BLoC instances
├── network/             # API client (Dio-based)
├── auth/                # Authentication token provider
├── files/               # File upload/download (multi-system support)
├── logging/             # Centralized logging (AppLogger)
├── data/                # BaseRepository mixin
├── types/               # Result<T> type alias
├── cache/               # Generic caching layer with TTL
└── exceptions/          # NetworkException and MappingException
    ├── network/         # Network error handling
    └── mapping/         # Parsing/serialization error handling
```

**Shared Structure:**
```
shared/
└── master_data/         # Domain dictionaries and reference data
```

### Key Architectural Patterns

**1. Dependency Injection (GetIt)**
- Service locator pattern via `lib/src/core/di/service_locator.dart`
- All dependencies registered at app startup in `initializeDependencies()`
- Access via `sl<Type>()` throughout the codebase
- BLoC instances created via `BlocFactory` for proper dependency injection

**2. Error Handling**
- Functional error handling using `fpdart` library's `Either<L, R>` type
- **Result Type**: `Result<T>` type alias for `Either<Exception, T>` (defined in `lib/src/core/types/result.dart`)
- All repository/data source operations return `Result<T>`
- Two exception types:
  - `NetworkException`: HTTP/network errors (timeouts, connection issues, bad responses)
  - `MappingException`: JSON parsing and serialization errors
- Access error messages via `.message` extension on any Exception
- `ApiCallExecutor.executeApiCall()` returns `Result<T>` for standardized API call wrapping
- `BaseRepository` mixin provides `mapResult()` and `mapResultList()` utilities for `Result<T>`

**3. API Client Architecture**
- Abstract `ApiClient` interface with two implementations:
  - `SecureApiClient`: Standard HTTPS validation
  - `InsecureApiClient`: Disabled certificate validation (currently in use)
- Dio-based HTTP client with interceptors for:
  - Bearer token authentication (via `AuthTokenProvider`)
  - Request/response logging (via `PrettyDioLogger`, suppressed for file operations)
  - 30-second timeouts for all operations

**4. Multi-System File Handling**
- File upload/download support for JIRA, ELMA, and KP systems
- System-specific response models with unified `UploadedFile` entity
- File caching with `ClearFileCacheUsecase` for cache management
- `FileGroup` enum for organizing files by system type

**5. State Management**
- BLoC pattern via `flutter_bloc`
- Freezed for immutable state/event classes
- Factory pattern for BLoC creation ensures proper dependency injection
- Example: `BlocFactory.createPollsListBloc()` instead of direct instantiation

**6. Caching Layer**
- Generic `CacheManager<T>` for in-memory caching with TTL (Time-To-Live)
- Located in `lib/src/core/cache/cache_manager.dart`
- Configurable cache duration (default: 1 hour)
- Automatic expiration and manual cache clearing
- Injectable into repositories for testability
- Example: `CoreDictionariesRepositoryImpl` uses `CacheManager<CoreDictionariesResponse>`
- See `lib/src/core/cache/README.md` for detailed usage

## Environment Configuration

The app uses `.env` file for configuration (loaded via `flutter_dotenv`):

**Required variables:**
- `API_BASE_URL`: Backend API base URL
- `ACCESS_TOKEN`: Bearer token for authentication

The `.env` file is gitignored. Ensure it exists before running the app.

## Code Generation

The project heavily uses code generation:

**Freezed**: Immutable data classes with:
- `@freezed` annotation for entities and models
- Pattern matching, copy methods, and equality
- JSON serialization integration

**json_serializable**: JSON encoding/decoding:
- `@JsonSerializable()` on model classes
- Generates `.g.dart` files with toJson/fromJson methods

**Important**:
- Generated files (`*.freezed.dart`, `*.g.dart`) are gitignored
- Run `build_runner` after pulling changes or adding new models/entities
- Use `--delete-conflicting-outputs` flag to resolve conflicts

## Logging

Use `AppLogger` for all logging instead of print statements:

```dart
AppLogger.d('Debug message');
AppLogger.i('Info message');
AppLogger.w('Warning message');
AppLogger.e('Error message', error, stackTrace);
```

Log levels automatically adjust based on build mode:
- Debug builds: All levels (debug and above)
- Release builds: Warnings and errors only

## Navigation

Simple route-based navigation via `MaterialApp`:
- `/` - FeaturesPage (home)
- `/notifications` - NotificationsPage
- `/polls` - PollsPage
- `/poll` - PollPage (requires pollId argument)
- `/users` - UsersPage

## API Integration

All API endpoints defined in `ApiConstants`:
- Dictionary endpoints for master data
- Notification endpoints
- Poll endpoints
- User endpoints
- File upload/download endpoints

Base URL loaded from `.env` file.

### System Type Filtering

Many API endpoints support filtering by system type (JIRA, ELMA, KP, _1C):
- Use the `SystemType` enum from `lib/src/core/files/domain/entities/system_type.dart`
- Enum values: `elma`, `kp`, `jira`, `oneC`
- Get API string value via `.value` getter (returns ELMA, KP, JIRA, _1C)
- Parse from API string via `SystemType.fromString()` or `systemTypeFromJson()`

## Adding a New Feature

1. Create feature directory structure under `lib/src/features/<feature_name>/`
2. Define domain entities in `domain/entities/` (use Freezed)
3. Create repository interface in `domain/repositories/`
4. Implement use cases in `domain/usecases/`
5. Create data models in `data/models/` (use Freezed + JsonSerializable)
6. Implement data sources in `data/datasources/`
7. Implement repository in `data/repositories/` (extend `BaseRepository` mixin)
8. Create consolidated barrel files for clean imports:
   - `domain/domain.dart` - exports all entities, repositories, and usecases
   - `data/data.dart` - exports all models, datasources, and repository implementations
   - `presentation/presentation.dart` - exports all pages, widgets, and BLoC files (if applicable)
9. Register dependencies in `service_locator.dart` using consolidated barrel imports
10. Create BLoC in `presentation/bloc/` (if needed for complex state management)
11. Add BLoC factory method in `bloc_factory.dart` (if BLoC created)
12. Build UI in `presentation/pages/` and `presentation/widgets/`
13. Add route in `main.dart` and navigation from `FeaturesPage`
14. Run `flutter pub run build_runner build --delete-conflicting-outputs`
15. Create integration tests in `test/src/features/<feature_name>/` following existing patterns

### Example: Users Feature

The users feature demonstrates a complete implementation:

**Domain Layer:**
- `User` entity with Freezed
- `UserRepository` abstract interface
- `GetUsersUsecase` for business logic

**Data Layer:**
- `UserModel` with Freezed + JsonSerializable
- `GetUsersResponse` wrapper for API response
- `UserRemoteDataSource` with `ApiCallExecutor` integration
- `UserRepositoryImpl` extending `BaseRepository` mixin
- Model-to-domain mapping via `.toDomain()` extension

**Presentation Layer:**
- Simple `UsersPage` with dropdown (system type) and search
- Direct use case injection via `sl<GetUsersUsecase>()`
- Result handling with `.fold()` for error/success states

**Testing:**
- Integration tests in `test/src/features/users/data/datasources/`
- Real API calls with environment configuration
- Multiple test cases covering all system types and search scenarios

## Testing Strategy

The project uses integration testing with real API calls instead of mocks:

### Test Structure

```dart
void main() {
  group('FeatureRemoteDataSource', () {
    late FeatureRemoteDataSource dataSource;
    late ApiClient apiClient;
    late AuthTokenProvider authTokenProvider;

    setUpAll(() async {
      // Load environment variables once for all tests
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      // Create real instances before each test
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = FeatureRemoteDataSourceImpl(apiClient);
    });

    test('should fetch data from API', () async {
      // Act
      final result = await dataSource.getData();

      // Assert using Result<T>.fold() pattern
      result.fold(
        (failure) => fail('Unexpected error: ${failure.message}'),
        (data) {
          expect(data, isA<ExpectedType>());
          AppLogger.d('Success: $data');
        },
      );
    });
  });
}
```

### Testing Best Practices

**Integration Test Pattern:**
- Use real implementations instead of mocks (ApiClient, AuthTokenProvider, DataSource)
- Load environment variables via `flutter_dotenv` in `setUpAll()`
- Create fresh instances in `setUp()` for test isolation
- Make actual API calls to backend (requires `.env` configuration)

**Assertion Pattern:**
- Use `Result<T>.fold()` for handling success/failure cases
- Call `fail()` with error message on unexpected failures
- Use `expect()` for type and value assertions
- Log successful results with `AppLogger.d()` for debugging

**Test Coverage:**
- Test all variations of parameters (system types, optional fields, search terms)
- Test response parsing and model structure
- Test error scenarios when possible
- Group related tests with `group()`

**Example Test Cases:**
```dart
// Test different enum values
test('should work with ELMA system type', () async { ... });
test('should work with KP system type', () async { ... });
test('should work with JIRA system type', () async { ... });
test('should work with _1C system type', () async { ... });

// Test optional parameters
test('should work with search parameter', () async { ... });
test('should work without search parameter', () async { ... });

// Test response structure
test('should correctly map API response to model', () async { ... });
```

**Environment Setup for Tests:**
Ensure `.env` file exists with required variables:
```
API_BASE_URL=https://your-api-url.com
ACCESS_TOKEN=your-test-token
```
