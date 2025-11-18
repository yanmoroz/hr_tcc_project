# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter HR application (hr_tcc_project) that provides features for managing news, discounts, polls, resell items, applications, notifications, comments, and users. The app uses Clean Architecture with feature-based modular organization.

## Development Commands

### Code Generation

```bash
# Generate freezed and json_serializable code (required after modifying models)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting and Analysis

```bash
# Run Flutter analyzer
flutter analyze

# Check for lint issues
flutter pub run flutter_lints
```

### Testing

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/src/news_test.dart

# Run tests with coverage
flutter test --coverage
```

### Running the App

```bash
# Run on connected device/emulator
flutter run

# Run in debug mode with hot reload
flutter run -d <device-id>
```

### Environment Setup

- Requires a `.env` file in the root directory (referenced in pubspec.yaml)
- Used for API endpoints and configuration (see `ApiConstants`)
- Load with `flutter_dotenv` package

## Architecture

### Clean Architecture Layers

The codebase follows Clean Architecture with three distinct layers:

1. **Domain Layer** (`domain/`):

   - Pure Dart, no Flutter dependencies
   - Contains entities, repositories (interfaces), and use cases
   - Business logic and domain models

2. **Data Layer** (`data/`):

   - Models with `freezed` and `json_serializable`
   - Repository implementations
   - Remote data sources (API clients)
   - Handles data mapping between API responses and domain entities

3. **Presentation Layer** (`presentation/`):
   - BLoC pattern for state management (`flutter_bloc`)
   - Pages and widgets
   - UI components

### Project Structure

```
lib/src/
├── core/                       # Core shared functionality
│   ├── auth/                   # Authentication token management
│   ├── base_types/             # Result type, base repository
│   ├── cache/                  # Caching mechanisms (TTL-based)
│   ├── di/                     # Dependency injection (GetIt)
│   ├── dictionaries/           # Application dictionaries
│   │   ├── data/               # Models, data sources, repository impl
│   │   ├── domain/             # Repository interface
│   │   └── dictionaries_cache.dart  # Type-safe generic cache
│   ├── entities/               # Shared domain entities
│   ├── exceptions/             # NetworkException, MappingException
│   ├── logging/                # App logging utilities
│   ├── navigation/             # go_router configuration
│   ├── network/                # ApiClient implementation (Dio)
│   ├── value_objects/          # Value objects (SystemType, StatusGroupType, etc.)
│   └── widgets/                # Shared UI components
├── features/                   # Feature modules
│   ├── applications/           # HR applications management
│   ├── comments/               # Comments functionality
│   ├── discounts/              # Discounts/benefits feature
│   ├── home/                   # Home screen
│   ├── news/                   # News feed feature
│   ├── notifications/          # Push notifications
│   ├── polls/                  # Polls and surveys
│   ├── resell/                 # Resell marketplace
│   └── users/                  # User profiles and address book
└── shared/                     # Shared across features
    └── files/                  # File upload/download functionality
```

### Feature Module Structure

Each feature follows this consistent structure:

```
feature_name/
├── data/
│   ├── data.dart               # Barrel export file
│   ├── datasources/            # Remote data sources
│   ├── models/                 # Freezed models with JSON serialization
│   └── repositories/           # Repository implementations
├── domain/
│   ├── domain.dart             # Barrel export file
│   ├── entities/               # Domain entities
│   ├── repositories/           # Repository interfaces
│   └── usecases/               # Use cases (business logic)
└── presentation/
    ├── bloc/                   # BLoC state management
    │   └── page_name/          # One folder per BLoC
    │       ├── *_bloc.dart
    │       ├── *_event.dart
    │       └── *_state.dart
    ├── pages/                  # Screen/page widgets
    └── widgets/                # Feature-specific widgets
```

### Key Patterns

#### Result Type

- All repository methods return `Result<T>` (alias for `Either<Exception, T>` from fpdart)
- Left side: `NetworkException` or `MappingException`
- Right side: Success data
- Use `.fold()` to handle both cases
- Test helper: `getOrFail<T>()` in `test/src/helpers/result_helper.dart`

#### Dependency Injection

- Uses `GetIt` (accessed via `sl` singleton)
- All dependencies registered in `lib/src/core/di/service_locator.dart`
- Data sources: `registerLazySingleton`
- Repositories: `registerLazySingleton`
- Use cases: `registerFactory`
- BLoCs: `registerFactory` (only for features that need global access)

#### Models and Entities

- **Models** (data layer): Use `freezed` + `json_serializable` for JSON serialization
  - Feature-specific models in `features/*/data/models/`
  - Shared dictionary models in `core/dictionaries/data/models/`
- **Entities** (domain layer): Plain Dart classes or freezed classes without JSON
  - Feature-specific entities in `features/*/domain/entities/`
  - Shared entities in `core/entities/`
- Models map to entities via extension methods (e.g., `toDomain()`) or factory constructors

#### Use Cases

- Single responsibility: one use case per business operation
- Named with `Usecase` suffix (e.g., `GetNewsListUsecase`)
- Implement `call()` method for execution
- Inject repository dependencies via constructor

#### BLoC Pattern

- Events: User actions or external triggers
- States: Often using freezed unions for different states (loading, loaded, error)
- BLoCs injected with use cases, not repositories directly
- Keep BLoCs in feature's presentation layer

#### File Operations

- Centralized in `shared/files/` module
- Supports multiple upload services (TCC, Elma, Jira, KP)
- Use `FileRepository` for upload/download operations
- Returns `UploadedFile` entities with metadata

#### Dictionaries (Master Data)

- Centralized management for application dictionaries (forms, categories, statuses, etc.)
- Located in `/core/dictionaries/` with clean architecture separation
- **Domain layer**: `MasterDataRepository` interface
- **Data layer**: Models (freezed + JSON), remote data source, repository implementation
- **Cache**: `DictionariesCache` - type-safe generic cache using `Map<Type, CacheManager>`
- **Atomic updates**: All dictionaries cached together (all-or-nothing) to prevent inconsistent state
- **Usage**: Features import models from `core/dictionaries/data/models/models.dart`
- **TTL**: 1-hour cache duration by default

### API Communication

- `ApiClient` abstraction with `InsecureApiClient` implementation
- Uses Dio with pretty logger for debugging
- Base URL in `ApiConstants.baseUrl` (loaded from .env)
- Auth token via `AuthTokenProvider`
- 30-second timeout for all requests

### Testing Approach

- Tests organized by feature in `test/src/`
- E2E-style tests that exercise full stack (data source → repository)
- Requires `.env` file with valid credentials
- Use `getOrFail()` helper to unwrap Result types in tests

## Code Generation Notes

When modifying models with `@freezed` or `@JsonSerializable`:

1. Update the model file
2. Run: `flutter pub run build_runner build --delete-conflicting-outputs`
3. Generated files: `*.freezed.dart` and `*.g.dart`
4. These files are excluded from analysis (see analysis_options.yaml)

## Barrel Files

Each layer (data, domain) has a barrel export file (e.g., `data.dart`, `domain.dart`) that exports all public APIs. Always update these when adding new files to maintain clean imports.

## Navigation

- Uses `go_router` package
- Router configuration in `lib/src/core/navigation/app_router.dart`
- Declarative routing with type-safe navigation
