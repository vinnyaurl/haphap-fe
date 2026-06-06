import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/data/models/user_profile_model.dart';
import 'package:http/http.dart';

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
}