import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/data/models/auth_response_model.dart';

class AuthService {
  AuthService._();

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

  static Future<String?> signInWithGoogle() async {
    try {

      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      return googleAuth.idToken;
    } catch (e) {
      throw Exception('Google Sign-In gagal: $e');
    }
  }
}