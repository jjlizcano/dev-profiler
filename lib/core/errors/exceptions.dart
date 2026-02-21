class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server exception.']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication exception.']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache exception.']);
}
