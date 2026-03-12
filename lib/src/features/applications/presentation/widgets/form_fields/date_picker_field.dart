import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme.dart';

class DatePickerField extends StatefulWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;
  final String? Function(String?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.validator,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  static final _dateFormat = DateFormat('dd.MM.yyyy');
  bool _isOpen = false;
  String? _errorText;

  void _openCalendar() {
    setState(() => _isOpen = true);

    showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CalendarModal(
        selectedDate: widget.selectedDate,
        firstDate: widget.firstDate ?? DateTime(2000),
        lastDate: widget.lastDate ?? DateTime(2100),
      ),
    ).then((pickedDate) {
      if (mounted) setState(() => _isOpen = false);
      if (pickedDate != null) {
        widget.onDateSelected(pickedDate);
        _runValidation(pickedDate);
      }
    });
  }

  void _runValidation(DateTime? date) {
    final text = date != null ? _dateFormat.format(date) : '';
    final error = widget.validator?.call(text);
    if (_errorText != error) {
      setState(() => _errorText = error);
    }
  }

  Border _getBorder() {
    if (_errorText != null) {
      return Border.all(color: AppColors.red500, width: 1);
    }
    return Border.all(
      color: _isOpen ? AppColors.blue300 : AppColors.grey500,
      width: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasDate = widget.selectedDate != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _openCalendar,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: _getBorder(),
            ),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: hasDate
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.label,
                              style: AppTypography.textRegular2.grey700,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _dateFormat.format(widget.selectedDate!),
                              style: AppTypography.textRegular1.black,
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            widget.label,
                            style: AppTypography.textRegular1.grey700,
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.calendar_today_outlined,
                  color: _isOpen ? AppColors.blue300 : AppColors.grey700,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(_errorText!, style: AppTypography.textRegular2.red500),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Calendar bottom sheet modal
// ---------------------------------------------------------------------------

class _CalendarModal extends StatefulWidget {
  final DateTime? selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _CalendarModal({
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_CalendarModal> createState() => _CalendarModalState();
}

class _CalendarModalState extends State<_CalendarModal> {
  late DateTime _displayedMonth;
  DateTime? _selectedDate;

  static const _weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

  static String _monthName(int month) {
    const names = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    return names[month - 1];
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _displayedMonth = DateTime(
      (_selectedDate ?? DateTime.now()).year,
      (_selectedDate ?? DateTime.now()).month,
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  bool _isBeforeFirstDate(DateTime date) {
    final first = widget.firstDate;
    return date.isBefore(DateTime(first.year, first.month, first.day));
  }

  bool _isAfterLastDate(DateTime date) {
    final last = widget.lastDate;
    return date.isAfter(DateTime(last.year, last.month, last.day));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _selectDate(DateTime date) {
    Navigator.pop(context, date);
  }

  List<DateTime?> _buildCalendarDays() {
    final firstDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final lastDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0);

    // Monday = 1, Sunday = 7
    final startWeekday = firstDayOfMonth.weekday; // 1-7
    final leadingEmpty = startWeekday - 1;

    final days = <DateTime?>[];

    // Leading empty cells
    for (var i = 0; i < leadingEmpty; i++) {
      days.add(null);
    }

    // Actual days
    for (var d = 1; d <= lastDayOfMonth.day; d++) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month, d));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = _buildCalendarDays();

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Выберите дату',
                      style: AppTypography.titleBold1.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(
                      Icons.close,
                      color: AppColors.grey700,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Month navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _goToPreviousMonth,
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.chevron_left,
                        color: AppColors.grey700,
                        size: 24,
                      ),
                    ),
                  ),
                  Text(
                    '${_monthName(_displayedMonth.month)} ${_displayedMonth.year}',
                    style: AppTypography.textSemibold1.black,
                  ),
                  GestureDetector(
                    onTap: _goToNextMonth,
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.chevron_right,
                        color: AppColors.grey700,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Weekday headers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _weekdays
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: AppTypography.captionMedium2.grey700,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),

            // Calendar grid
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1,
                children: days.map((date) {
                  if (date == null) return const SizedBox.shrink();

                  final isDisabled =
                      _isBeforeFirstDate(date) || _isAfterLastDate(date);
                  final isSelected =
                      _selectedDate != null && _isSameDay(date, _selectedDate!);
                  final isToday = _isSameDay(date, today);

                  return GestureDetector(
                    onTap: isDisabled ? null : () => _selectDate(date),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.blue500 : null,
                          border: isToday && !isSelected
                              ? Border.all(color: AppColors.blue300, width: 1.5)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: AppTypography.textRegular1.copyWith(
                            color: isDisabled
                                ? AppColors.grey500
                                : isSelected
                                    ? AppColors.white
                                    : AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
