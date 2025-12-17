import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// A widget that displays text with clickable mentions.
///
/// Mentions are detected in two formats:
/// 1. `<a>` tags (extracts content between <a...> and </a>)
/// 2. `@Name Name Name` (@ followed by up to 3 words)
class MentionRichText extends StatelessWidget {
  final String content;
  final TextStyle? style;
  final Color mentionColor;

  /// Called when a mention is tapped. The mention name is passed.
  final void Function(String mentionName)? onMentionTap;

  const MentionRichText({
    super.key,
    required this.content,
    this.style,
    this.mentionColor = AppColors.blue500,
    this.onMentionTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? AppTypography.textRegular2.black;
    final processedContent = content.replaceAll('&nbsp;', ' ');

    // Extract mentions from HTML <a> tags
    final (processedText, htmlMentions) =
        _extractMentionsFromHtml(processedContent);

    // If we found HTML mentions, use the processed text
    if (htmlMentions.isNotEmpty) {
      return Text.rich(
        TextSpan(
          children: _buildSpansFromHtmlMentions(
            processedText,
            htmlMentions,
            textStyle,
          ),
        ),
      );
    }

    // Fallback: check for @mentions in plain text
    final mentionPattern = RegExp(r'@(\S+(?:\s+\S+){0,2})');
    final matches = mentionPattern.allMatches(processedContent).toList();

    if (matches.isEmpty) {
      return Text(processedContent, style: textStyle);
    }

    return Text.rich(
      TextSpan(
        children: _buildSpansFromPatternMatches(
          processedContent,
          matches,
          textStyle,
        ),
      ),
    );
  }

  List<InlineSpan> _buildSpansFromHtmlMentions(
    String text,
    List<_MentionRange> mentions,
    TextStyle textStyle,
  ) {
    final spans = <InlineSpan>[];
    var lastEnd = 0;

    for (final mention in mentions) {
      if (mention.start > lastEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, mention.start),
            style: textStyle,
          ),
        );
      }

      spans.add(
        TextSpan(
          text: mention.name,
          style: textStyle.copyWith(color: mentionColor),
          recognizer: onMentionTap != null
              ? (TapGestureRecognizer()
                  ..onTap = () => onMentionTap!(mention.name))
              : null,
        ),
      );

      lastEnd = mention.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd), style: textStyle));
    }

    return spans;
  }

  List<InlineSpan> _buildSpansFromPatternMatches(
    String text,
    List<RegExpMatch> matches,
    TextStyle textStyle,
  ) {
    final spans = <InlineSpan>[];
    var lastEnd = 0;

    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: textStyle,
          ),
        );
      }

      final mentionName = match.group(1)!;
      spans.add(
        TextSpan(
          text: mentionName,
          style: textStyle.copyWith(color: mentionColor),
          recognizer: onMentionTap != null
              ? (TapGestureRecognizer()
                  ..onTap = () => onMentionTap!(mentionName))
              : null,
        ),
      );

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd), style: textStyle));
    }

    return spans;
  }

  /// Extracts content from `<a>` tags and removes other HTML tags.
  ///
  /// Returns a tuple of (processedText, mentionRanges) where mentionRanges
  /// contains the start and end indices of each mention in the processed text.
  (String, List<_MentionRange>) _extractMentionsFromHtml(String html) {
    final buffer = StringBuffer();
    final mentions = <_MentionRange>[];

    final anchorPattern = RegExp(r'<a[^>]*>([^<]+)</a>');
    final otherTagPattern = RegExp(r'<[^>]*>');

    var lastEnd = 0;

    for (final match in anchorPattern.allMatches(html)) {
      // Add text before this <a> tag (strip other HTML tags)
      if (match.start > lastEnd) {
        final textBefore = html
            .substring(lastEnd, match.start)
            .replaceAll(otherTagPattern, '');
        buffer.write(textBefore);
      }

      // Add the mention content and track its position
      final mentionName = match.group(1)!;
      final mentionStart = buffer.length;
      buffer.write(mentionName);
      final mentionEnd = buffer.length;

      mentions.add(_MentionRange(
        start: mentionStart,
        end: mentionEnd,
        name: mentionName,
      ));

      lastEnd = match.end;
    }

    // Add remaining text (strip other HTML tags)
    if (lastEnd < html.length) {
      final textAfter = html.substring(lastEnd).replaceAll(otherTagPattern, '');
      buffer.write(textAfter);
    }

    return (buffer.toString(), mentions);
  }
}

class _MentionRange {
  final int start;
  final int end;
  final String name;

  const _MentionRange({
    required this.start,
    required this.end,
    required this.name,
  });
}
