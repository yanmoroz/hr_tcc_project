import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';

class PollItem extends StatelessWidget {
  final Poll poll;
  final VoidCallback onTap;

  const PollItem({super.key, required this.poll, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(poll.title, style: Theme.of(context).textTheme.titleLarge),
              if (poll.shortDescription.isNotEmpty) ...[
                const SizedBox(height: 8.0),
                Text(poll.shortDescription, style: Theme.of(context).textTheme.bodyMedium),
              ],
              const SizedBox(height: 8.0),
              Row(
                children: [
                  if (poll.countAnswers > 0)
                    Text('${poll.countAnswers} answers', style: Theme.of(context).textTheme.bodySmall),
                  if (poll.countAnswers > 0 && poll.canAnswer)
                    Text(' • ', style: Theme.of(context).textTheme.bodySmall),
                  if (poll.canAnswer)
                    Text(
                      'Can answer',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  if (!poll.canAnswer)
                    Text(
                      'Cannot answer',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
                    ),
                ],
              ),
              if (poll.isNew) ...[
                const SizedBox(height: 8.0),
                Chip(
                  label: const Text('New'),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
