// ============================================================================
// KOMPONEN: KARTU ORDER MERCHANT
// ============================================================================
import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';

enum MerchantOrderStatus { baru, disiapkan, menunggu, selesai }

class HapHapMerchantOrderCard extends StatelessWidget {
  final MerchantOrderStatus status;
  final String customerName;
  final String orderId;
  final List<String> items;
  final String totalPrice;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onReady;

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
  });

  @override
  Widget build(BuildContext context) {
    String badgeText = '';
    Color badgeColor = Colors.transparent;
    Color badgeBgColor = Colors.transparent;

    switch (status) {
      case MerchantOrderStatus.baru:
        badgeText = 'BARU';
        badgeColor = Colors.red;
        badgeBgColor = const Color(0xFFFFEBEB);
        break;
      case MerchantOrderStatus.disiapkan:
        badgeText = 'SEDANG DISIAPKAN';
        badgeColor = const Color(0xFFF2994A); 
        badgeBgColor = const Color(0xFFFFF6ED);
        break;
      case MerchantOrderStatus.menunggu:
        badgeText = 'MENUNGGU PENGAMBILAN';
        badgeColor = Colors.red;
        badgeBgColor = const Color(0xFFFFEBEB);
        break;
      case MerchantOrderStatus.selesai:
        badgeText = 'SELESAI';
        badgeColor = Colors.green;
        badgeBgColor = const Color(0xFFE8F5E9);
        break;
    }

    return Container(
      // RAHASIA PRESISI: Padding cuma atas bawah, kiri kanan nol biar garis bisa mentok
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
          // 1. BADGE & INFO CUSTOMER (Dikasih padding kiri-kanan manual)
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
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      orderId,
                      style: const TextStyle(fontSize: 12, color: AppColors.greyLight),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1), // Garis Mentok Ujung!
          const SizedBox(height: 16),

          // 2. LIST MAKANAN
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Text('1x', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(item, style: const TextStyle(fontSize: 12, color: AppColors.black)),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),

          const SizedBox(height: 8), // Jarak tambahan biar genap 16px sebelum garis
          const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
          const SizedBox(height: 16), // Jarak simetris persis di atas tulisan Total

          // 3. TOTAL PESANAN (Sekarang beneran di tengah-tengah!)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pesanan', style: TextStyle(fontSize: 12, color: AppColors.greyDark)),
                Text(totalPrice, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.black)),
              ],
            ),
          ),

          // 4. TOMBOL AKSI
          if (status == MerchantOrderStatus.baru) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    // Tombol TOLAK pakai outline
                    child: HapHapButton(
                      text: 'Tolak',
                      isOutline: true, 
                      onPressed: onReject ?? () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    // Tombol TERIMA pakai full color (default)
                    child: HapHapButton(
                      text: 'Terima',
                      onPressed: onAccept ?? () {},
                    ),
                  ),
                ],
              ),
            ),
          ] else if (status == MerchantOrderStatus.disiapkan) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerRight, // Tetap di kanan
                child: SizedBox(
                  width: 140, // Lebar dibatasi agar tidak membentang full
                  // Tombol SIAP AMBIL pakai full color (default)
                  child: HapHapButton(
                    text: 'Siap Ambil',
                    onPressed: onReady ?? () {},
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}