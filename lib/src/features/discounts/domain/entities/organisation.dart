import 'package:freezed_annotation/freezed_annotation.dart';

part 'organisation.freezed.dart';

@freezed
abstract class Organisation with _$Organisation {
  const factory Organisation({required int id, required String title}) =
      _Organisation;
}
