import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../shared/files/domain/entities/entities.dart';
import '../../../../../shared/files/domain/usecases/usecases.dart';
import '../../../domain/domain.dart';
import 'question_widget_factory.dart';
import '../../../../../core/base_types/result.dart';

class AttachmentQuestionWidget extends StatefulWidget {
  final Question question;
  final AnswerChangedCallback onAnswerChanged;

  const AttachmentQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerChanged,
  });

  @override
  State<AttachmentQuestionWidget> createState() =>
      _AttachmentQuestionWidgetState();
}

class _AttachmentQuestionWidgetState extends State<AttachmentQuestionWidget> {
  final List<XFile> _selectedFiles = [];
  final ImagePicker _picker = ImagePicker();
  final UploadFileUsecase _uploadFileUsecase =
      GetIt.instance<UploadFileUsecase>();
  final Map<int, bool> _uploadingFiles =
      {}; // Track which files are being uploaded
  final Map<int, double> _uploadProgress = {}; // Track upload progress
  final Map<int, AttachmentFile> _uploadedFiles =
      {}; // Track uploaded files by index

  Future<void> _pickFiles() async {
    try {
      final List<XFile> files = await _picker.pickMultiImage();

      if (files.isNotEmpty) {
        setState(() {
          _selectedFiles.addAll(files);
        });
        _updateAnswer();
      }
    } catch (e) {
      // Handle error - user might have canceled or permission denied
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking files: $e')));
      }
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
      _uploadingFiles.remove(index);
      _uploadProgress.remove(index);
      _uploadedFiles.remove(index);
      // Re-index remaining files
      final newUploadingFiles = <int, bool>{};
      final newUploadProgress = <int, double>{};
      final newUploadedFiles = <int, AttachmentFile>{};
      for (var i = 0; i < _selectedFiles.length; i++) {
        if (i < index) {
          if (_uploadingFiles.containsKey(i))
            newUploadingFiles[i] = _uploadingFiles[i]!;
          if (_uploadProgress.containsKey(i))
            newUploadProgress[i] = _uploadProgress[i]!;
          if (_uploadedFiles.containsKey(i))
            newUploadedFiles[i] = _uploadedFiles[i]!;
        } else if (i > index) {
          if (_uploadingFiles.containsKey(i))
            newUploadingFiles[i - 1] = _uploadingFiles[i]!;
          if (_uploadProgress.containsKey(i))
            newUploadProgress[i - 1] = _uploadProgress[i]!;
          if (_uploadedFiles.containsKey(i))
            newUploadedFiles[i - 1] = _uploadedFiles[i]!;
        }
      }
      _uploadingFiles.clear();
      _uploadingFiles.addAll(newUploadingFiles);
      _uploadProgress.clear();
      _uploadProgress.addAll(newUploadProgress);
      _uploadedFiles.clear();
      _uploadedFiles.addAll(newUploadedFiles);
    });
    _updateAnswer();
  }

  Future<void> _uploadFile(XFile file, int index) async {
    setState(() {
      _uploadingFiles[index] = true;
      _uploadProgress[index] = 0.0;
    });

    try {
      final fileToUpload = File(file.path);
      final result = await _uploadFileUsecase(
        file: fileToUpload,
        systemType: SystemType.kp,
        onProgress: (sent, total) {
          if (mounted) {
            setState(() {
              _uploadProgress[index] = sent / total;
            });
          }
        },
      );

      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to upload ${file.name}: ${failure.message}',
                ),
              ),
            );
            setState(() {
              _uploadingFiles[index] = false;
            });
          }
        },
        (uploadedFile) {
          // File uploaded successfully, store it and update the answer
          _updateAnswerWithUploadedFile(uploadedFile, index);
          setState(() {
            _uploadingFiles[index] = false;
            _uploadProgress[index] = 1.0;
          });
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading ${file.name}: $e')),
        );
        setState(() {
          _uploadingFiles[index] = false;
        });
      }
    }
  }

  void _updateAnswerWithUploadedFile(UploadedFile uploadedFile, int index) {
    // Convert UploadedFile (KP system) to AttachmentFile
    uploadedFile.maybeWhen(
      kp:
          (
            id,
            name,
            url,
            folder,
            extension,
            size,
            created,
            fileType,
            icon,
            width,
            height,
            thumbnail,
            priority,
          ) {
            final attachmentFile = AttachmentFile(
              id: id,
              name: name,
              url: url,
              folder: folder,
              extension: extension,
              size: size,
              created: created,
              fileType: fileType,
              systemType: 'KP',
              icon: icon,
              width: width,
              height: height,
              thumbnail: thumbnail,
            );

            // Store uploaded file
            setState(() {
              _uploadedFiles[index] = attachmentFile;
            });

            // Update answer with all uploaded files
            _updateAnswerFromUploadedFiles();
          },
      orElse: () {
        // Only KP files are supported for polls
      },
    );
  }

  void _updateAnswerFromUploadedFiles() {
    // Collect all uploaded files
    final uploadedFiles = _uploadedFiles.values.toList();

    if (uploadedFiles.isEmpty) {
      widget.onAnswerChanged(widget.question, null);
      return;
    }

    // Update the answer with all uploaded files
    final pollAnswer = PollAnswer.type5(
      type: 5,
      questionId: widget.question.id,
      answerData: uploadedFiles,
    );
    widget.onAnswerChanged(widget.question, pollAnswer);
  }

  void _updateAnswer() {
    // Upload all files that haven't been uploaded yet
    for (var i = 0; i < _selectedFiles.length; i++) {
      if (!_uploadingFiles.containsKey(i) || !_uploadingFiles[i]!) {
        if (!_uploadedFiles.containsKey(i)) {
          _uploadFile(_selectedFiles[i], i);
        }
      }
    }

    // Update answer with already uploaded files
    _updateAnswerFromUploadedFiles();
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.question.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (widget.question.isRequired == true)
              Chip(
                label: const Text('Required'),
                labelStyle: const TextStyle(fontSize: 10),
                padding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
          ],
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
        ElevatedButton.icon(
          onPressed: _pickFiles,
          icon: const Icon(Icons.attach_file),
          label: const Text('Select Files'),
        ),
        if (_selectedFiles.isNotEmpty) ...[
          const SizedBox(height: 16.0),
          Text(
            'Selected Files:',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8.0),
          ..._selectedFiles.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            final fileSize = File(file.path).lengthSync();
            final isUploading = _uploadingFiles[index] ?? false;
            final progress = _uploadProgress[index] ?? 0.0;

            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                leading: isUploading
                    ? CircularProgressIndicator(
                        value: progress > 0 ? progress : null,
                      )
                    : const Icon(Icons.insert_drive_file),
                title: Text(file.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_formatFileSize(fileSize)),
                    if (isUploading)
                      LinearProgressIndicator(value: progress, minHeight: 2),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: isUploading ? null : () => _removeFile(index),
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}
