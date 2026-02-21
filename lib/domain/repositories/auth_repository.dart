import '../entities/user.dart';

abstract class AuthRepository {
  /// Authenticates a user with [email] and [password].
  /// Returns the authenticated [User] on success or throws an exception.
  Future<User> login({required String email, required String password});

  /// Signs out the currently authenticated user.
  Future<void> logout();
}
