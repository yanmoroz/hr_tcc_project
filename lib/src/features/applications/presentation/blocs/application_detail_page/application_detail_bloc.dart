import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';
import 'application_detail_event.dart';
import 'application_detail_state.dart';

class ApplicationDetailBloc
    extends Bloc<ApplicationDetailEvent, ApplicationDetailState> {
  final GetApplicationDetailUsecase getApplicationDetailUsecase;
  final CancelApplicationUsecase cancelApplicationUsecase;

  String? _currentApplicationId;

  ApplicationDetailBloc({
    required this.getApplicationDetailUsecase,
    required this.cancelApplicationUsecase,
  }) : super(const ApplicationDetailState.initial()) {
    on<LoadDetail>(_onLoadDetail);
    on<CancelApplication>(_onCancelApplication);
  }

  Future<void> _onLoadDetail(
    LoadDetail event,
    Emitter<ApplicationDetailState> emit,
  ) async {
    _currentApplicationId = event.applicationId;
    emit(const ApplicationDetailState.loading());

    final result = await getApplicationDetailUsecase(event.applicationId);

    result.fold(
      (exception) => emit(ApplicationDetailState.error(exception.toString())),
      (detail) => emit(ApplicationDetailState.loaded(detail)),
    );
  }

  Future<void> _onCancelApplication(
    CancelApplication event,
    Emitter<ApplicationDetailState> emit,
  ) async {
    if (_currentApplicationId == null) return;

    emit(const ApplicationDetailState.canceling());

    final result = await cancelApplicationUsecase(_currentApplicationId!);

    result.fold(
      (exception) => emit(ApplicationDetailState.error(exception.toString())),
      (_) => emit(const ApplicationDetailState.canceled()),
    );
  }
}
