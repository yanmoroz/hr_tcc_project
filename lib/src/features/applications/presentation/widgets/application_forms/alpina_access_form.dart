import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';
import '../../blocs/application_form_page/bloc.dart';
import '../form_fields/date_picker_field.dart';
import '../form_fields/comment_field.dart';
import '../form_fields/info_box.dart';

class AlpinaAccessForm extends StatefulWidget {
  final void Function(AlpinaDigitalAccessParams?) onFormChanged;

  const AlpinaAccessForm({super.key, required this.onFormChanged});

  @override
  State<AlpinaAccessForm> createState() => _AlpinaAccessFormState();
}

class _AlpinaAccessFormState extends State<AlpinaAccessForm> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

  DateTime? _selectedDate;
  String? _prevAccessCode;
  bool _showComment = false;
  bool _agreementAccepted = false;

  // Map radio button selection to code values
  static const String _yesCode = 'yes';
  static const String _noCode = 'no';

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _updateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate != null &&
          _prevAccessCode != null &&
          _agreementAccepted) {
        final params = AlpinaDigitalAccessParams(
          desiredStartDate: _selectedDate!.toUtc().toIso8601String(),
          alpinaDigitalPrevAccessCode: _prevAccessCode!,
          comment: _showComment && _commentController.text.isNotEmpty
              ? _commentController.text
              : null,
          agreementAcceptance: _agreementAccepted,
        );
        widget.onFormChanged(params);
      } else {
        widget.onFormChanged(null);
      }
    } else {
      widget.onFormChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationFormBloc, ApplicationFormState>(
      builder: (context, state) {
        return state.when(
          initial: () {
            // Trigger loading for consistency (will immediately return success)
            context.read<ApplicationFormBloc>().add(
              const ApplicationFormEvent.loadFormData('alpinaAccess'),
            );
            return const Center(child: CircularProgressIndicator());
          },
          loadingData: () => const Center(child: CircularProgressIndicator()),
          dataLoaded: (formCode, _) {
            // AlpinaAccess doesn't need specific data, just render the form
            if (formCode != 'alpinaAccess') {
              return const Center(child: Text('Неверные данные формы'));
            }

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Date field
                  DatePickerField(
                    label: 'Дата',
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                      _updateForm();
                    },
                    validator: (value) {
                      if (_selectedDate == null) {
                        return 'Выберите дату';
                      }
                      return null;
                    },
                    firstDate: DateTime.now(),
                  ),
                  const SizedBox(height: 24),

                  // Radio buttons for previous access
                  const Text(
                    'Был ли ранее вам предоставлен доступ?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Да'),
                          value: _yesCode,
                          groupValue: _prevAccessCode,
                          onChanged: (value) {
                            setState(() {
                              _prevAccessCode = value;
                            });
                            _updateForm();
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Нет'),
                          value: _noCode,
                          groupValue: _prevAccessCode,
                          onChanged: (value) {
                            setState(() {
                              _prevAccessCode = value;
                            });
                            _updateForm();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Toggle for comment
                  SwitchListTile(
                    title: const Text('Добавить комментарий'),
                    value: _showComment,
                    onChanged: (value) {
                      setState(() {
                        _showComment = value;
                        if (!value) {
                          _commentController.clear();
                        }
                      });
                      _updateForm();
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),

                  // Comment field (conditional)
                  if (_showComment) ...[
                    CommentField(
                      label: 'Комментарий',
                      controller: _commentController,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Agreement checkbox
                  CheckboxListTile(
                    title: const Text(
                      'Я ознакомлен(а) с информацией о сроке действия ссылки 24 часа и удалении аккаунта при его неиспользовании более 3 месяцев',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: _agreementAccepted,
                    onChanged: (value) {
                      setState(() {
                        _agreementAccepted = value ?? false;
                      });
                      _updateForm();
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),

                  // Info box
                  const InfoBox(
                    text:
                        'Вам придет письмо со ссылкой для активации доступа к Alpina Digital — перейдите по ней в течении 24 часов, после она станет недействительной. Аккаунт удаляется, если вы не пользуетесь библиотекой более 3 месяцев.',
                  ),
                ],
              ),
            );
          },
          submitting: () => const Center(child: CircularProgressIndicator()),
          success: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 64, color: Colors.green),
                SizedBox(height: 16),
                Text('Заявка успешно создана'),
              ],
            ),
          ),
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Ошибка: $message',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
