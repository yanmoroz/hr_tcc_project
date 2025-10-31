import 'package:freezed_annotation/freezed_annotation.dart';

part 'kp_office.freezed.dart';

@freezed
abstract class KpOffice with _$KpOffice {
  const factory KpOffice({required int id, required String name}) = _KpOffice;
}
