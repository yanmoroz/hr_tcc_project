import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/value_objects/system_type.dart';
import '../../../../users/users.dart';
import 'mention_state.dart';

class MentionCubit extends Cubit<MentionState> {
  final GetUsersUsecase _getUsersUsecase;
  Timer? _debounce;

  MentionCubit({required GetUsersUsecase getUsersUsecase})
    : _getUsersUsecase = getUsersUsecase,
      super(const MentionState());

  void clearMention() {
    _debounce?.cancel();
    emit(const MentionState());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  void searchUsers(String query) {
    _debounce?.cancel();

    emit(state.copyWith(status: MentionStatus.loading, query: query));

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final result = await _getUsersUsecase(
        systemType: SystemType.elma,
        search: query,
      );

      if (isClosed) return;

      result.fold(
        (error) => emit(
          state.copyWith(
            status: MentionStatus.error,
            errorMessage: error.toString(),
          ),
        ),
        (users) =>
            emit(state.copyWith(status: MentionStatus.success, users: users)),
      );
    });
  }
}
