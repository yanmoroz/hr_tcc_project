import 'package:flutter/material.dart';

import '../../../domain/domain.dart';
import 'question_callbacks.dart';

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
  State<TableLookupQuestionWidget> createState() => _TableLookupQuestionWidgetState();
}

class _TableLookupQuestionWidgetState extends State<TableLookupQuestionWidget> {
  final TextEditingController _searchController = TextEditingController();
  StaffItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    _loadStaff();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  StaffTarget _getStaffTarget() {
    // Map lookupType to StaffTarget
    // Common mappings: 0 = employee, 1 = department, 2 = organisation
    switch (widget.question.lookupType) {
      case 0:
        return StaffTarget.employee;
      case 1:
        return StaffTarget.department;
      case 2:
        return StaffTarget.organisation;
      default:
        return StaffTarget.employee; // Default to employee
    }
  }

  void _loadStaff({String? search}) {
    widget.onStaffSearch(_getStaffTarget(), search);
  }

  void _onSearchChanged() {
    final search = _searchController.text.trim();
    if (search.isEmpty) {
      _loadStaff();
    } else {
      _loadStaff(search: search);
    }
  }

  void _onItemSelected(StaffItem item) {
    setState(() {
      _selectedItem = item;
    });

    // For tableLookup, answerId might be the question's ID or we need a default
    final answerId = widget.question.answers.isNotEmpty ? widget.question.answers.first.id : widget.question.id;
    final pollAnswer = PollAnswer.type2(
      type: 2,
      questionId: widget.question.id,
      answerId: answerId,
      answerData: item.id,
    );
    widget.onAnswerChanged(widget.question, pollAnswer);
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
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Search ${_getStaffTarget().displayName.toLowerCase()}',
            hintText: 'Type to search...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: widget.isSearchingStaff
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : null,
          ),
        ),
        if (widget.staffSearchError != null) ...[
          const SizedBox(height: 8.0),
          Text(
            widget.staffSearchError!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ],
        if (_selectedItem != null) ...[
          const SizedBox(height: 8.0),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              title: Text(_selectedItem!.title),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedItem = null;
                  });
                  widget.onAnswerChanged(widget.question, null);
                },
              ),
            ),
          ),
        ],
        if (widget.staffItems != null && widget.staffItems!.isNotEmpty && _selectedItem == null) ...[
          const SizedBox(height: 8.0),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.staffItems!.length,
              itemBuilder: (context, index) {
                final item = widget.staffItems![index];
                return ListTile(title: Text(item.title), onTap: () => _onItemSelected(item));
              },
            ),
          ),
        ],
      ],
    );
  }
}
