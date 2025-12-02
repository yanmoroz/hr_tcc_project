import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'address_book_state.freezed.dart';

@freezed
sealed class AddressBookState with _$AddressBookState {
  const factory AddressBookState({
    /// Status for initial load
    @Default(LoadingStatus.initial) LoadingStatus status,

    /// Status for search operations (keeps UI visible)
    @Default(LoadingStatus.initial) LoadingStatus filteringStatus,

    @Default([]) List<AddressBookUser> users,
    @Default(0) int currentPage,
    @Default(true) bool hasMorePages,
    @Default(false) bool isLoadingMore,
    String? searchQuery,
    String? errorMessage,
  }) = _AddressBookState;
}
