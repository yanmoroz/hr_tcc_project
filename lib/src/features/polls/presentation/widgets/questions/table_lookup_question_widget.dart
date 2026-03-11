import 'package:flutter/material.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/string_utils.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import 'question_callbacks.dart';

class _StaffSearchData {
  final List<StaffItem>? items;
  final bool isSearching;
  final String? error;

  const _StaffSearchData({this.items, required this.isSearching, this.error});
}

class TableLookupQuestionWidget extends StatefulWidget {
  final Question question;
  final AnswerChangedCallback onAnswerChanged;
  final StaffSearchCallback onStaffSearch;
  final bool isSearchingStaff;
  final List<StaffItem>? staffItems;
  final String? staffSearchError;

  const TableLookupQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerChanged,
    required this.onStaffSearch,
    required this.isSearchingStaff,
    this.staffItems,
    this.staffSearchError,
  });

  @override
  State<TableLookupQuestionWidget> createState() =>
      _TableLookupQuestionWidgetState();
}

class _TableLookupQuestionWidgetState extends State<TableLookupQuestionWidget> {
  late final ValueNotifier<_StaffSearchData> _staffNotifier;
  StaffItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    _staffNotifier = ValueNotifier(
      _StaffSearchData(
        items: widget.staffItems,
        isSearching: widget.isSearchingStaff,
        error: widget.staffSearchError,
      ),
    );
    _loadStaff();
  }

  @override
  void didUpdateWidget(TableLookupQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.staffItems != widget.staffItems ||
        oldWidget.isSearchingStaff != widget.isSearchingStaff ||
        oldWidget.staffSearchError != widget.staffSearchError) {
      _staffNotifier.value = _StaffSearchData(
        items: widget.staffItems,
        isSearching: widget.isSearchingStaff,
        error: widget.staffSearchError,
      );
    }
  }

  @override
  void dispose() {
    _staffNotifier.dispose();
    super.dispose();
  }

  StaffTarget _getStaffTarget() {
    switch (widget.question.lookupType) {
      case 0:
        return StaffTarget.employee;
      case 1:
        return StaffTarget.department;
      case 2:
        return StaffTarget.organisation;
      default:
        return StaffTarget.employee;
    }
  }

  void _loadStaff({String? search}) {
    widget.onStaffSearch(_getStaffTarget(), search);
  }

  void _onItemSelected(StaffItem item) {
    setState(() => _selectedItem = item);

    final answerId = widget.question.answers.isNotEmpty
        ? widget.question.answers.first.id
        : widget.question.id;
    final pollAnswer = PollAnswer.type2(
      type: 2,
      questionId: widget.question.id,
      answerId: answerId,
      answerData: item.id,
    );
    widget.onAnswerChanged(widget.question, pollAnswer);
  }

  void _openModal() {
    final target = _getStaffTarget();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(ctx).size.height * 0.065),
        child: _StaffSearchModal(
          title: target.displayName,
          staffNotifier: _staffNotifier,
          onSearch: (query) => _loadStaff(search: query.isEmpty ? null : query),
          onSelected: (item) {
            Navigator.pop(ctx);
            _onItemSelected(item);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final target = _getStaffTarget();
    final labelText = 'Выберите ${target.displayName.toLowerCase()}';

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
        GestureDetector(
          onTap: _openModal,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.grey500),
            ),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: _selectedItem != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              labelText,
                              style: AppTypography.textRegular2.grey700,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedItem!.title,
                              style: AppTypography.textRegular1.black,
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            labelText,
                            style: AppTypography.textRegular1.grey700,
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.grey700,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StaffSearchModal extends StatefulWidget {
  final String title;
  final ValueNotifier<_StaffSearchData> staffNotifier;
  final void Function(String query) onSearch;
  final void Function(StaffItem item) onSelected;

  const _StaffSearchModal({
    required this.title,
    required this.staffNotifier,
    required this.onSearch,
    required this.onSelected,
  });

  @override
  State<_StaffSearchModal> createState() => _StaffSearchModalState();
}

class _StaffSearchModalState extends State<_StaffSearchModal> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    widget.onSearch(_searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
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
            const Divider(height: 1, thickness: 1, color: AppColors.grey200),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: AppTextFormField(
                controller: _searchController,
                labelText: 'Поиск',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.grey700,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 1, color: AppColors.grey200),
            Flexible(
              child: ValueListenableBuilder<_StaffSearchData>(
                valueListenable: widget.staffNotifier,
                builder: (context, data, _) {
                  if (data.isSearching) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (data.error != null) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          data.error!,
                          style: AppTypography.textRegular2.red500,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final items = data.items ?? [];
                  if (items.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'Ничего не найдено',
                          style: AppTypography.textRegular1.grey700,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildRows(items),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRows(List<StaffItem> items) {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      rows.add(
        GestureDetector(
          onTap: () => widget.onSelected(item),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: AppTypography.textRegular1.black,
                  ),
                ),
                const SizedBox(width: 12),
                AppRadioButton(
                  value: false,
                  onChanged: (_) => widget.onSelected(item),
                ),
              ],
            ),
          ),
        ),
      );
      if (i < items.length - 1) {
        rows.add(
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.grey200,
            indent: 16,
            endIndent: 16,
          ),
        );
      }
    }
    return rows;
  }
}
