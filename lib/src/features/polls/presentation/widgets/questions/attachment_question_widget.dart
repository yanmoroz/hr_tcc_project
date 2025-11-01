import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/entities.dart';
import 'question_widget_factory.dart';

class AttachmentQuestionWidget extends StatefulWidget {
  final Question question;
  final AnswerChangedCallback onAnswerChanged;

  const AttachmentQuestionWidget({super.key, required this.question, required this.onAnswerChanged});

  @override
  State<AttachmentQuestionWidget> createState() => _AttachmentQuestionWidgetState();
}

class _AttachmentQuestionWidgetState extends State<AttachmentQuestionWidget> {
  final List<XFile> _selectedFiles = [];
  final ImagePicker _picker = ImagePicker();

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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking files: $e')));
      }
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
    _updateAnswer();
  }

  void _updateAnswer() {
    if (_selectedFiles.isEmpty) {
      widget.onAnswerChanged(widget.question, null);
      return;
    }

    // Convert XFile to AttachmentFile
    // Note: In a real app, you'd need to upload these files first
    // For now, we'll create placeholder AttachmentFile objects
    final attachmentFiles = _selectedFiles.asMap().entries.map((entry) {
      final index = entry.key;
      final file = entry.value;
      return AttachmentFile(
        id: index,
        name: file.name,
        url: file.path, // In real app, this would be the uploaded URL
        folder: '',
        extension: file.path.split('.').last,
        size: File(file.path).lengthSync(),
        created: DateTime.now(),
        fileType: 0,
        systemType: 'local',
      );
    }).toList();

    final pollAnswer = PollAnswer.type5(type: 5, questionId: widget.question.id, answerData: attachmentFiles);
    widget.onAnswerChanged(widget.question, pollAnswer);
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
            Expanded(child: Text(widget.question.title, style: Theme.of(context).textTheme.titleMedium)),
            if (widget.question.isRequired == true)
              Chip(
                label: const Text('Required'),
                labelStyle: const TextStyle(fontSize: 10),
                padding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
          ],
        ),
        if (widget.question.comment != null && widget.question.comment!.isNotEmpty) ...[
          const SizedBox(height: 4.0),
          Text(widget.question.comment!, style: Theme.of(context).textTheme.bodySmall),
        ],
        const SizedBox(height: 8.0),
        ElevatedButton.icon(
          onPressed: _pickFiles,
          icon: const Icon(Icons.attach_file),
          label: const Text('Select Files'),
        ),
        if (_selectedFiles.isNotEmpty) ...[
          const SizedBox(height: 16.0),
          Text('Selected Files:', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8.0),
          ..._selectedFiles.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            final fileSize = File(file.path).lengthSync();
            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(file.name),
                subtitle: Text(_formatFileSize(fileSize)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeFile(index),
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}
