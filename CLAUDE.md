# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Code Generation
```bash
# Generate Freezed and JSON serialization code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation during development
flutter pub run build_runner watch --delete-conflicting-outputs
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

### Linting and Analysis
```bash
# Run static analysis
flutter analyze

# Format code
flutter format lib/ test/
```

### Build
```bash
# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Run the app
flutter run
```

## Architecture Overview

This Flutter project follows **Clean Architecture** with feature-based modular organization. The codebase is divided into three main layers per feature:

### Layer Structure

**Domain Layer** (`domain/`)
- Pure business logic with no framework dependencies
- Contains entities, repository interfaces, use cases, value objects, and parameters
- Entities are immutable using Freezed
- Repository interfaces define contracts for data access

**Data Layer** (`data/`)
- Implementation of domain repository interfaces
- Remote data sources handle API communication via Dio
- Models map API responses to domain entities
- Uses Freezed for immutable models and json_serializable for JSON parsing

**Presentation Layer** (`presentation/`)
- BLoC pattern for state management
- Pages contain UI widgets that listen to BLoC states
- BLoC classes handle events and emit states
- All events and states use Freezed for immutability

### Core Infrastructure (`lib/src/core/`)

**Dependency Injection** (`core/di/service_locator.dart`)
- GetIt service locator pattern
- Repositories and data sources registered as lazy singletons
- Use cases and BLoCs registered as factories
- All dependencies must be registered in `initializeDependencies()`

**Network** (`core/network/`)
- `ApiClient`: Base Dio HTTP client with auth token injection
- `api_call_executor.dart`: Wraps API calls with consistent error handling
- Uses interceptors for logging and authentication

**Error Handling** (`core/base_types/result.dart`)
- Functional approach using fpdart's `Either<Exception, T>`
- Type alias: `Result<T> = Either<Exception, T>`
- All repository methods return `Result<T>` types
- Never throw exceptions from repositories or use cases

**Navigation** (`core/navigation/app_router.dart`)
- GoRouter with shell routes for persistent bottom navigation
- Route parameters parsed from paths (e.g., `/poll/:id`)
- BLoCs created via factory methods with dependencies from service locator

**Dictionaries** (`core/dictionaries/`)
- Master data caching for system-wide reference data
- In-memory cache with lazy loading
- Shared across all features

### Feature Modules (`lib/src/features/`)

Each feature follows this structure:
```
feature/
├── data/
│   ├── datasources/          # API communication
│   ├── models/               # JSON models with .freezed.dart and .g.dart
│   └── repositories/         # Repository implementations
├── domain/
│   ├── entities/             # Business objects (Freezed)
│   ├── repositories/         # Repository interfaces
│   ├── usecases/             # Business logic operations
│   ├── params/               # Parameter objects for use cases
│   └── results/              # Custom result types
└── presentation/
    ├── blocs/                # BLoC state management
    ├── pages/                # UI screens
    └── widgets/              # Reusable UI components
```

Available features: `applications`, `comments`, `discounts`, `news`, `polls`, `resell`, `notifications`, `users`, `home`, `features`

## Key Patterns and Conventions

### Adding a New Feature

1. **Create feature structure** following the standard pattern above
2. **Define domain layer first**: entities, repository interface, use cases
3. **Implement data layer**: models, remote data source, repository implementation
4. **Build presentation layer**: BLoC (events/states), pages, widgets
5. **Register dependencies** in `lib/src/core/di/service_locator.dart`:
   - Data sources as lazy singletons
   - Repositories as lazy singletons
   - Use cases as factories
   - BLoCs as factories (if needed globally)
6. **Run code generation**: `flutter pub run build_runner build --delete-conflicting-outputs`
7. **Add routes** to `lib/src/core/navigation/app_router.dart` if needed

### Working with Freezed Classes

All entities, models, BLoC events, and BLoC states use Freezed:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example.freezed.dart';
part 'example.g.dart'; // Only for JSON serialization

@freezed
class Example with _$Example {
  const factory Example({
    required int id,
    required String name,
  }) = _Example;

  factory Example.fromJson(Map<String, dynamic> json) =>
    _$ExampleFromJson(json);
}
```

After creating/modifying Freezed classes, run code generation.

### Result Type Usage

All async operations that can fail return `Result<T>`:

```dart
Future<Result<List<NewsItem>>> getNewsList() async {
  try {
    final response = await apiClient.get('/news');
    final items = response.data.map((json) => NewsItemModel.fromJson(json).toDomain()).toList();
    return Right(items); // Success
  } on DioException catch (e) {
    return Left(NetworkException.fromDioException(e)); // Failure
  }
}
```

In use cases and BLoCs, handle results with pattern matching:

```dart
final result = await getNewsListUsecase();
result.fold(
  (exception) => emit(NewsListState.error(exception.userFriendlyMessage)),
  (items) => emit(NewsListState.loaded(items)),
);
```

### BLoC State Management

BLoCs follow event-driven patterns:

