import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/usecases.dart';
import 'polls_list_event.dart';
import 'polls_list_state.dart';

class PollsListBloc extends Bloc<PollsListEvent, PollsListState> {
  final GetPollsUsecase getPollsUsecase;

  PollsListBloc({required this.getPollsUsecase}) : super(const PollsListState.initial()) {
    on<PollsListEvent>((event, emit) async {
      await event.when(
        loadPolls: (status) => _onLoadPolls(status, emit),
        refreshPolls: (status) => _onRefreshPolls(status, emit),
      );
    });
  }

  Future<void> _onLoadPolls(int? status, Emitter<PollsListState> emit) async {
    emit(const PollsListState.loading());

    final result = await getPollsUsecase(status: status, page: 1);

    result.fold(
      (error) => emit(PollsListState.error(error.message)),
      (polls) => emit(PollsListState.loaded(polls: polls)),
    );
  }

  Future<void> _onRefreshPolls(int? status, Emitter<PollsListState> emit) async {
    final currentState = state.maybeWhen(loaded: (polls) => polls, orElse: () => null);

    if (currentState != null) {
      // Keep showing current polls while refreshing
      emit(PollsListState.loaded(polls: currentState));
    }

    final result = await getPollsUsecase(status: status, page: 1);

    result.fold(
      (error) => emit(PollsListState.error(error.message)),
      (polls) => emit(PollsListState.loaded(polls: polls)),
    );
  }
}
