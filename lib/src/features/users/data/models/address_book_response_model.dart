import 'package:freezed_annotation/freezed_annotation.dart';

import 'address_book_user_model.dart';

part 'address_book_response_model.freezed.dart';
part 'address_book_response_model.g.dart';

@freezed
abstract class AddressBookResponseModel with _$AddressBookResponseModel {
  const factory AddressBookResponseModel({
    required List<AddressBookUserModel> employees,
    required int total,
  }) = _AddressBookResponseModel;

  factory AddressBookResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddressBookResponseModelFromJson(json);
}
