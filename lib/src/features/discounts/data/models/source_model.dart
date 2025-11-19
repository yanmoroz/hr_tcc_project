import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'source_model.freezed.dart';
part 'source_model.g.dart';

@freezed
abstract class SourceModel with _$SourceModel {
  const factory SourceModel({required int id, required String title}) =
      _SourceModel;

  factory SourceModel.fromJson(Map<String, dynamic> json) =>
      _$SourceModelFromJson(json);
}

extension SourceModelX on SourceModel {
  Source toDomain() => Source(id: id, title: title);
}
