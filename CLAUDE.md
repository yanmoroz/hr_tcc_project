# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter HR mobile application built with Clean Architecture principles. The app provides features for managing news, discounts, polls, resell items, applications, notifications, and users.

**Tech Stack:**
- Flutter 3.35.7 / Dart 3.9.2
- State management: flutter_bloc
- Dependency injection: get_it
- Networking: dio with pretty_dio_logger
- Functional programming: fpdart (for Result/Either types)
- Code generation: freezed, json_serializable
- Routing: go_router

## Common Commands

### Development
```bash
# Get dependencies
flutter pub get

# Run code generation (Freezed, JSON serialization)
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
flutter test test/src/features/users/data/datasources/user_remote_data_source_test.dart

# Run tests with coverage
flutter test --coverage
```

### Code Quality
```bash
# Lint code
flutter analyze

# Format code
flutter format lib/ test/

# Fix formatting issues
flutter format --set-exit-if-changed lib/ test/
```

### Build
```bash
# Build APK
flutter build apk

# Build iOS
flutter build ios

# Build for release
flutter build apk --release
flutter build ios --release
```

## Architecture

The project follows **Clean Architecture** with feature-based organization:

```
lib/src/
├── core/                    # Core infrastructure shared across features
│   ├── auth/               # Authentication token provider
│   ├── base_types/         # Result type (Either<Exception, T>)
│   ├── cache/              # Generic cache manager
│   ├── di/                 # Dependency injection (GetIt service locator)
│   ├── entities/           # Core domain entities (master data)
│   ├── exceptions/         # NetworkException, MappingException
│   ├── master_data/        # Master data repository and cache
│   ├── network/            # ApiClient (Dio wrapper), API constants
│   └── value_objects/      # Shared value objects (SystemType, etc.)
├── features/               # Feature modules (Clean Architecture layers)
│   ├── applications/
│   ├── discounts/
│   ├── news/
│   ├── notifications/
│   ├── polls/
│   ├── resell/
│   └── users/
└── shared/                 # Shared functionality used across features
    ├── comments/          # Comment system (shared by news/discounts)
    └── files/             # File upload/download functionality
```

### Feature Structure

Each feature follows Clean Architecture with three layers:

```
feature/
├── data/
│   ├── datasources/       # Remote data sources (API calls)
│   ├── models/            # Data models with JSON serialization
│   └── repositories/      # Repository implementations
├── domain/
│   ├── entities/          # Business entities (Freezed classes)
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic use cases
└── presentation/
    ├── bloc/              # BLoC state management
    ├── pages/             # Page widgets
    └── widgets/           # Reusable widgets
```

### Key Architectural Patterns

**Result Type Pattern:**
- All repository/use case methods return `Result<T>` (alias for `Either<Exception, T>` from fpdart)
- Left side: `NetworkException` or `MappingException`
- Right side: Success value
- Use `.fold()` to handle both cases in BLoCs

**Dependency Injection:**
- All dependencies registered in `lib/src/core/di/service_locator.dart`
- Use `sl<T>()` to resolve dependencies (GetIt service locator)
- Repositories and data sources: `registerLazySingleton`
- Use cases and BLoCs: `registerFactory`
- Named instances for shared functionality (e.g., `'discountComments'` vs `'newsComments'`)

**Shared Functionality Pattern:**
- Comments system is shared between news/discounts features
- Comment like functionality is also shared (in `shared/comments/domain/usecases/toggle_comment_like/`)
- Shared comment use cases use abstract interfaces (`GetCommentsUsecase`, `AddCommentUsecase`, `DeleteCommentUsecase`, `ToggleCommentLikeUsecase`)
- Feature-specific implementations inject their own repositories for comments
- Comment like use cases (`ToggleNewsCommentLikeUsecase`, `ToggleDiscountCommentLikeUsecase`) use shared `CommentRepository`
- `BlocFactory` selects the correct implementation based on `CommentableEntityType`

**Master Data Cache:**
- Centralized cache for application forms, system statuses, offices, etc.
- Located in `core/master_data/`
- TTL-based caching (default 1 hour)
- Use `MasterDataRepository` to fetch/access cached data

**API Client:**
- `ApiClient` abstraction with two implementations:
  - `SecureApiClient`: Production use
  - `InsecureApiClient`: Development (bypasses certificate validation)
- Currently using `InsecureApiClient` in service_locator
- Auto-injects Bearer token via `AuthTokenProvider`
- Pretty logging for non-file endpoints

## Code Generation

This project uses Freezed for immutable classes and JSON serialization:

**When to run build_runner:**
- After modifying any `@freezed` classes
- After changing `@JsonSerializable` models
- After updating JSON field mappings

**Generated files:**
- `*.freezed.dart` - Freezed immutable classes with copyWith, equality
- `*.g.dart` - JSON serialization code

**Important:** Always exclude generated files from analysis (`analysis_options.yaml` already configured)

## Testing Structure

```
test/src/
├── core/                  # Core functionality tests
│   └── files/
├── features/              # Feature tests
│   └── users/
├── master_data_test.dart  # Master data tests
└── notifications_test.dart
```

## Important Conventions

**Barrel Files:**
- Each layer exports public API via barrel files: `data.dart`, `domain.dart`
- Import from barrel files, not individual files
- Recent refactoring has been removing unnecessary barrel files

