import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/files/entities/uploaded_file.dart';
import '../../../../../core/utils/string_utils.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../../../core/widgets/uploading_attachment/uploading_attachment.dart';
import '../../../../../core/widgets/uploading_attachment/uploading_attachment_state.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../comments/presentation/widgets/attachment_picker_bottom_sheet.dart';
import '../../../domain/domain.dart';
import 'question_callbacks.dart';

class _UploadEntry {
  final String id;
  final File file;
  final String fileName;
  UploadingAttachmentState state;
  AttachmentFile? uploadedFile;

  _UploadEntry({
    required this.id,
    required this.file,
    required this.fileName,
    required this.state,
  });
}

class AttachmentQuestionWidget extends StatefulWidget {
  final Question question;
  final AnswerChangedCallback onAnswerChanged;
  final FileUploadCallback onFileUpload;

  const AttachmentQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerChanged,
    required this.onFileUpload,
  });

  @override
  State<AttachmentQuestionWidget> createState() =>
      _AttachmentQuestionWidgetState();
}

class _AttachmentQuestionWidgetState extends State<AttachmentQuestionWidget> {
  final List<_UploadEntry> _uploads = [];
  final Set<String> _cancelledUploads = {};
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickPhotos() async {
    try {
      final images = await _picker.pickMultiImage();
      if (images.isEmpty) return;
      _addFiles(images.map((xFile) => File(xFile.path)).toList());
    } catch (_) {}
  }

  Future<void> _pickDocuments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result == null || result.files.isEmpty) return;
      final files = result.files
          .where((f) => f.path != null)
          .map((f) => File(f.path!))
          .toList();
      _addFiles(files);
    } catch (_) {}
  }

  void _addFiles(List<File> files) {
    final baseTs = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < files.length; i++) {
      final file = files[i];
      final entry = _UploadEntry(
        id: '${baseTs}_$i',
        file: file,
        fileName: file.path.split('/').last,
        state: const UploadingAttachmentState.loading(progress: 0),
      );
      setState(() => _uploads.add(entry));
      _startUpload(entry);
    }
  }

  Future<void> _startUpload(_UploadEntry entry) async {
    final result = await widget.onFileUpload(
      file: entry.file,
      systemType: SystemType.elma,
      onProgress: (sent, total) {
        if (_cancelledUploads.contains(entry.id)) return;
        if (mounted) {
          setState(() {
            entry.state = UploadingAttachmentState.loading(
              progress: sent / total,
            );
          });
        }
      },
    );

    if (_cancelledUploads.contains(entry.id)) {
      _cancelledUploads.remove(entry.id);
      return;
    }
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          entry.state = UploadingAttachmentState.error(
            message: failure.toString(),
          );
        });
      },
      (uploadedFile) {
        final attachmentFile = _toAttachmentFile(uploadedFile);
        setState(() {
          entry.state = UploadingAttachmentState.success(
            fileSize: uploadedFile.size ?? 0,
          );
          entry.uploadedFile = attachmentFile;
        });
        _updateAnswer();
      },
    );
  }

  AttachmentFile? _toAttachmentFile(UploadedFile uploadedFile) {
    final kpFile = uploadedFile.asKp;
    if (kpFile == null) return null;
    return AttachmentFile(
      id: kpFile.id,
      name: kpFile.name,
      url: kpFile.url,
      folder: kpFile.folder,
      extension: kpFile.extension,
      size: kpFile.size,
      created: kpFile.created,
      fileType: kpFile.fileType,
      systemType: 'KP',
      icon: kpFile.icon,
      width: kpFile.width,
      height: kpFile.height,
      thumbnail: kpFile.thumbnail,
    );
  }

  void _cancelUpload(String id) {
    _cancelledUploads.add(id);
    setState(() => _uploads.removeWhere((e) => e.id == id));
    _updateAnswer();
  }

  void _removeFile(String id) {
    setState(() => _uploads.removeWhere((e) => e.id == id));
    _updateAnswer();
  }

  void _updateAnswer() {
    final uploadedFiles = _uploads
        .where((e) => e.uploadedFile != null)
        .map((e) => e.uploadedFile!)
        .toList();

    if (uploadedFiles.isEmpty) {
      widget.onAnswerChanged(widget.question, null);
      return;
    }

    widget.onAnswerChanged(
      widget.question,
      PollAnswer.type5(
        type: 5,
        questionId: widget.question.id,
        answerData: uploadedFiles,
      ),
    );
  }

  bool _isImageFile(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return const {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif'}
        .contains(ext);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleMedium,
            children: [
              TextSpan(text: stripHtmlTags(widget.question.title)),
              if (widget.question.isRequired == true)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        if (widget.question.comment != null &&
            widget.question.comment!.isNotEmpty) ...[
          const SizedBox(height: 4.0),
          Text(
            widget.question.comment!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 8.0),
        PrimaryButton(
          label: 'Прикрепить файлы',
          icon: Assets.icons.addIcon,
          size: PrimaryButtonSize.large,
          style: PrimatyButtonStyle.white,
          onPressed: () => AttachmentPickerBottomSheet.show(
            context,
            onPickPhoto: _pickPhotos,
            onPickDocument: _pickDocuments,
          ),
        ),
        if (_uploads.isNotEmpty) ...[
          const SizedBox(height: 16.0),
          SizedBox(
            height: 104,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _uploads.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final entry = _uploads[index];
                final isLoading = entry.state is UploadingAttachmentLoading;
                return UploadingAttachment(
                  fileName: entry.fileName,
                  state: entry.state,
                  imageFile: _isImageFile(entry.fileName) ? entry.file : null,
                  displayFileName: false,
                  onCancel: isLoading ? () => _cancelUpload(entry.id) : null,
                  onDelete: isLoading ? null : () => _removeFile(entry.id),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
