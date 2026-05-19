import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/data/models/auth_response_model.dart';

class AuthService {
  /// POST /api/auth/login
  /// Body: { email, password }
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final json = await ApiClient.post('/auth/login', {
      'email': email,
      'password': password,
    });
    return AuthResponse.fromJson(json);
  }

  /// POST /api/auth/register
  /// Body: { name, email, password, phone }
  static Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final json = await ApiClient.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    });
    return AuthResponse.fromJson(json);
  }
}