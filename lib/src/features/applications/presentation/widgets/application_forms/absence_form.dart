import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';
import '../../blocs/application_form_page/bloc.dart';
import '../form_fields/date_picker_field.dart';
import '../form_fields/time_picker_field.dart';
import '../form_fields/comment_field.dart';

class AbsenceForm extends StatefulWidget {
  final void Function(AbsenceParams?) onFormChanged;
  final Widget? titleWidget;

  const AbsenceForm({
    super.key,
    required this.onFormChanged,
    this.titleWidget,
  });

  @override
  State<AbsenceForm> createState() => _AbsenceFormState();
}

class _AbsenceFormState extends State<AbsenceForm> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  int? _category;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String? _buildFromDateTime() {
    if (_selectedDate == null) return null;

    final date = _selectedDate!;
    final time = _selectedTime;

    if (time != null) {
      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      return dateTime.toIso8601String();
    } else {
      return date.toIso8601String();
    }
  }

  void _updateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_category != null && _noteController.text.isNotEmpty) {
        final params = AbsenceParams(
          category: _category!,
          note: _noteController.text,
          fromDateTime: _buildFromDateTime(),
          toDateTime: null, // Not shown in Figma
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
        // Initial state - trigger loading
        if (state.status == LoadingStatus.initial) {
          context.read<ApplicationFormBloc>().add(
            const ApplicationFormEvent.loadFormData('absence'),
          );
          return const Center(child: CircularProgressIndicator());
        }

        // Loading state
        if (state.status == LoadingStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Submitting state
        if (state.isSubmitting) {
          return Form(
            key: _formKey,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // Success state
        if (state.status == LoadingStatus.success &&
            !state.isSubmitting &&
            state.formCode == null) {
          return Form(
            key: _formKey,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text('Заявка успешно создана'),
                ],
              ),
            ),
          );
        }

        // Error state
        if (state.status == LoadingStatus.error) {
          return Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка: ${state.errorMessage ?? 'Unknown error'}',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Data loaded state
        if (state.formCode != 'absence' || state.data == null) {
          return const Center(child: Text('Неверные данные формы'));
        }

        // Cast data to expected type
        final categories = state.data as List<KpAbsenceCategory>;

        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (widget.titleWidget != null) widget.titleWidget!,
              // Category dropdown
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Тип',
                  border: OutlineInputBorder(),
                ),
                initialValue: _category,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Выберите тип отсутствия';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                  _updateForm();
                },
              ),
              const SizedBox(height: 16),

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
              ),
              const SizedBox(height: 16),

              // Time field
              TimePickerField(
                label: 'Время',
                selectedTime: _selectedTime,
                onTimeSelected: (time) {
                  setState(() {
                    _selectedTime = time;
                  });
                  _updateForm();
                },
              ),
              const SizedBox(height: 16),

              // Note field
              CommentField(
                label: 'Причина',
                controller: _noteController,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Укажите причину отсутствия';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
