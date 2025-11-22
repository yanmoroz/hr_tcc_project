import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';

import 'current_user_event.dart';
import 'current_user_state.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  final GetCurrentUserInfoUsecase _getCurrentUserInfoUsecase;

  CurrentUserBloc({
    required GetCurrentUserInfoUsecase getCurrentUserInfoUsecase,
  }) : _getCurrentUserInfoUsecase = getCurrentUserInfoUsecase,
       super(const CurrentUserState.initial()) {
    on<LoadCurrentUser>(_onLoadCurrentUser);
    on<RefreshCurrentUser>(_onRefreshCurrentUser);
  }

  Future<void> _onLoadCurrentUser(
    LoadCurrentUser event,
    Emitter<CurrentUserState> emit,
  ) async {
    // Don't show loading if we already have data
    if (state is! CurrentUserLoaded) {
      emit(const CurrentUserState.loading());
    }

    await _loadProfile(emit);
  }

  Future<void> _onRefreshCurrentUser(
    RefreshCurrentUser event,
    Emitter<CurrentUserState> emit,
  ) async {
    await _loadProfile(emit);
  }

  Future<void> _loadProfile(Emitter<CurrentUserState> emit) async {
    final result = await _getCurrentUserInfoUsecase();

    result.fold(
      (error) => emit(CurrentUserState.error(error.toString())),
      (user) => emit(CurrentUserState.loaded(user: user)),
    );
  }
}
