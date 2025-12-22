import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment.freezed.dart';

@freezed
abstract class Attachment with _$Attachment {
  const factory Attachment({
    String? icon,
    int? width,
    int? height,
    String? thumbnail,
    required int id,
    required String name,
    required String url,
    required String folder,
    int? priority,
    required String extension,
    required int size,
    required DateTime createdData,
    required int fileType,
  }) = _Attachment;
}
