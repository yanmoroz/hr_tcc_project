import 'package:flutter_html/flutter_html.dart';

final Map<String, Style> commonHtmlElementStyles = {
  "p": Style(
    margin: Margins.zero,
    padding: HtmlPaddings.zero,
    lineHeight: const LineHeight(1.5),
  ),
  "div": Style(
    margin: Margins.zero,
    padding: HtmlPaddings.zero,
    lineHeight: const LineHeight(1.5),
  ),
  "span": Style(
    margin: Margins.zero,
    padding: HtmlPaddings.zero,
    lineHeight: const LineHeight(1.5),
  ),
  "strong": Style(),
  "b": Style(),
  "em": Style(),
  "i": Style(),
};
