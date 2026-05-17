import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_status_pesanan.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_qr.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_detail_pesanan.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_rincian_pembayaran.dart';

class DetailPesananPage extends StatelessWidget {
  final bool isCompleted;

  const DetailPesananPage({
    super.key,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: HapHapPageHeader(title: 'Detail Pesanan'),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    HapHapStatusPesananCard(
                      dateStatusText: isCompleted 
                          ? 'Hari ini, 06.07 · Diterima' 
                          : 'Hari ini, 06.07 · Disiapin',
                      mainTitle: isCompleted ? 'Pesanan Selesai' : 'Pesanan Diproses',
                      imagePath: isCompleted 
                          ? 'assets/images/done.png' 
                          : 'assets/images/on_process.png',
                    ),

                    const SizedBox(height: 32),

                    if (!isCompleted) ...[
                      const Center( 
                        child: HapHapQRCodeCard(
                          orderId: 'S6I7X6S7E6V7E6N7',
                          qrImagePath: 'assets/images/qr_code.png',
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    const Text(
                      'Detail Pesanan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    HapHapDetailPesananCard(
                      restaurantName: 'Cal\'s Chicken Bowl',
                      restaurantLogoUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=100',
                      items: const [
                        HapHapOrderItem(
                          name: 'Szechuan Chicken Bowl',
                          description: 'Nasi + Ayam Saus Szechuan',
                          price: 'Rp 25.000',
                          quantity: 2,
                        ),
                        HapHapOrderItem(
                          name: 'Blackpepper Chicken Bowl',
                          description: 'Nasi + Ayam Saus Blackpepper',
                          price: 'Rp 25.000',
                          quantity: 2,
                        ),
                        HapHapOrderItem(
                          name: 'Salted Egg Chicken Bowl',
                          description: 'Nasi + Ayam Saus Salted Egg',
                          price: 'Rp 25.000',
                          quantity: 1,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'Rincian Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    HapHapRincianPembayaran(
                      paymentMethod: 'QRIS',
                      totalPrice: 'Rp 125.000',
                      orderNumber: 'S6I7X6S7E6V7E6N7',
                      paymentTime: '6 Juli 2026, 06.07',
                      completionTime: isCompleted ? '7 Juli 2026, 06.07' : '-',
                      onReceiptPressed: () {
                        print("Buka E-Receipt!");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}