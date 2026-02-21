import 'package:flutter_test/flutter_test.dart';

import 'package:dev_profiler/core/utils/validators.dart';

void main() {
  group('validateEmail', () {
    test('returns error for empty value', () {
      expect(validateEmail(''), isNotNull);
      expect(validateEmail(null), isNotNull);
    });

    test('returns error for invalid email', () {
      expect(validateEmail('notanemail'), isNotNull);
      expect(validateEmail('missing@domain'), isNotNull);
    });

    test('returns null for valid email', () {
      expect(validateEmail('user@example.com'), isNull);
    });
  });

  group('validatePassword', () {
    test('returns error for empty value', () {
      expect(validatePassword(''), isNotNull);
      expect(validatePassword(null), isNotNull);
    });

    test('returns error when password is shorter than 6 characters', () {
      expect(validatePassword('abc'), isNotNull);
    });

    test('returns null for valid password', () {
      expect(validatePassword('securePass'), isNull);
    });
  });
}
