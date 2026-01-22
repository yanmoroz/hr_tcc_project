import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/users/domain/domain.dart';
import '../../base_types/loading_status.dart';
import '../../entities/current_user.dart';
import 'current_user_event.dart';
import 'current_user_state.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  final GetCurrentUserInfoUsecase _getCurrentUserInfoUsecase;

  CurrentUserBloc({
    required GetCurrentUserInfoUsecase getCurrentUserInfoUsecase,
  }) : _getCurrentUserInfoUsecase = getCurrentUserInfoUsecase,
       super(const CurrentUserState()) {
    on<LoadCurrentUser>(_onLoadCurrentUser);
  }

  Future<void> _onLoadCurrentUser(
    LoadCurrentUser event,
    Emitter<CurrentUserState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadProfile(emit);
  }

  Future<void> _loadProfile(Emitter<CurrentUserState> emit) async {
    final result = await _getCurrentUserInfoUsecase();

    result.fold(
      (error) => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.toString(),
        ),
      ),
      (addressBookUser) {
        final currentUser = CurrentUser(
          id: addressBookUser.id,
          firstName: addressBookUser.firstName,
          lastName: addressBookUser.lastName,
          title: addressBookUser.title,
          position: addressBookUser.position,
          photoExists: addressBookUser.photoExists,
        );
        emit(state.copyWith(status: LoadingStatus.success, user: currentUser));
      },
    );
  }
}
