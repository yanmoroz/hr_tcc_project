import 'package:freezed_annotation/freezed_annotation.dart';

import 'address_book_user_model.dart';

part 'address_book_response.freezed.dart';
part 'address_book_response.g.dart';

@freezed
abstract class AddressBookResponse with _$AddressBookResponse {
  const factory AddressBookResponse({
    required List<AddressBookUserModel> employees,
    required int total,
  }) = _AddressBookResponse;

  factory AddressBookResponse.fromJson(Map<String, dynamic> json) =>
      _$AddressBookResponseFromJson(json);
}
