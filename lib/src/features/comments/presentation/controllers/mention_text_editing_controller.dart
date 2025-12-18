import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../g2g/users/users.dart';

/// Represents the context of an active mention being typed.
class MentionContext {
  /// The index of the "@" character in the text.
  final int startIndex;

  /// The query text after "@" (without the "@" symbol).
  final String query;

  MentionContext({required this.startIndex, required this.query});
}

/// A custom [TextEditingController] that styles @mentions with a different color.
///
/// This controller:
/// - Detects when the user is typing a mention (after "@")
/// - Styles completed mentions in [AppColors.blue500]
/// - Provides methods to insert selected users as mentions
class MentionTextEditingController extends TextEditingController {
  /// Pattern to match @mentions.
  /// Matches "@" followed by any characters until whitespace or end of string.
  static final _mentionPattern = RegExp(r'@[^\s@]+');

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final text = this.text;
    if (text.isEmpty) {
      return TextSpan(text: '', style: style);
    }

    final List<InlineSpan> children = [];
    int lastEnd = 0;

    for (final match in _mentionPattern.allMatches(text)) {
      // Add text before mention
      if (match.start > lastEnd) {
        children.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: style,
        ));
      }

      // Add styled mention
      children.add(TextSpan(
        text: match.group(0),
        style: AppTypography.textRegular2.blue500,
      ));

      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < text.length) {
      children.add(TextSpan(
        text: text.substring(lastEnd),
        style: style,
      ));
    }

    if (children.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    return TextSpan(style: style, children: children);
  }

  /// Returns the current mention context if the cursor is within a mention.
  ///
  /// Returns null if:
  /// - The cursor is not positioned in the text
  /// - There is no "@" before the cursor position
  /// - The "@" is followed by a space (completed mention)
  MentionContext? getMentionContext() {
    final cursorPos = selection.baseOffset;
    if (cursorPos < 0 || cursorPos > text.length) return null;

    final textBeforeCursor = text.substring(0, cursorPos);
    final atIndex = textBeforeCursor.lastIndexOf('@');

    if (atIndex == -1) return null;

    // Get the text between "@" and cursor
    final query = textBeforeCursor.substring(atIndex + 1);

    // If there's a space in the query, user is not in mention mode
    // (the mention is already completed)
    if (query.contains(' ')) return null;

    return MentionContext(
      startIndex: atIndex,
      query: query,
    );
  }

  /// Inserts a mention for the selected user.
  ///
  /// Replaces the text from "@" to the cursor position with "@UserName ".
  void insertMention(User user, MentionContext context) {
    final beforeMention = text.substring(0, context.startIndex);
    final afterCursor = selection.baseOffset < text.length
        ? text.substring(selection.baseOffset)
        : '';

    final mentionText = '@${user.title} ';
    final newText = beforeMention + mentionText + afterCursor;

    value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: context.startIndex + mentionText.length,
      ),
    );
  }
}
