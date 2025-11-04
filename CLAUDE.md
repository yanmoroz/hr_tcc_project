# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter HR/TCC (Talent & Culture Center) application built with Clean Architecture principles. The project integrates with a backend API to manage HR-related features including polls, notifications, discounts, users, and master data dictionaries.

## Essential Commands

### Code Generation
```bash
# Generate freezed and json_serializable files (required after model changes)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/src/features/discounts/data/datasources/discount_remote_data_source_test.dart

# Run tests in a directory
flutter test test/src/features/discounts/
```

### Linting and Analysis
```bash
# Run static analysis
flutter analyze

# Check for lint issues
flutter analyze --no-fatal-infos
```

### Running the App
```bash
# Run on connected device/emulator
flutter run

# Run in debug mode with specific flavor (if configured)
flutter run --debug

# Build for release
flutter build apk
flutter build ios
```

## Architecture Overview

### Clean Architecture Layers

The codebase follows Clean Architecture with strict layer separation:

1. **Domain Layer** (`lib/src/features/*/domain/` or `lib/src/shared/*/domain/`)
   - Entities: Pure business objects (e.g., `Discount`, `Poll`, `Notification`)
   - Repository interfaces: Abstract contracts for data operations
   - Use cases: Single-responsibility business logic units (e.g., `GetDiscountsUsecase`)

2. **Data Layer** (`lib/src/features/*/data/` or `lib/src/shared/*/data/`)
   - Models: Data transfer objects with JSON serialization using `freezed` and `json_serializable`
   - Data sources: Remote API implementations (e.g., `DiscountRemoteDataSource`)
   - Repository implementations: Concrete implementations of domain repository interfaces
   - Models have `toDomain()` extension methods to convert to domain entities

3. **Presentation Layer** (`lib/src/features/*/presentation/`)
   - BLoC pattern for state management using `flutter_bloc`
   - Pages: UI screens
   - Widgets: Reusable UI components
   - BLoC events/states using `freezed` for immutability

### Core Infrastructure

**Dependency Injection** (`lib/src/core/di/`)
- Uses `get_it` for service location
- `service_locator.dart`: Central DI configuration with feature-specific initialization methods
- `bloc_factory.dart`: Factory for creating BLoC instances with dependencies
- Register data sources as lazy singletons, use cases as factories

**Networking** (`lib/src/core/network/`)
- `ApiClient`: Abstract HTTP client built on `dio`
- `InsecureApiClient`: Used for development (bypasses SSL validation)
- `SecureApiClient`: Production-ready with proper certificate validation
- Automatic bearer token injection via `AuthTokenProvider`
- Request/response logging with `PrettyDioLogger` (excludes file upload/download)

**Error Handling** (`lib/src/core/types/` and `lib/src/core/exceptions/`)
- `Result<T>`: Type alias for `Either<Exception, T>` using `fpdart`
- Separates `NetworkException` (API errors) from `MappingException` (JSON parsing errors)
- All repository methods return `Result<T>` for functional error handling

**Caching** (`lib/src/core/cache/`)
- `CacheManager<T>`: Generic in-memory cache with TTL support (default 1 hour)
- Used by repositories to cache API responses and reduce network calls
- Check cache validity before making API requests

**File Operations** (`lib/src/core/files/`)
- `FileRepository`: Handles file upload/download with progress tracking
- `ClearFileCacheUsecase`: Clears cached files from device storage

### Feature Organization

Each feature follows this structure:
```
lib/src/features/{feature_name}/
├── data/
│   ├── data.dart              # Barrel file for data layer
│   ├── models/                # JSON models with freezed/json_serializable
│   ├── datasources/           # Remote API data sources
│   └── repositories/          # Repository implementations
├── domain/
│   ├── domain.dart            # Barrel file for domain layer
│   ├── entities/              # Pure business objects
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business logic units
└── presentation/              # UI layer (if needed)
    ├── presentation.dart      # Barrel file
    ├── bloc/                  # BLoC state management
    ├── pages/                 # Screen widgets
    └── widgets/               # Reusable components
```

### Master Data Pattern

`lib/src/shared/master_data/` contains reusable dictionaries fetched from the backend (e.g., categories, offices, types). These are shared across features and follow the same domain/data layer separation with caching support.

### Barrel Files

The project uses layer-based barrel files for clean imports:
- `domain.dart`: Exports all entities, repositories, and use cases
- `data.dart`: Exports all models, data sources, and repository implementations
- `presentation.dart`: Exports all BLoCs, pages, and widgets

Import from barrel files to avoid deep imports:
```dart
// Good
import '../../features/discounts/domain/domain.dart';

// Avoid
import '../../features/discounts/domain/entities/discount.dart';
import '../../features/discounts/domain/repositories/discount_repository.dart';
```

## Development Workflow

### Adding a New Feature

1. Create domain entities in `domain/entities/`
2. Define repository interface in `domain/repositories/`
3. Create use cases in `domain/usecases/`
4. Update `domain/domain.dart` barrel file
5. Create data models in `data/models/` with `@freezed` and `@JsonSerializable` annotations
6. Run `flutter pub run build_runner build --delete-conflicting-outputs`
7. Implement data source in `data/datasources/`
8. Implement repository in `data/repositories/`
9. Update `data/data.dart` barrel file
10. Register dependencies in `lib/src/core/di/service_locator.dart`
11. Create BLoC in `presentation/bloc/` if UI is needed
12. Register BLoC factory method in `bloc_factory.dart` if needed

### Working with Models

- All data models use `freezed` for immutability and `json_serializable` for JSON parsing
- Models must have a `toDomain()` extension method to convert to domain entities
- After modifying models, run: `flutter pub run build_runner build --delete-conflicting-outputs`
- Generated files (`*.freezed.dart`, `*.g.dart`) are excluded from version control via `.gitignore`

### API Integration

- API base URL is configured in `.env` file (not committed to git)
- All API calls go through `ApiClient` which handles authentication and logging
- Data sources return `Result<T>` for error handling
- Use pattern matching with `.fold()` to handle success/failure cases

### Testing

- Tests are integration-style, using real instances (no mocking) to test against actual API
- Tests require `.env` file with valid API credentials
- Test structure mirrors source structure: `test/src/features/{feature}/data/datasources/`
- Use `flutter_test` package for testing

## Configuration Files

- **`.env`**: Environment variables (API base URL, tokens) - NOT committed to git
- **`analysis_options.yaml`**: Linter rules, excludes generated files
- **`pubspec.yaml`**: Dependencies including `dio`, `get_it`, `flutter_bloc`, `freezed`, `fpdart`

## Important Conventions

- Never manually edit `*.freezed.dart` or `*.g.dart` files
- Repository implementations handle caching logic transparently
- Use cases are single-purpose and don't contain business logic beyond orchestrating repository calls
- BLoCs manage UI state and orchestrate use case calls
- All async operations return `Future<Result<T>>` from repositories
- Use `AppLogger` for logging instead of `print` statements
