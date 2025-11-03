import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';
import '../../../domain/domain.dart';
import 'poll_detail_event.dart';
import 'poll_detail_state.dart';
import '../../../../../core/types/result.dart';

class PollDetailBloc extends Bloc<PollDetailEvent, PollDetailState> {
  final int pollId;
  final GetPollDetailUsecase getPollDetailUsecase;
  final SubmitPollAnswersUsecase submitPollAnswersUsecase;
  final GetStaffUsecase getStaffUsecase;

  PollDetailBloc({
    required this.pollId,
    required this.getPollDetailUsecase,
    required this.submitPollAnswersUsecase,
    required this.getStaffUsecase,
  }) : super(const PollDetailState.initial()) {
    on<PollDetailEvent>((event, emit) async {
      await event.when(
        loadPollDetail: () => _onLoadPollDetail(emit),
        submitAnswers: (request) => _onSubmitAnswers(request, emit),
        searchStaff: (target, search) => _onSearchStaff(target, search, emit),
      );
    });
  }

  Future<void> _onLoadPollDetail(Emitter<PollDetailState> emit) async {
    emit(const PollDetailState.loading());

    final result = await getPollDetailUsecase(pollId);

    result.fold(
      (error) => emit(PollDetailState.error(error.message)),
      (pollDetail) => emit(PollDetailState.loaded(pollDetail: pollDetail)),
    );
  }

  Future<void> _onSubmitAnswers(PollAnswersRequest request, Emitter<PollDetailState> emit) async {
    final currentState = state.maybeWhen(
      loaded: (pollDetail, isSearchingStaff, staffItems, staffSearchError) => pollDetail,
      submitted: (pollDetail) => pollDetail,
      orElse: () => null,
    );

    if (currentState == null) {
      emit(const PollDetailState.error('Poll detail not loaded yet'));
      return;
    }

    emit(PollDetailState.submitting(pollDetail: currentState));

    final result = await submitPollAnswersUsecase(pollId: pollId, request: request);

    result.fold(
      (error) => emit(PollDetailState.error(error.message)),
      (_) => emit(PollDetailState.submitted(pollDetail: currentState)),
    );
  }

  Future<void> _onSearchStaff(StaffTarget target, String? search, Emitter<PollDetailState> emit) async {
    final currentState = state.maybeWhen(
      loaded: (pollDetail, isSearchingStaff, staffItems, staffSearchError) => pollDetail,
      submitted: (pollDetail) => pollDetail,
      submitting: (pollDetail) => pollDetail,
      orElse: () => null,
    );

    if (currentState == null) {
      return;
    }

    emit(PollDetailState.loaded(pollDetail: currentState, isSearchingStaff: true));

    final result = await getStaffUsecase(target: target, search: search);

    result.fold(
      (error) => emit(PollDetailState.loaded(pollDetail: currentState, staffSearchError: error.message)),
      (staffItems) => emit(PollDetailState.loaded(pollDetail: currentState, staffItems: staffItems)),
    );
  }
}
