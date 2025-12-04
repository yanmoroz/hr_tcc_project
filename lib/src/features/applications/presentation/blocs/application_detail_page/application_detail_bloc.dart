import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';
import 'application_detail_event.dart';
import 'application_detail_state.dart';

class ApplicationDetailBloc
    extends Bloc<ApplicationDetailEvent, ApplicationDetailState> {
  final String applicationId;
  final GetApplicationDetailUsecase getApplicationDetailUsecase;
  final CancelApplicationUsecase cancelApplicationUsecase;

  ApplicationDetailBloc({
    required this.applicationId,
    required this.getApplicationDetailUsecase,
    required this.cancelApplicationUsecase,
  }) : super(const ApplicationDetailState()) {
    on<LoadDetail>(_onLoadDetail);
    on<CancelApplication>(_onCancelApplication);
  }

  Future<void> _onLoadDetail(
    LoadDetail event,
    Emitter<ApplicationDetailState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await getApplicationDetailUsecase(applicationId);

    result.fold(
      (exception) => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: exception.toString(),
        ),
      ),
      (detail) =>
          emit(state.copyWith(status: LoadingStatus.success, detail: detail)),
    );
  }

  Future<void> _onCancelApplication(
    CancelApplication event,
    Emitter<ApplicationDetailState> emit,
  ) async {
    emit(state.copyWith(isCanceling: true));

    final result = await cancelApplicationUsecase(applicationId);

    result.fold(
      (exception) => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: exception.toString(),
          isCanceling: false,
        ),
      ),
      (_) => emit(
        state.copyWith(status: LoadingStatus.success, isCanceling: false),
      ),
    );
  }
}
