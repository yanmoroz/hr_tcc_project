import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/value_objects/system_type.dart';
import '../../domain/domain.dart';
import '../models/uploading_attachment_state.dart';
import '../widgets/uploading_attachment.dart';

class AttachmentsSandboxPage extends StatefulWidget {
  const AttachmentsSandboxPage({super.key});

  @override
  State<AttachmentsSandboxPage> createState() => _AttachmentsSandboxPageState();
}

class _AttachmentsSandboxPageState extends State<AttachmentsSandboxPage> {
  final ImagePicker _picker = ImagePicker();
  final UploadFileUsecase _uploadFileUsecase = sl<UploadFileUsecase>();
  final List<_UploadingFile> _files = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attachments Sandbox')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _pickAndUploadFiles,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Pick Images'),
            ),
            const SizedBox(height: 24),
            Text(
              'Uploading Files:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _files.isEmpty
                  ? Center(
                      child: Text(
                        'No files selected',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  : Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _files.map((uploadingFile) {
                        return GestureDetector(
                          onLongPress: () {
                            if (uploadingFile.state
                                is! UploadingAttachmentLoading) {
                              _removeFile(uploadingFile);
                            }
                          },
                          child: UploadingAttachment(
                            displayFileName: true,
                            fileName: uploadingFile.name,
                            state: uploadingFile.state,
                            imageFile: uploadingFile.file,
                            onCancel:
                                uploadingFile.state
                                    is UploadingAttachmentLoading
                                ? () => _cancelUpload(uploadingFile)
                                : null,
                            onDelete: () => _removeFile(uploadingFile),
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              'Long press to remove completed/failed uploads',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  void _cancelUpload(_UploadingFile uploadingFile) {
    setState(() {
      uploadingFile.isCancelled = true;
      _files.remove(uploadingFile);
    });
  }

  Future<void> _pickAndUploadFiles() async {
    try {
      final files = await _picker.pickMultiImage();
      if (files.isEmpty) return;

      for (final xFile in files) {
        final uploadingFile = _UploadingFile(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: xFile.name.replaceFirst('image_picker_', 'IMG_'),
          file: File(xFile.path),
        );

        setState(() {
          _files.add(uploadingFile);
        });

        _uploadFile(uploadingFile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking files: $e')));
      }
    }
  }

  void _removeFile(_UploadingFile uploadingFile) {
    setState(() {
      _files.remove(uploadingFile);
    });
  }

  Future<void> _uploadFile(_UploadingFile uploadingFile) async {
    final result = await _uploadFileUsecase(
      file: uploadingFile.file,
      systemType: SystemType.kp,
      group: FileGroup.news,
      onProgress: (sent, total) {
        if (mounted && !uploadingFile.isCancelled) {
          setState(() {
            uploadingFile.state = UploadingAttachmentState.loading(
              progress: sent / total,
            );
          });
        }
      },
    );

    if (!mounted || uploadingFile.isCancelled) return;

    result.fold(
      (failure) {
        setState(() {
          uploadingFile.state = UploadingAttachmentState.error(
            message: failure.toString(),
          );
        });
      },
      (uploadedFile) {
        setState(() {
          uploadingFile.state = UploadingAttachmentState.success(
            fileSize: uploadedFile.size ?? 0,
          );
          print('uploadedFile: $uploadedFile');
        });
      },
    );
  }
}

class _UploadingFile {
  final String id;
  final String name;
  final File file;
  UploadingAttachmentState state = UploadingAttachmentState.loading(
    progress: 0,
  );
  bool isCancelled = false;

  _UploadingFile({required this.id, required this.name, required this.file});
}
