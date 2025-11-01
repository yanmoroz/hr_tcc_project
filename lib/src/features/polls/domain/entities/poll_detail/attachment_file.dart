import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment_file.freezed.dart';

@freezed
abstract class AttachmentFile with _$AttachmentFile {
  const factory AttachmentFile({
    required int id,
    required String name,
    required String url,
    required String folder,
    required String extension,
    required int size,
    required DateTime created,
    required int fileType,
    required String systemType,
    String? icon,
    int? width,
    int? height,
    String? thumbnail,
    int? priority,
  }) = _AttachmentFile;
}
