import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/data/models/user_profile_model.dart';

class UserService {
  UserService._();

  static Future<UserProfileModel> getMe() async {
    try {
      final json = await ApiClient.get('/users/me'); 
      
      return UserProfileModel.fromJson(json['data'] ?? json);
    } catch (e) {
      throw Exception('Gagal mengambil data profil: $e');
    }
  }

  /// Update profil user yang sedang login.
  /// Endpoint: PATCH /users/me
  /// Body: { name?, email?, phone? } — semua optional.
  static Future<Map<String, dynamic>> updateMe({
    String? name,
    String? email,
    String? phone,
  }) async {
    final body = <String, dynamic>{
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
    final json = await ApiClient.patch('/users/me', body);
    return json['data'] as Map<String, dynamic>? ?? {};
  }
}