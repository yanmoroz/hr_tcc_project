import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/entities/application_form.dart';
import '../../../domain/domain.dart';

import 'application_form_event.dart';
import 'application_form_state.dart';

class ApplicationFormBloc
    extends Bloc<ApplicationFormEvent, ApplicationFormState> {
  final ApplicationForm applicationForm;
  final CreateApplicationUsecase createApplicationUsecase;
  final GetKpAbsenceCategoriesUsecase getKpAbsenceCategoriesUsecase;

  ApplicationFormBloc({
    required this.applicationForm,
    required this.createApplicationUsecase,
    required this.getKpAbsenceCategoriesUsecase,
  }) : super(const ApplicationFormState()) {
    on<LoadFormData>(_onLoadFormData);
    on<SubmitForm>(_onSubmitForm);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onLoadFormData(
    LoadFormData event,
    Emitter<ApplicationFormState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    switch (event.formCode) {
      case 'absence':
        final result = await getKpAbsenceCategoriesUsecase();
        result.fold(
          (exception) => emit(state.copyWith(
            status: LoadingStatus.error,
            errorMessage: exception.toString(),
          )),
          (categories) => emit(state.copyWith(
            status: LoadingStatus.success,
            formCode: 'absence',
            data: categories,
          )),
        );
      case 'alpinaAccess':
        // No data loading needed for AlpinaAccess form
        emit(state.copyWith(
          status: LoadingStatus.success,
          formCode: 'alpinaAccess',
          data: null,
        ));
      default:
        // For forms that don't need data loading
        emit(state.copyWith(
          status: LoadingStatus.success,
          formCode: event.formCode,
          data: null,
        ));
    }
  }

  Future<void> _onSubmitForm(
    SubmitForm event,
    Emitter<ApplicationFormState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    final result = await createApplicationUsecase(event.params);

    result.fold(
      (exception) => emit(state.copyWith(
        status: LoadingStatus.error,
        errorMessage: exception.toString(),
        isSubmitting: false,
      )),
      (application) => emit(state.copyWith(
        status: LoadingStatus.success,
        isSubmitting: false,
      )),
    );
  }

  void _onResetForm(ResetForm event, Emitter<ApplicationFormState> emit) {
    emit(const ApplicationFormState());
  }
}
