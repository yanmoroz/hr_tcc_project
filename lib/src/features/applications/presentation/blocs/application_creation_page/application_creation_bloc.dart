import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dictionaries/domain/domain.dart';
import '../../../../../core/entities/application_form.dart';
import '../../../../../core/entities/application_form_group.dart';

import 'application_creation_event.dart';
import 'application_creation_state.dart';

class ApplicationCreationBloc
    extends Bloc<ApplicationCreationEvent, ApplicationCreationState> {
  final DictionariesRepository _dictionariesRepository;

  ApplicationCreationBloc({
    required DictionariesRepository dictionariesRepository,
  }) : _dictionariesRepository = dictionariesRepository,
       super(const ApplicationCreationState.initial()) {
    on<LoadApplicationForms>(_onLoadApplicationForms);
    on<RefreshApplicationForms>(_onRefreshApplicationForms);
    on<FilterByGroup>(_onFilterByGroup);
    on<SearchForms>(_onSearchForms);
  }

  Future<void> _onLoadApplicationForms(
    LoadApplicationForms event,
    Emitter<ApplicationCreationState> emit,
  ) async {
    emit(const ApplicationCreationState.loading());
    await _loadForms(emit);
  }

  Future<void> _onRefreshApplicationForms(
    RefreshApplicationForms event,
    Emitter<ApplicationCreationState> emit,
  ) async {
    await _loadForms(emit);
  }

  Future<void> _onFilterByGroup(
    FilterByGroup event,
    Emitter<ApplicationCreationState> emit,
  ) async {
    state.maybeWhen(
      loaded: (allForms, groups, _, __, searchQuery) {
        final filteredForms = _applyFilters(
          allForms: allForms,
          groupId: event.groupId,
          searchQuery: searchQuery,
        );

        emit(
          ApplicationCreationState.loaded(
            allForms: allForms,
            groups: groups,
            filteredForms: filteredForms,
            selectedGroupId: event.groupId,
            searchQuery: searchQuery,
          ),
        );
      },
      orElse: () {},
    );
  }

  Future<void> _onSearchForms(
    SearchForms event,
    Emitter<ApplicationCreationState> emit,
  ) async {
    state.maybeWhen(
      loaded: (allForms, groups, _, selectedGroupId, __) {
        final searchQuery = event.query.isEmpty ? null : event.query;
        final filteredForms = _applyFilters(
          allForms: allForms,
          groupId: selectedGroupId,
          searchQuery: searchQuery,
        );

        emit(
          ApplicationCreationState.loaded(
            allForms: allForms,
            groups: groups,
            filteredForms: filteredForms,
            selectedGroupId: selectedGroupId,
            searchQuery: searchQuery,
          ),
        );
      },
      orElse: () {},
    );
  }

  Future<void> _loadForms(Emitter<ApplicationCreationState> emit) async {
    // Load both forms and groups in parallel
    final formsResult = await _dictionariesRepository.getApplicationForms();
    final groupsResult = await _dictionariesRepository
        .getApplicationFormGroups();

    // Check if both succeeded
    final formsError = formsResult.fold((l) => l, (r) => null);
    final groupsError = groupsResult.fold((l) => l, (r) => null);

    if (formsError != null) {
      emit(ApplicationCreationState.error(formsError.toString()));
      return;
    }

    if (groupsError != null) {
      emit(ApplicationCreationState.error(groupsError.toString()));
      return;
    }

    // Extract successful results
    final allForms = formsResult.fold((l) => <ApplicationForm>[], (r) => r);
    final groups = groupsResult.fold((l) => <ApplicationFormGroup>[], (r) => r);

    // TODO: Temporary filter - will be removed in the future
    // Keep only specific form codes
    const allowedFormCodes = {
      'alpinaAccess',
      'courierDelivery',
      'unplannedTraining',
      'referralProgram',
      'violation',
      'absence',
      'businessTrip',
    };
    final filteredForms = allForms
        .where((form) => allowedFormCodes.contains(form.code))
        .toList();

    // Filter out archived forms
    final activeForms = filteredForms.where((form) => !form.archive).toList();

    emit(
      ApplicationCreationState.loaded(
        allForms: activeForms,
        groups: groups,
        filteredForms: activeForms,
        selectedGroupId: null,
        searchQuery: null,
      ),
    );
  }

  List<ApplicationForm> _applyFilters({
    required List<ApplicationForm> allForms,
    String? groupId,
    String? searchQuery,
  }) {
    var filtered = allForms;

    // Apply group filter
    if (groupId != null) {
      filtered = filtered.where((form) => form.idGroup == groupId).toList();
    }

    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final lowerQuery = searchQuery.toLowerCase();
      filtered = filtered
          .where((form) => form.name.toLowerCase().contains(lowerQuery))
          .toList();
    }

    return filtered;
  }
}
