import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'poll_detail_state.freezed.dart';

@freezed
class PollDetailState with _$PollDetailState {
  const factory PollDetailState.initial() = PollDetailInitial;
  const factory PollDetailState.loading() = PollDetailLoading;
  const factory PollDetailState.loaded({required PollDetail pollDetail}) = PollDetailLoaded;
  const factory PollDetailState.submitting({required PollDetail pollDetail}) = PollDetailSubmitting;
  const factory PollDetailState.submitted({required PollDetail pollDetail}) = PollDetailSubmitted;
  const factory PollDetailState.error(String message) = PollDetailError;
}
