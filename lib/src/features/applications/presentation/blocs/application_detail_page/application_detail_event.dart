import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_detail_event.freezed.dart';

@freezed
class ApplicationDetailEvent with _$ApplicationDetailEvent {
  const factory ApplicationDetailEvent.loadDetail() = LoadDetail;

  const factory ApplicationDetailEvent.cancelApplication() = CancelApplication;
}
