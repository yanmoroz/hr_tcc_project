import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'polls_list_state.freezed.dart';

@freezed
class PollsListState with _$PollsListState {
  const factory PollsListState.initial() = PollsListInitial;
  const factory PollsListState.loading() = PollsListLoading;
  const factory PollsListState.loaded({required List<Poll> polls, @Default({}) Map<int, Uint8List> coverImages}) =
      PollsListLoaded;
  const factory PollsListState.error(String message) = PollsListError;
}
