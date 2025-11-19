import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/polls/polls.dart';

import 'helpers/result_helper.dart';

void main() {
  group('Notifications', () {
    late AuthTokenProvider authTokenProvider;
    late ApiClient apiClient;
    late PollRemoteDataSource dataSource;
    late PollRepository repository;
    late GetPollsUsecase getPollsUsecase;
    late GetPollDetailUsecase getPollDetailUsecase;
    late SubmitPollAnswersUsecase submitPollAnswersUsecase;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = PollRemoteDataSourceImpl(apiClient);
      repository = PollRepositoryImpl(dataSource);
      getPollsUsecase = GetPollsUsecase(repository);
      getPollDetailUsecase = GetPollDetailUsecase(repository);
      submitPollAnswersUsecase = SubmitPollAnswersUsecase(repository);
    });

    test('E2E', () async {
      final polls = await getOrFail(getPollsUsecase(page: 1));
      expect(polls, isA<List<Poll>>());
      AppLogger.d('Fetched polls: ${polls.length} items');

      final pollDetail = await getOrFail(getPollDetailUsecase(123));
      expect(pollDetail, isA<PollDetail>());
      AppLogger.d('Fetched poll detail: ${pollDetail.toString()}');

      await getOrFail(
        submitPollAnswersUsecase(
          pollId: 123,
          answers: [PollAnswer.type1(type: 1, questionId: 471, answerId: 2173)],
        ),
      );
    });
  });
}
