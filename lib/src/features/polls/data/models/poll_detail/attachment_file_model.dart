import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'attachment_file_model.freezed.dart';
part 'attachment_file_model.g.dart';

@freezed
abstract class AttachmentFileModel with _$AttachmentFileModel {
  const factory AttachmentFileModel({
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
  }) = _AttachmentFileModel;

  factory AttachmentFileModel.fromJson(Map<String, dynamic> json) => _$AttachmentFileModelFromJson(json);
}

extension AttachmentFileModelX on AttachmentFileModel {
  AttachmentFile toDomain() => AttachmentFile(
    id: id,
    name: name,
    url: url,
    folder: folder,
    extension: extension,
    size: size,
    created: created,
    fileType: fileType,
    systemType: systemType,
    icon: icon,
    width: width,
    height: height,
    thumbnail: thumbnail,
    priority: priority,
  );
}

extension AttachmentFileX on AttachmentFile {
  AttachmentFileModel toModel() => AttachmentFileModel(
    id: id,
    name: name,
    url: url,
    folder: folder,
    extension: extension,
    size: size,
    created: created,
    fileType: fileType,
    systemType: systemType,
    icon: icon,
    width: width,
    height: height,
    thumbnail: thumbnail,
    priority: priority,
  );
}
