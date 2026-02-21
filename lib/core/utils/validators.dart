/// Simple email format validator.
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Email is required.';
  final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!regex.hasMatch(value)) return 'Enter a valid email address.';
  return null;
}

/// Simple non-empty password validator.
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required.';
  if (value.length < 6) return 'Password must be at least 6 characters.';
  return null;
}
