// ============================================================================
// KOMPONEN: KARTU ORDER MERCHANT
// ============================================================================
import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/data/models/order_model.dart';

// Penambahan state baru sesuai alur F&B
enum MerchantOrderStatus { menungguBayar, baru, sedangDisiapkan, siapDiambil, selesai, dibatalkan }

class HapHapMerchantOrderCard extends StatelessWidget {
  final MerchantOrderStatus status;
  final String customerName;
  final String orderId;
  final List<OrderItemModel> items;
  final String totalPrice;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onReady;
  final VoidCallback? onScanQR;

  const HapHapMerchantOrderCard({
    super.key,
    required this.status,
    required this.customerName,
    required this.orderId,
    required this.items,
    required this.totalPrice,
    this.onAccept,
    this.onReject,
    this.onReady,
    this.onScanQR,
  });

  @override
  Widget build(BuildContext context) {
    String badgeText = '';
    Color badgeColor = Colors.transparent;
    Color badgeBgColor = Colors.transparent;

    switch (status) {
      case MerchantOrderStatus.menungguBayar:
        badgeText = 'MENUNGGU BAYAR';
        badgeColor = const Color(0xFFF2994A);
        badgeBgColor = const Color(0xFFFFF6ED);
        break;
      case MerchantOrderStatus.baru:
        badgeText = 'BARU';
        badgeColor = Colors.red;
        badgeBgColor = const Color(0xFFFFEBEB);
        break;
      case MerchantOrderStatus.sedangDisiapkan:
        badgeText = 'SEDANG DISIAPKAN';
        badgeColor = const Color(0xFFF2994A); 
        badgeBgColor = const Color(0xFFFFF6ED);
        break;
      case MerchantOrderStatus.siapDiambil:
        badgeText = 'SIAP DIAMBIL';
        badgeColor = const Color(0xFF2D9CDB);
        badgeBgColor = const Color(0xFFE8F4FD);
        break;
      case MerchantOrderStatus.selesai:
        badgeText = 'SELESAI';
        badgeColor = Colors.green;
        badgeBgColor = const Color(0xFFE8F5E9);
        break;
      case MerchantOrderStatus.dibatalkan:
        badgeText = 'DIBATALKAN';
        badgeColor = Colors.red;
        badgeBgColor = const Color(0xFFFFEBEB);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F1F1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        customerName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      orderId.length > 8 ? '#${orderId.substring(0, 8)}' : orderId,
                      style: const TextStyle(fontSize: 12, color: AppColors.greyLight),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text(
                      '${item.quantity}x',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(item.name, style: const TextStyle(fontSize: 12, color: AppColors.black)),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 8), 
          const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pesanan', style: TextStyle(fontSize: 12, color: AppColors.greyDark)),
                Text(totalPrice, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black)),
              ],
            ),
          ),

          // LOGIKA RENDER TOMBOL BERDASARKAN STATE
          if (status == MerchantOrderStatus.baru) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: HapHapButton(
                      text: 'Tolak',
                      isOutline: true, 
                      onPressed: onReject ?? () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HapHapButton(
                      text: 'Terima',
                      onPressed: onAccept ?? () {},
                    ),
                  ),
                ],
              ),
            ),
          ] else if (status == MerchantOrderStatus.sedangDisiapkan) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 140,
                  child: HapHapButton(
                    text: 'Siap Ambil',
                    isOutline: true,
                    onPressed: onReady ?? () {},
                  ),
                ),
              ),
            ),
          ] else if (status == MerchantOrderStatus.siapDiambil) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: HapHapButton(
                  text: 'Scan QR Pengambil',
                  onPressed: onScanQR ?? () {},
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}