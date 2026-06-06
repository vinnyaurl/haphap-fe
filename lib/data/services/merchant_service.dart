import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/data/models/merchant_model.dart';

class MerchantService {
  MerchantService._();

  static Future<List<MerchantModel>> fetchAll() async {
    final json = await ApiClient.get('/merchants');
    final list = json['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => MerchantModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<MerchantDetailModel> fetchOne(String merchantId) async {
    final json = await ApiClient.get('/merchants/$merchantId');
    return MerchantDetailModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  static Future<MerchantDetailModel> getMe() async {
    final json = await ApiClient.get('/merchants/me');
    return MerchantDetailModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  static Future<MerchantDetailModel> updateMe(Map<String, dynamic> data) async {
    final json = await ApiClient.patch('/merchants/me', data);
    return MerchantDetailModel.fromJson(json['data'] as Map<String, dynamic>);
  }
}