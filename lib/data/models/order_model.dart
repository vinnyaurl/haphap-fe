/// Model untuk data merchant di dalam order response.
/// Backend mengembalikan raw Prisma Merchant include, jadi field-nya pakai [id].
class OrderMerchantInfo {
  final String merchantId;
  final String merchantName;
  final String? avatar;
  final String? address;

  const OrderMerchantInfo({
    required this.merchantId,
    required this.merchantName,
    this.avatar,
    this.address,
  });

  factory OrderMerchantInfo.fromJson(Map<String, dynamic> json) {
    return OrderMerchantInfo(
      merchantId: json['id'] as String,
      merchantName: json['merchantName'] as String? ?? '',
      avatar: json['avatar'] as String?,
      address: json['address'] as String?,
    );
  }
}

/// Model untuk item di dalam order.
class OrderItemModel {
  final String orderItemId;
  final String surplusItemId;
  final String name;
  final int quantity;
  final int discountPrice;
  final int originalPrice;

  const OrderItemModel({
    required this.orderItemId,
    required this.surplusItemId,
    required this.name,
    required this.quantity,
    required this.discountPrice,
    required this.originalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      orderItemId: json['id'] as String,
      surplusItemId: json['surplusItemId'] as String,
      name: json['name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      discountPrice: (json['discountPrice'] as num?)?.toInt() ?? 0,
      originalPrice: (json['originalPrice'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Model utama untuk order.
/// Response dari GET /orders/me, GET /orders/:orderId, dan GET /orders/merchant.
///
/// - GET /orders/me → includes merchant + orderItems (customer POV)
/// - GET /orders/merchant → includes user + orderItems (merchant POV)
/// - GET /orders/:orderId → includes merchant + user + orderItems
///
/// Field [merchant] nullable karena merchant order response tidak include merchant.
/// Field [customerName] diambil dari user.name jika tersedia (merchant order response).
class OrderModel {
  final String orderId;
  final String merchantId;
  final String status;
  final int totalAmount;
  final int totalOriginal;
  final String? qrCode;
  final String? notes;
  final DateTime expiredAt;
  final DateTime? paidAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final OrderMerchantInfo? merchant;
  final String? customerName;
  final List<OrderItemModel> orderItems;

  const OrderModel({
    required this.orderId,
    required this.merchantId,
    required this.status,
    required this.totalAmount,
    required this.totalOriginal,
    this.qrCode,
    this.notes,
    required this.expiredAt,
    this.paidAt,
    this.completedAt,
    required this.createdAt,
    this.merchant,
    this.customerName,
    required this.orderItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Parse merchant info (available in customer POV responses)
    OrderMerchantInfo? merchantInfo;
    if (json['merchant'] != null) {
      merchantInfo = OrderMerchantInfo.fromJson(
          json['merchant'] as Map<String, dynamic>);
    }

    // Parse customer name (available in merchant POV responses)
    String? customerName;
    if (json['user'] != null) {
      final user = json['user'] as Map<String, dynamic>;
      customerName = user['name'] as String?;
    }

    return OrderModel(
      orderId: json['id'] as String,
      merchantId: json['merchantId'] as String,
      status: json['status'] as String? ?? 'PENDING',
      totalAmount: (json['totalAmount'] as num?)?.toInt() ?? 0,
      totalOriginal: (json['totalOriginal'] as num?)?.toInt() ?? 0,
      qrCode: json['qrCode'] as String?,
      notes: json['notes'] as String?,
      expiredAt: DateTime.parse(json['expiredAt'] as String),
      paidAt: json['paidAt'] != null
          ? DateTime.parse(json['paidAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      merchant: merchantInfo,
      customerName: customerName,
      orderItems: (json['orderItems'] as List<dynamic>?)
              ?.map(
                  (e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Apakah order sedang dalam proses (belum selesai/dibatalkan)
  bool get isInProgress => status == 'PENDING' || status == 'PAID';

  /// Apakah order sudah selesai
  bool get isCompleted => status == 'COMPLETED';

  /// Apakah order dibatalkan
  bool get isCancelled => status == 'CANCELLED';
}
