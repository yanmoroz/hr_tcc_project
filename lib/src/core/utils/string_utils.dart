/// Returns initials from first name and last name.
///
/// If [firstName] or [lastName] is empty, only the available initial is used.
/// Returns uppercase initials (e.g., "John", "Doe" -> "JD").
String getInitials(String firstName, String lastName) {
  final first = firstName.isNotEmpty ? firstName[0] : '';
  final last = lastName.isNotEmpty ? lastName[0] : '';
  return '$first$last'.toUpperCase();
}

/// Returns initials from a full name string.
///
/// Splits the name by spaces and takes the first letter of the first
/// and second words. If only one word exists, returns single initial.
/// Returns uppercase initials (e.g., "John Doe" -> "JD").
String getInitialsFromFullName(String fullName) {
  final fullNameTrimmed = fullName.replaceAll(RegExp(r'\s+'), ' ').trim();
  final parts = fullNameTrimmed.trim().split(' ');
  if (parts.isEmpty || parts.first.isEmpty) return '';
  if (parts.length == 1) {
    return parts[0][0].toUpperCase();
  }
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}
