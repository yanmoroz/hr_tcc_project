import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/domain.dart';

class UnreadNotificationsCubit extends Cubit<int> {
  final GetNotificationsUsecase _getNotificationsUsecase;
  final WatchNotificationsUseCase _watchNotificationsUseCase;
  StreamSubscription<List<Notification>>? _subscription;

  UnreadNotificationsCubit(
    this._getNotificationsUsecase,
    this._watchNotificationsUseCase,
  ) : super(0) {
    _init();
  }

  Future<void> _init() async {
    // Subscribe to stream first
    _subscription = _watchNotificationsUseCase().listen((notifications) {
      if (!isClosed) {
        emit(notifications.where((n) => !n.isRead).length);
      }
    });

    // Then fetch to populate cache (stream will emit after this)
    await _getNotificationsUsecase();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
