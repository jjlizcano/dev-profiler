import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Handles authentication API calls.
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  const AuthRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } else if (response.statusCode == 401) {
      throw const AuthException('Invalid email or password.');
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<void> logout() async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw const ServerException();
    }
  }
}
