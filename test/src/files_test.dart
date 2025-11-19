import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/value_objects/system_type.dart';
import 'package:hr_tcc_project/src/shared/files/files.dart';

import 'helpers/result_helper.dart';

void main() {
  group('Dictionaries', () {
    late AuthTokenProvider authTokenProvider;
    late ApiClient apiClient;
    late FileRemoteDataSource dataSource;
    late FileRepository repository;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = FileRemoteDataSourceImpl(apiClient);
      repository = FileRepositoryImpl(dataSource);
    });

    test('E2E Download', () async {
      final file = await getOrFail(
        repository.downloadFile(
          systemType: SystemType.elma,
          download: false,
          idFile: '019937dc-0be4-7dfd-b15e-d3dbb52778d2',
        ),
      );
      expect(file, isA<Uint8List>());
      AppLogger.d('File: ${file.length} bytes');
    });

    test('E2E Upload', () async {
      final file = await getOrFail(
        repository.uploadFile(
          file: File('test/assets/test_image.png'),
          systemType: SystemType.elma,
          issueIdOrKey: 'MOBHR-132',
        ),
      );
      expect(file, isA<UploadedFile>());
      AppLogger.d('File: ${file.id}');
    });
  });
}
