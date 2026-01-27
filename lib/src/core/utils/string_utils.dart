String getInitials(String firstName, String lastName) {
  final first = firstName.isNotEmpty ? firstName[0] : '';
  final last = lastName.isNotEmpty ? lastName[0] : '';
  return '$first$last'.toUpperCase();
}

String getInitialsFromFullName(String fullName) {
  final fullNameTrimmed = fullName.replaceAll(RegExp(r'\s+'), ' ').trim();
  final parts = fullNameTrimmed.trim().split(' ');
  if (parts.isEmpty || parts.first.isEmpty) return '';
  if (parts.length == 1) {
    return parts[0][0].toUpperCase();
  }
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

/// Removes HTML tags from a string and decodes HTML entities
String stripHtmlTags(String htmlString) {
  if (htmlString.isEmpty) return htmlString;

  // Remove HTML tags
  final text = htmlString.replaceAll(RegExp(r'<[^>]*>'), '');

  // Decode common HTML entities
  return text
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'")
      .trim();
}
