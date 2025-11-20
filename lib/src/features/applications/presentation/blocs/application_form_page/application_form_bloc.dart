import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';

import 'application_form_event.dart';
import 'application_form_state.dart';

class ApplicationFormBloc
    extends Bloc<ApplicationFormEvent, ApplicationFormState> {
  final CreateApplicationUsecase createApplicationUsecase;
  final GetKpAbsenceCategoriesUsecase getKpAbsenceCategoriesUsecase;

  ApplicationFormBloc({
    required this.createApplicationUsecase,
    required this.getKpAbsenceCategoriesUsecase,
  }) : super(const ApplicationFormState.initial()) {
    on<SubmitForm>(_onSubmitForm);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onSubmitForm(
    SubmitForm event,
    Emitter<ApplicationFormState> emit,
  ) async {
    emit(const ApplicationFormState.submitting());

    final result = await createApplicationUsecase(event.params);

    result.fold(
      (exception) => emit(ApplicationFormState.error(exception.toString())),
      (application) => emit(const ApplicationFormState.success()),
    );
  }

  void _onResetForm(ResetForm event, Emitter<ApplicationFormState> emit) {
    emit(const ApplicationFormState.initial());
  }
}
