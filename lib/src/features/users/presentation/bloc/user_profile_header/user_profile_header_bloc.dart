import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_current_user_info_usecase.dart';
import 'user_profile_header_event.dart';
import 'user_profile_header_state.dart';

class UserProfileHeaderBloc
    extends Bloc<UserProfileHeaderEvent, UserProfileHeaderState> {
  final GetCurrentUserInfoUsecase _getCurrentUserInfoUsecase;

  UserProfileHeaderBloc({
    required GetCurrentUserInfoUsecase getCurrentUserInfoUsecase,
  })  : _getCurrentUserInfoUsecase = getCurrentUserInfoUsecase,
        super(const UserProfileHeaderState.initial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<RefreshUserProfile>(_onRefreshUserProfile);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<UserProfileHeaderState> emit,
  ) async {
    // Don't show loading if we already have data
    if (state is! UserProfileHeaderLoaded) {
      emit(const UserProfileHeaderState.loading());
    }

    await _loadProfile(emit);
  }

  Future<void> _onRefreshUserProfile(
    RefreshUserProfile event,
    Emitter<UserProfileHeaderState> emit,
  ) async {
    await _loadProfile(emit);
  }

  Future<void> _loadProfile(Emitter<UserProfileHeaderState> emit) async {
    final result = await _getCurrentUserInfoUsecase();

    result.fold(
      (error) => emit(UserProfileHeaderState.error(error.toString())),
      (user) => emit(UserProfileHeaderState.loaded(user: user)),
    );
  }
}
