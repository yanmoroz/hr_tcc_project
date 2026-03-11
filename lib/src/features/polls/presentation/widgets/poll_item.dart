import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/primary_button.dart';
import 'poll_item_view_model.dart';

class PollItem extends StatelessWidget {
  final PollItemViewModel viewModel;
  final VoidCallback onTap;

  const PollItem({super.key, required this.viewModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimeLabel(),
                const SizedBox(height: 8.0),
                _buildTitle(),
                if (viewModel.shouldShowShortDescription) ...[
                  const SizedBox(height: 8.0),
                  _buildDescription(),
                ],
                const SizedBox(height: 24.0),
                _buildBottomSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (viewModel.hasCoverImage) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: Image.memory(
          viewModel.coverImage!,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTimeLabel() {
    return Text(
      viewModel.timeText,
      style: AppTypography.captionMedium2.copyWith(color: AppColors.grey700),
    );
  }

  Widget _buildTitle() {
    if (viewModel.isActivePoll) {
      return Text(
        viewModel.poll.shortDescription.isNotEmpty
            ? viewModel.poll.shortDescription
            : viewModel.poll.title,
        style: AppTypography.titleSemibold3.copyWith(color: AppColors.black),
      );
    }

    return Text(
      viewModel.poll.title,
      style: AppTypography.titleSemibold3.copyWith(color: AppColors.black),
    );
  }

  Widget _buildDescription() {
    if (viewModel.isActivePoll) {
      return const SizedBox.shrink();
    }

    return Text(
      viewModel.poll.shortDescription,
      style: AppTypography.textRegular2.copyWith(color: AppColors.grey700),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBottomSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStatusChip(),
            const Spacer(),
            _buildAnswersCountChip(),
          ],
        ),
        if (viewModel.shouldShowActionButton) ...[
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Пройти опрос',
              size: PrimaryButtonSize.small,
              style: PrimatyButtonStyle.colored,
              onPressed: onTap,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: viewModel.statusChipBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        viewModel.statusText,
        style: AppTypography.captionMedium2.copyWith(
          color: viewModel.statusChipTextColor,
        ),
      ),
    );
  }

  Widget _buildAnswersCountChip() {
    return Text(
      viewModel.answersCountText,
      style: AppTypography.textRegular2.black,
    );
  }
}
