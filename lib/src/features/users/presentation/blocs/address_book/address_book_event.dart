import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_book_event.freezed.dart';

@freezed
class AddressBookEvent with _$AddressBookEvent {
  const factory AddressBookEvent.loadAddressBook({String? search}) =
      LoadAddressBook;

  const factory AddressBookEvent.refreshAddressBook() = RefreshAddressBook;

  const factory AddressBookEvent.loadMoreAddressBook() = LoadMoreAddressBook;

  const factory AddressBookEvent.searchAddressBook({required String query}) =
      SearchAddressBook;
}
