import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/features/resell/domain/domain.dart';

part 'resell_detail_state.freezed.dart';

@freezed
class ResellDetailState with _$ResellDetailState {
  const factory ResellDetailState.initial() = ResellDetailInitial;
  const factory ResellDetailState.loading() = ResellDetailLoading;
  const factory ResellDetailState.loaded(ResellDetail detail) = ResellDetailLoaded;
  const factory ResellDetailState.error(String message) = ResellDetailError;
  const factory ResellDetailState.bookingInProgress() = ResellDetailBookingInProgress;
  const factory ResellDetailState.bookingSuccess() = ResellDetailBookingSuccess;
}
