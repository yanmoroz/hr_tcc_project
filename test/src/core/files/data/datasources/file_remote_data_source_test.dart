import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/shared/files/data/datasources/data_sources.dart';
import 'package:hr_tcc_project/src/shared/files/domain/entities/entities.dart';
import '../../../../../../lib/src/core/types/result.dart';

void main() {
  group('FileRemoteDataSource', () {
    late FileRemoteDataSource dataSource;
    late ApiClient apiClient;
    late AuthTokenProvider authTokenProvider;

    setUpAll(() async {
      // Load environment variables for testing
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      // Create real instances (no mocks)
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = FileRemoteDataSourceImpl(apiClient);
    });

    group('downloadFile', () {
      test('should download ELMA file using idFile from API and return binary data', () async {
        // Arrange - Use a valid ELMA file ID (UUID format)
        // Note: Replace with a valid file ID from your test environment
        const elmaFileId = '019937dc-0be4-7dfd-b15e-d3dbb52778d2';

        // Act
        final result = await dataSource.downloadFile(systemType: SystemType.elma, download: true, idFile: elmaFileId);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (fileData) {
            // If we get here, the API call succeeded
            expect(fileData, isA<Uint8List>());
            expect(fileData.isNotEmpty, isTrue);

            // Log the actual data for verification
            AppLogger.d('Downloaded ELMA file (idFile): ${fileData.length} bytes');
          },
        );
      });
    });
  });
}
