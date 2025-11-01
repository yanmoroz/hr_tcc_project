import 'package:flutter/material.dart';

import 'poll_item_view_model.dart';

class PollItem extends StatelessWidget {
  final PollItemViewModel viewModel;
  final VoidCallback onTap;

  const PollItem({super.key, required this.viewModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final poll = viewModel.poll;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          decoration: viewModel.decoration,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(poll.title, style: viewModel.titleStyle(theme.textTheme, theme.colorScheme)),
                if (viewModel.shouldShowShortDescription) ...[
                  const SizedBox(height: 8.0),
                  Text(
                    poll.shortDescription,
                    style: viewModel.shortDescriptionStyle(theme.textTheme, theme.colorScheme),
                  ),
                ],
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    if (viewModel.answersCountText != null)
                      Text(
                        viewModel.answersCountText!,
                        style: viewModel.answersCountStyle(theme.textTheme, theme.colorScheme),
                      ),
                    if (viewModel.answersCountText != null && poll.canAnswer)
                      Text(' • ', style: viewModel.separatorStyle(theme.textTheme, theme.colorScheme)),
                    Text(viewModel.statusText, style: viewModel.statusStyle(theme.textTheme, theme.colorScheme)),
                  ],
                ),
                if (viewModel.shouldShowNewBadge) ...[
                  const SizedBox(height: 8.0),
                  Chip(
                    label: const Text('New'),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
