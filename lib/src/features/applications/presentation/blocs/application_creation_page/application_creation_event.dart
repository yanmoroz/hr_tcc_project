import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_creation_event.freezed.dart';

@freezed
class ApplicationCreationEvent with _$ApplicationCreationEvent {
  const factory ApplicationCreationEvent.loadApplicationForms() =
      LoadApplicationForms;

  const factory ApplicationCreationEvent.refreshApplicationForms() =
      RefreshApplicationForms;

  const factory ApplicationCreationEvent.filterByGroup(String? groupId) =
      FilterByGroup;

  const factory ApplicationCreationEvent.searchForms(String query) =
      SearchForms;
}
