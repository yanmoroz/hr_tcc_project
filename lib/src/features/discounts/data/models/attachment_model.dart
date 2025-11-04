import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/domain.dart';

part 'attachment_model.freezed.dart';
part 'attachment_model.g.dart';

@freezed
abstract class AttachmentModel with _$AttachmentModel {
  const factory AttachmentModel({
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
  }) = _AttachmentModel;

  factory AttachmentModel.fromJson(Map<String, dynamic> json) => _$AttachmentModelFromJson(json);
}

extension AttachmentModelX on AttachmentModel {
  Attachment toDomain() => Attachment(
    icon: icon,
    width: width,
    height: height,
    thumbnail: thumbnail,
    id: id,
    name: name,
    url: url,
    folder: folder,
    priority: priority,
    extension: extension,
    size: size,
    createdData: createdData,
    fileType: fileType,
  );
}
