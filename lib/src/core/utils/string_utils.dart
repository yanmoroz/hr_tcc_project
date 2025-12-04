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