```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  FeatureBloc({required this.usecase}) : super(const FeatureState.initial()) {
    on<LoadData>(_onLoadData);
  }

  Future<void> _onLoadData(LoadData event, Emitter<FeatureState> emit) async {
    emit(const FeatureState.loading());
    final result = await usecase();
    result.fold(
      (error) => emit(FeatureState.error(error.userFriendlyMessage)),
      (data) => emit(FeatureState.loaded(data)),
    );
  }
}
```

States use sealed classes with Freezed:
```dart
@freezed
class FeatureState with _$FeatureState {
  const factory FeatureState.initial() = _Initial;
  const factory FeatureState.loading() = _Loading;
  const factory FeatureState.loaded(Data data) = _Loaded;
  const factory FeatureState.error(String message) = _Error;
}
```

#### Polymorphic BLoC Pattern

For features with multiple form types or variations (like application forms), use polymorphic event/state handling:

**Event with discriminator:**
```dart
@freezed
class ApplicationFormEvent with _$ApplicationFormEvent {
  const factory ApplicationFormEvent.loadFormData(String formCode) = LoadFormData;
  const factory ApplicationFormEvent.submitForm(CreateApplicationParams params) = SubmitForm;
}
```

**State with generic data:**
```dart
@freezed
class ApplicationFormState with _$ApplicationFormState {
  const factory ApplicationFormState.initial() = _Initial;
  const factory ApplicationFormState.loadingData() = _LoadingData;
  const factory ApplicationFormState.dataLoaded(String formCode, Object? data) = _DataLoaded;
  const factory ApplicationFormState.submitting() = _Submitting;
  const factory ApplicationFormState.success() = _Success;
  const factory ApplicationFormState.error(String message) = _Error;
}
```

**BLoC with switch-based polymorphism:**
```dart
class ApplicationFormBloc extends Bloc<ApplicationFormEvent, ApplicationFormState> {
  final CreateApplicationUsecase createApplicationUsecase;
  final GetCategoriesUsecase getCategoriesUsecase;
  final GetOtherDataUsecase getOtherDataUsecase;

  ApplicationFormBloc({...}) : super(const ApplicationFormState.initial()) {
    on<LoadFormData>(_onLoadFormData);
    on<SubmitForm>(_onSubmitForm);
  }

  Future<void> _onLoadFormData(LoadFormData event, Emitter emit) async {
    emit(const ApplicationFormState.loadingData());

    switch (event.formCode) {
      case 'formTypeA':
        final result = await getCategoriesUsecase();
        result.fold(
          (error) => emit(ApplicationFormState.error(error.toString())),
          (data) => emit(ApplicationFormState.dataLoaded('formTypeA', data)),
        );
      case 'formTypeB':
        final result = await getOtherDataUsecase();
        result.fold(
          (error) => emit(ApplicationFormState.error(error.toString())),
          (data) => emit(ApplicationFormState.dataLoaded('formTypeB', data)),
        );
      default:
        emit(ApplicationFormState.dataLoaded(event.formCode, null));
    }
  }
}
```

**Benefits:**
- Single BLoC handles multiple form types
- Easy to add new form types (just add switch case)
- No event/state explosion
- Maintains clean architecture principles

### API Integration

Remote data sources handle all API communication:

```dart
class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  final ApiClient apiClient;

  @override
  Future<List<FeatureModel>> getItems() async {
    final response = await apiClient.get('/api/endpoint');
    return (response.data as List)
      .map((json) => FeatureModel.fromJson(json))
      .toList();
  }
}
```

The `ApiClient` automatically injects auth tokens and handles logging.

### Model-to-Entity Mapping

Data models convert to domain entities via extension methods:

```dart
extension NewsItemModelMapper on NewsItemModel {
  NewsItem toDomain() {
    return NewsItem(
      id: id,
      title: title,
      // ... map fields
    );
  }
}
```

### Testing

Tests are integration/E2E style, manually constructing dependency chains:

```dart
void main() {
  group('Feature', () {
    late AuthTokenProvider authTokenProvider;
    late ApiClient apiClient;
    late FeatureRemoteDataSource dataSource;
    late FeatureRepository repository;
    late FeatureUsecase usecase;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = FeatureRemoteDataSourceImpl(apiClient);
      repository = FeatureRepositoryImpl(dataSource);
      usecase = FeatureUsecase(repository);
    });

    test('should fetch data', () async {
      final result = await usecase();
      expect(result.isRight(), true);
    });
  });
}
```

Tests require `.env` file with valid API credentials.

## Important Notes

- **Never throw exceptions** from repositories or use cases - always return `Result<T>`
- **Always run code generation** after modifying Freezed classes or JSON models
- **Register all dependencies** in the service locator before using them
- **Use lazy singletons** for repositories and data sources, **factories** for use cases and BLoCs
- **Generated files** (`.freezed.dart`, `.g.dart`) are excluded from analysis and git
- **Environment variables** are loaded from `.env` at app startup via flutter_dotenv
- **Auth tokens** are automatically injected into API requests by the ApiClient interceptor
- **File paths** in comments should use the format `file_path:line_number` for easy navigation
