import 'package:freezed_annotation/freezed_annotation.dart';

part 'alpina_digital_prev_access.freezed.dart';

@freezed
abstract class AlpinaDigitalPrevAccess with _$AlpinaDigitalPrevAccess {
  const factory AlpinaDigitalPrevAccess({required String id, required String code, required String name}) =
      _AlpinaDigitalPrevAccess;
}
