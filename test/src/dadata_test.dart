import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/src/core/dadata/dadata.dart';
import 'helpers/result_helper.dart';

void main() {
  group('DaData', () {
    // Declare late variables for dependency chain
    late DaDataTokenProvider tokenProvider;
    late DaDataClient client;
    late DaDataRemoteDataSource dataSource;
    late DaDataService service;

    // Load .env file once before all tests
    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    // Create fresh instances before each test
    setUp(() {
      tokenProvider = LocalDaDataTokenProvider();
      client = DaDataClient(tokenProvider);
      dataSource = DaDataRemoteDataSourceImpl(client);
      service = DaDataServiceImpl(dataSource);
    });

    // Test 1: Country suggestions
    test('E2E Country Suggestions - Россия', () async {
      final suggestions = await getOrFail(
        service.getCountrySuggestions('Россия'),
      );

      expect(suggestions, isA<List<String>>());
      expect(suggestions, isNotEmpty);
      expect(suggestions.any((s) => s.contains('Россия')), isTrue);
    });

    // Test 2: Address suggestions
    test('E2E Address Suggestions - Россия Никулинская', () async {
      final suggestions = await getOrFail(
        service.getAddressSuggestions('Россия Никулинская'),
      );

      expect(suggestions, isA<List<String>>());
      expect(suggestions, isNotEmpty);
      expect(suggestions.any((s) => s.contains('Никулинская')), isTrue);
    });

    // Test 3: Party suggestions
    test('E2E Party Suggestions - Синхро', () async {
      final suggestions = await getOrFail(
        service.getPartySuggestions('Синхро'),
      );

      expect(suggestions, isA<List<String>>());
      expect(suggestions, isNotEmpty);
      expect(
        suggestions.any((s) => s.toLowerCase().contains('синхро')),
        isTrue,
      );
    });
  });
}