**Naming:**
- Use cases: `<Verb><Entity>Usecase` (e.g., `GetUsersUsecase`)
- BLoCs: `<Feature><Page>Bloc` (e.g., `DiscountsListBloc`)
- Models: `<Entity>Model` with `fromJson`/`toJson`
- Entities: Pure domain objects (Freezed classes)

**File Organization:**
- Entity files moved from feature-specific to `core/entities/` when shared
- Value objects in `core/value_objects/` (e.g., `SystemType`)
- Recent refactoring consolidated master data into core layer

## Environment Configuration

- Environment variables stored in `.env` file (loaded via flutter_dotenv)
- API base URL configured in `lib/src/core/network/api_constants.dart`

## Feature-Specific Notes

### Users Feature

The users feature has been extended with comprehensive employee/address book functionality:

**Entities:**
- `User` - Simple user entity (legacy, used by `/users` endpoint with SystemType filter)
- `AddressBookUser` - Full employee entity with 21 fields including:
  - Personal info: firstName, lastName, middleName, birthDate, snils
  - Contact: mobile, workPhone, mail, workLocation
  - Employment: position, organization, department
  - System IDs: idPersonElma, idPersonKp, jiraCode
  - Status: archive, photoExists, vacationDaysLeft
- `Organization` - Nested entity (id, code, name, fullName)
- `Department` - Nested entity (id, code, name, archive)

**Available Endpoints:**
1. **GET /users** - Get users filtered by SystemType (ELMA, KP, JIRA, TCC, _1C)
   - Use case: `GetUsersUsecase`
   - Returns simple `List<User>`

2. **GET /users/addressbook** - Get paginated address book with filtering
   - Use case: `GetAddressBookUsecase`
   - Parameters: organizationCode, departmentCode, search, page (0-indexed), pageSize (max 100)
   - Returns `List<AddressBookUser>` with full employee details
   - Response includes total count for pagination

3. **GET /users/me** - Get current authenticated user info
   - Use case: `GetCurrentUserInfoUsecase`
   - No parameters (uses Bearer token)
   - Returns single `AddressBookUser` with full details
   - Backend may auto-populate missing `idPersonElma` on first call

**Important Notes:**
- All three endpoints share the same model structure via `AddressBookUserModel`
- The `/addressbook` and `/me` endpoints use identical `GetCurrentUserInfoResponse` from backend
- Models use UUID for IDs (not Integer like some KP integration endpoints)
- All use cases return `Result<T>` for consistent error handling
- Freezed code already generated - no need to run build_runner for users feature

### Comments and Likes Feature

The comments system is shared between news and discounts features, including comment like functionality:

**Shared Comments Structure:**
- `lib/src/shared/comments/` - Shared comment infrastructure
- Abstract use case interfaces: `GetCommentsUsecase`, `AddCommentUsecase`, `DeleteCommentUsecase`, `ToggleCommentLikeUsecase`
- Feature-specific implementations in `domain/usecases/` subdirectories:
  - `get_comments_usecase/` - GetNewsCommentsUsecase, GetDiscountCommentsUsecase
  - `add_comment_usecase/` - AddNewsCommentUsecase, AddDiscountCommentUsecase
  - `delete_comment_usecase/` - DeleteNewsCommentUsecase, DeleteDiscountCommentUsecase
  - `toggle_comment_like/` - ToggleNewsCommentLikeUsecase, ToggleDiscountCommentLikeUsecase (shared implementations)
- `CommentableEntityType` enum to distinguish between news and discounts
- Single `CommentsBloc` works with both features via dependency injection

**Feature-Specific Entity Likes:**
- News: `ToggleNewsLikeUsecase` (in `features/news/domain/usecases/`)
- Discounts: `ToggleDiscountLikeUsecase` (in `features/discounts/domain/usecases/`)
- Each feature repository has methods for liking the main entity (news item, discount)
- All like operations return `Result<bool>` directly (no response models)

**Comment Like Architecture:**
- Comment like use cases are in shared layer but feature-specific
- Both use shared `CommentRepository` which has methods: `toggleNewsCommentLike()` and `toggleDiscountCommentLike()`
- `CommentRepository` delegates to `CommentRemoteDataSource` which calls the appropriate API endpoints
- This consolidates comment like logic in the shared layer while maintaining feature-specific API routes

**Implementation Notes:**
- Comment like use cases implement `ToggleCommentLikeUsecase` interface
- `BlocFactory.createCommentsBloc()` injects correct implementations based on `CommentableEntityType`
- Named instances in service locator for comment repositories (`'newsComments'`, `'discountComments'`)
- Comment like use cases registered without named instances (typed resolution)

## Current Development State

Based on git status, recent work includes:
- **Refactored comments and likes architecture** - Consolidated comment like functionality into shared layer
  - Moved comment like use cases from feature-specific to shared layer (`lib/src/shared/comments/domain/usecases/toggle_comment_like/`)
  - Added like methods to shared `CommentRepository` and `CommentRemoteDataSource`
  - Removed like methods from `NewsRepository` and `DiscountRepository` for comments
  - Entity likes (liking news/discount items themselves) remain feature-specific
- **Extended users feature** with address book and current user endpoints
- Added comprehensive employee data models (AddressBookUser, Organization, Department)
- Implemented pagination support for address book
- Refactoring notifications structure (flattening, removing barrel files)
- Moving shared entities to core (e.g., `SystemType`)
- Consolidating master data infrastructure
- Updating file upload/download system
