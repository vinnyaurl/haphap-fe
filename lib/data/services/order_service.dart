import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/data/models/order_model.dart';

class OrderService {
  OrderService._();

  /// Fetch semua order milik user yang sedang login.
  /// Endpoint: GET /orders/me
  static Future<List<OrderModel>> fetchMyOrders() async {
    final json = await ApiClient.get('/orders/me');
    final list = json['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch detail satu order berdasarkan ID.
  /// Endpoint: GET /orders/:orderId
  static Future<OrderModel> fetchOrder(String orderId) async {
    final json = await ApiClient.get('/orders/$orderId');
    return OrderModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  /// Buat order baru.
  /// Endpoint: POST /orders
  ///
  /// [merchantId] — ID merchant yang dipesan.
  /// [orderItems] — List of {surplusItemId, quantity}.
  /// [notes] — Catatan opsional.
  ///
  /// Returns response map berisi orderId, totalAmount, expiredAt, qrCode, createdAt.
  static Future<Map<String, dynamic>> createOrder({
    required String merchantId,
    required List<Map<String, dynamic>> orderItems,
    String? notes,
  }) async {
    final body = <String, dynamic>{
      'merchantId': merchantId,
      'orderItems': orderItems,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };
    final json = await ApiClient.post('/orders', body);
    return json['data'] as Map<String, dynamic>? ?? {};
  }

  /// Fetch semua order untuk merchant yang sedang login.
  /// Endpoint: GET /orders/merchant
  static Future<List<OrderModel>> fetchOrderMerchant() async {
    final json = await ApiClient.get('/orders/merchant');
    final list = json['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Scan QR Code untuk menyelesaikan order.
  /// Endpoint: PATCH /orders/:orderId/scan
  static Future<OrderModel> scanOrder(String orderId, String qrCode) async {
    final json = await ApiClient.patch('/orders/$orderId/scan', {
      'qrCode': qrCode,
    });
    return OrderModel.fromJson(json['data'] as Map<String, dynamic>);
  }
}