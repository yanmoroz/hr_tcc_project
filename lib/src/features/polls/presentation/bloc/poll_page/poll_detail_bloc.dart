import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import 'poll_detail_event.dart';
import 'poll_detail_state.dart';

class PollDetailBloc extends Bloc<PollDetailEvent, PollDetailState> {
  final GetPollDetailUsecase getPollDetailUsecase;
  final SubmitPollAnswersUsecase submitPollAnswersUsecase;

  PollDetailBloc({required this.getPollDetailUsecase, required this.submitPollAnswersUsecase})
    : super(const PollDetailState.initial()) {
    on<PollDetailEvent>((event, emit) async {
      await event.when(
        loadPollDetail: (pollId) => _onLoadPollDetail(pollId, emit),
        submitAnswers: (pollId, request) => _onSubmitAnswers(pollId, request, emit),
      );
    });
  }

  Future<void> _onLoadPollDetail(int pollId, Emitter<PollDetailState> emit) async {
    emit(const PollDetailState.loading());

    final result = await getPollDetailUsecase(pollId);

    result.fold(
      (error) => emit(PollDetailState.error(error.message)),
      (pollDetail) => emit(PollDetailState.loaded(pollDetail: pollDetail)),
    );
  }

  Future<void> _onSubmitAnswers(int pollId, PollAnswersRequest request, Emitter<PollDetailState> emit) async {
    final currentState = state.maybeWhen(
      loaded: (pollDetail) => pollDetail,
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
}
