import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/entities.dart';
import '../../bloc/poll_page/poll_detail_bloc.dart';
import '../../bloc/poll_page/poll_detail_event.dart';
import '../../bloc/poll_page/poll_detail_state.dart';
import 'question_widget_factory.dart';

class TableLookupQuestionWidget extends StatefulWidget {
  final Question question;
  final AnswerChangedCallback onAnswerChanged;

  const TableLookupQuestionWidget({super.key, required this.question, required this.onAnswerChanged});

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
    context.read<PollDetailBloc>().add(PollDetailEvent.searchStaff(target: _getStaffTarget(), search: search));
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
    return BlocBuilder<PollDetailBloc, PollDetailState>(
      builder: (context, state) {
        final isSearchingStaff = state.maybeWhen(
          loaded: (pollDetail, isSearchingStaff, staffItems, staffSearchError) => isSearchingStaff,
          orElse: () => false,
        );

        final staffItems = state.maybeWhen(
          loaded: (pollDetail, isSearchingStaff, staffItems, staffSearchError) => staffItems,
          orElse: () => null,
        );

        final staffSearchError = state.maybeWhen(
          loaded: (pollDetail, isSearchingStaff, staffItems, staffSearchError) => staffSearchError,
          orElse: () => null,
        );

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
                suffixIcon: isSearchingStaff
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : null,
              ),
            ),
            if (staffSearchError != null) ...[
              const SizedBox(height: 8.0),
              Text(
                staffSearchError,
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
            if (staffItems != null && staffItems.isNotEmpty && _selectedItem == null) ...[
              const SizedBox(height: 8.0),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: staffItems.length,
                  itemBuilder: (context, index) {
                    final item = staffItems[index];
                    return ListTile(title: Text(item.title), onTap: () => _onItemSelected(item));
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
