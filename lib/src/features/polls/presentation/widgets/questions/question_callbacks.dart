import 'dart:io';

import '../../../../../core/base_types/result.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../../../shared/files/domain/domain.dart';
import '../../../domain/domain.dart';

typedef AnswerChangedCallback =
    void Function(Question question, Object? answer);
typedef StaffSearchCallback = void Function(StaffTarget target, String? search);
typedef FileUploadCallback =
    Future<Result<UploadedFile>> Function({
      required File file,
      required SystemType systemType,
      required void Function(int sent, int total) onProgress,
    });
