import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/application_detail.dart';

part 'application_detail_state.freezed.dart';

@freezed
class ApplicationDetailState with _$ApplicationDetailState {
  const factory ApplicationDetailState.initial() = ApplicationDetailInitial;

  const factory ApplicationDetailState.loading() = ApplicationDetailLoading;

  const factory ApplicationDetailState.loaded(ApplicationDetail detail) =
      ApplicationDetailLoaded;

  const factory ApplicationDetailState.canceling() = ApplicationDetailCanceling;

  const factory ApplicationDetailState.canceled() = ApplicationDetailCanceled;

  const factory ApplicationDetailState.error(String message) =
      ApplicationDetailError;
}
