# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Building and Running
- `flutter run` - Run the app in debug mode
- `flutter run --release` - Run the app in release mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app

### Code Generation
- `flutter pub run build_runner build` - Generate freezed and json_serializable code
- `flutter pub run build_runner build --delete-conflicting-outputs` - Force regenerate all generated files
- `flutter pub run build_runner watch` - Watch mode for continuous code generation

### Testing and Analysis
- `flutter test` - Run all tests
- `flutter test test/src/news_test.dart` - Run a specific test file
- `flutter analyze` - Run static analysis

### Dependencies
- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Upgrade dependencies

## Architecture Overview

### Clean Architecture with Feature-First Organization
The codebase follows Clean Architecture principles organized by features. Each feature is self-contained in `lib/src/features/` with three layers:

```
features/
├── [feature_name]/
│   ├── data/           # Data sources, models, repository implementations
│   ├── domain/         # Entities, repositories (interfaces), use cases
│   ├── presentation/   # BLoCs, pages, widgets
│   └── [feature_name].dart  # Barrel export file
```

**Key features**: applications, comments, discounts, home, more, news, notifications, polls, resell, users

### Core Layer (`lib/src/core/`)
Shared infrastructure across all features:
- **auth/** - Authentication token management
- **base_types/** - Core types including:
  - `Result<T>` type (alias for `Either<Exception, T>` from fpdart)
  - `LoadingStatus` enum (initial, loading, success, error)
- **cache/** - Caching utilities
- **di/** - Dependency injection (GetIt service locator, BLoC factory)
- **dictionaries/** - Master data dictionaries with caching
- **entities/** - Core domain entities shared across features
- **exceptions/** - Network and mapping exception types
- **navigation/** - GoRouter configuration with shell routes
- **network/** - API client with Dio (supports secure/insecure modes)
- **value_objects/** - Domain value objects
- **widgets/** - Shared widgets

### Dependency Injection Pattern
- Uses GetIt (`sl` instance in `service_locator.dart`)
- Register dependencies in feature-specific initialization functions (e.g., `_initializeDiscountDependencies()`)
- **BLoC creation**: Never instantiate BLoCs directly. Always use `BlocFactory` methods
  - BLoCs are created per route in `app_router.dart` using `BlocFactory`
  - Factory pattern ensures consistent dependency injection

### Navigation Architecture
- **GoRouter** for declarative routing
- **ShellRoute** wraps main navigation with `MainShell` (bottom navigation)
- Routes instantiate their own BLoCs using `BlocFactory`
- **Constructor-based BLoC initialization**: BLoCs receive their dependencies (like entity IDs) via constructor
  - Example: `DiscountDetailBloc(discountId: id, getDetailUsecase: sl())`
- **NoTransitionPage** for tab navigation to prevent animations

### State Management
- **flutter_bloc** for state management
- **Freezed** for immutable state classes and events
- BLoC structure per page/feature:
  ```
  presentation/blocs/[page_name]/
  ├── [name]_bloc.dart        # Business logic
  ├── [name]_event.dart       # Events (freezed)
  ├── [name]_state.dart       # States (freezed)
  └── bloc.dart               # Barrel export
  ```

#### State Pattern: Status Enum + Data (Not Sealed Unions)

This codebase uses a **single state class with status field** pattern instead of sealed union states.

**✅ CORRECT PATTERN - Status Enum + Data:**
```dart
import '../../../../../core/base_types/loading_status.dart';

@freezed
sealed class DiscountsListState with _$DiscountsListState {
  const factory DiscountsListState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<Discount> discounts,
    @Default(0) int currentPage,
    @Default(true) bool hasMorePages,
    String? errorMessage,
  }) = _DiscountsListState;
}
```

**❌ WRONG PATTERN - Sealed Union States (DO NOT USE):**
```dart
@freezed
class DiscountsListState with _$DiscountsListState {
  const factory DiscountsListState.initial() = DiscountsListInitial;
  const factory DiscountsListState.loading() = DiscountsListLoading;
  const factory DiscountsListState.loaded({...}) = DiscountsListLoaded;
  const factory DiscountsListState.error(String message) = DiscountsListError;
}
```

**Why Status Enum + Data Pattern:**
1. **No Data Loss**: Filters, pagination, and search persist through loading states
2. **75% Less Boilerplate**: Direct property access instead of `state.maybeWhen(loaded: (data) => ..., orElse: () => {})`
3. **Simpler State Transitions**: `emit(state.copyWith(status: LoadingStatus.loading))` instead of complex state matching
4. **Action Flags**: Use boolean flags for actions in progress (e.g., `isSubmitting`, `isCanceling`)

**State Fields Pattern:**
- `status`: Always use `LoadingStatus` enum (initial, loading, success, error)
- `errorMessage`: Optional String, populated when `status == LoadingStatus.error`
- **Data fields**: Lists, entities, etc. with `@Default()` values (preserve across status changes)
- **Action flags**: Boolean fields for actions in progress (e.g., `isSubmitting`, `isLoadingMore`)

**BLoC Implementation Pattern:**
```dart
class DiscountsListBloc extends Bloc<DiscountsListEvent, DiscountsListState> {
  DiscountsListBloc(...) : super(const DiscountsListState()) {
    on<LoadDiscounts>(_onLoadDiscounts);
  }

  Future<void> _onLoadDiscounts(
    LoadDiscounts event,
    Emitter<DiscountsListState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await _getDiscountsUsecase(category: state.category);

    result.fold(
      (error) => emit(state.copyWith(
        status: LoadingStatus.error,
        errorMessage: error.message,
      )),
      (discounts) => emit(state.copyWith(
        status: LoadingStatus.success,
        discounts: discounts,
      )),
    );
  }
}
```

**UI Pattern - Direct Property Access:**
```dart
BlocBuilder<DiscountsListBloc, DiscountsListState>(
  builder: (context, state) {
    if (state.status == LoadingStatus.loading) {
      return const CircularProgressIndicator();
    }

    if (state.status == LoadingStatus.error) {
      return ErrorWidget(message: state.errorMessage ?? 'Unknown error');
    }

    // Access data directly - no .maybeWhen() needed
    return ListView.builder(
      itemCount: state.discounts.length,
      itemBuilder: (context, index) => DiscountCard(state.discounts[index]),
    );
  },
)
```

**Action Flags Pattern:**
When you need to track specific actions in progress (e.g., form submission, cancellation), use boolean flags:

```dart
@freezed
sealed class ApplicationFormState with _$ApplicationFormState {
  const factory ApplicationFormState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    ApplicationForm? applicationForm,
    @Default(false) bool isSubmitting,  // ✅ Action flag
    String? errorMessage,
  }) = _ApplicationFormState;
}
```

In BLoC:
```dart
Future<void> _onSubmitForm(
  SubmitForm event,
  Emitter<ApplicationFormState> emit,
) async {
  emit(state.copyWith(isSubmitting: true));

  final result = await _createApplicationUsecase(event.params);

  result.fold(
    (error) => emit(state.copyWith(
      status: LoadingStatus.error,
      isSubmitting: false,
      errorMessage: error.message,
    )),
    (_) => emit(state.copyWith(
      status: LoadingStatus.success,
      isSubmitting: false,
    )),
  );
}
```

In UI (listen only to action completion):
```dart
BlocListener<ApplicationFormBloc, ApplicationFormState>(
  listenWhen: (previous, current) {
    // Only listen when transitioning FROM submitting TO not submitting
    return previous.isSubmitting && !current.isSubmitting;
  },
  listener: (context, state) {
    if (state.status == LoadingStatus.success) {
      showDialog(...); // Show success dialog
    } else if (state.status == LoadingStatus.error) {
      showDialog(...); // Show error dialog
    }
  },
  child: ...,
)
```

**Common Action Flags:**
- `isSubmitting` - Form submission in progress
- `isCanceling` - Cancellation action in progress
- `isLoadingMore` - Pagination loading in progress
- `isBooking` - Booking/reservation in progress
- `isRefreshing` - Pull-to-refresh in progress

### Data Layer Patterns
- **Remote data sources**: Define API contracts (abstract class)
- **Repository implementations**: Call data sources, handle Result types
- **Models**: Use freezed + json_serializable for data models
- **Entities**: Freezed immutable domain objects
- Code generation required after model changes

### Result Type and Error Handling
- All repository/data source methods return `Result<T>` (Either from fpdart)
- `Result<T>` is `Either<Exception, T>` where left is error, right is success
- Standard exceptions: `NetworkException`, `MappingException`
- Use `.fold()` to handle success/error in BLoCs

### API Configuration
- Base URL and auth configured in `api_client.dart`
- Environment variables loaded from `.env` file (not in repo)
- Uses Bearer token authentication from `AuthTokenProvider`
- **InsecureApiClient** used by default (bypasses certificate validation)

### Testing
- E2E-style integration tests in `test/src/`
- Test structure: Feature-based test files (e.g., `news_test.dart`, `polls_test.dart`)

## Common Patterns

### Adding a New Feature
1. Create feature folder: `lib/src/features/[feature_name]/`
2. Create layers: `data/`, `domain/`, `presentation/`
3. Define domain entities and repository interface
4. Implement data layer (data sources, models, repository)
5. Create use cases in domain layer
6. Build presentation layer (BLoCs, pages, widgets)
7. Register dependencies in `service_locator.dart`
8. Add BLoC factory methods to `bloc_factory.dart`
9. Add routes to `app_router.dart`
10. Run code generation if using freezed/json_serializable

### Adding a New Page to Existing Feature
1. Create BLoC folder: `presentation/blocs/[page_name]/`
2. Define event, state (using freezed), and bloc files
3. Create page widget in `presentation/pages/`
4. Add factory method in `bloc_factory.dart`
5. Add route in `app_router.dart` using `BlocProvider` with factory

### Working with Detail Pages
- **Pattern**: Detail pages receive their entity ID via constructor parameter to the BLoC
- BLoC constructors take the ID and dependencies (use cases) directly
- Route passes ID from path parameters: `state.pathParameters['id']`
- Load data in BLoC initialization event dispatched in route builder

### Code Generation Workflow
1. Modify or create models/entities with freezed/json annotations
2. Run `flutter pub run build_runner build --delete-conflicting-outputs`
3. Commit both source files and generated `.freezed.dart`/`.g.dart` files

### Shared Functionality
- File operations (upload/download) in `lib/src/shared/files/`
- Comments functionality reusable across commentable entities (news, discounts, polls)
- Dictionaries cache prevents redundant API calls for master data
