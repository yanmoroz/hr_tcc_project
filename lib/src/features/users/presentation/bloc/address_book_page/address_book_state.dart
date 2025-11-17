import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/address_book_user.dart';

part 'address_book_state.freezed.dart';

@freezed
class AddressBookState with _$AddressBookState {
  const factory AddressBookState.initial() = AddressBookInitial;

  const factory AddressBookState.loading() = AddressBookLoading;

  const factory AddressBookState.loaded({
    required List<AddressBookUser> users,
    required int currentPage,
    required bool hasMorePages,
    required bool isLoadingMore,
    String? searchQuery,
  }) = AddressBookLoaded;

  const factory AddressBookState.error(String message) = AddressBookError;
}
