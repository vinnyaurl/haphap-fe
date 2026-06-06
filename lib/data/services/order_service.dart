import 'package:haphap_fe/core/network/api_client.dart';

class OrderResponse {
  final String orderId;
  final int totalAmount;
  final String expiredAt;
  final String? qrCode;

  const OrderResponse({
    required this.orderId,
    required this.totalAmount,
    required this.expiredAt,
    this.qrCode,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json['orderId'] as String,
      totalAmount: json['totalAmount'] as int,
      expiredAt: json['expiredAt'] as String,
      qrCode: json['qrCode'] as String?,
    );
  }
}

class OrderService {
  OrderService._();

  static Future<OrderResponse> createOrder({
    required String merchantId,
    required List<Map<String, dynamic>> orderItems,
    String? notes,
  }) async {
    final body = <String, dynamic>{
      'merchantId': merchantId,
      'orderItems': orderItems,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    final response = await ApiClient.post('/orders', body);
    // Backend wraps response in { "data": { ... } }
    final data = response['data'] as Map<String, dynamic>;
    return OrderResponse.fromJson(data);
  }
}