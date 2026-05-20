import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';

class HapHapRincianPembayaran extends StatelessWidget {
  final String paymentMethod;
  final String totalPrice;
  final String orderNumber;
  final String paymentTime;
  final String completionTime;
  final VoidCallback onReceiptPressed;

  const HapHapRincianPembayaran({
    super.key,
    required this.paymentMethod,
    required this.totalPrice,
    required this.orderNumber,
    required this.paymentTime,
    required this.completionTime,
    required this.onReceiptPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width: 354,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: _cardDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRowItem('Metode Pembayaran', paymentMethod),
              _buildRowItem('Total Harga', totalPrice),
            ],
          ),
        ),

        const SizedBox(height: 12), 

        Container(
          width: 354,
          height: 145,
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              _buildRowItem('No. Pesanan', orderNumber),
              const SizedBox(height: 8),
              _buildRowItem('Waktu Pembayaran', paymentTime),
              const SizedBox(height: 8),
              _buildRowItem('Waktu Pesanan Selesai', completionTime),
              
              const Spacer(),
              
              HapHapButton(
                text: 'Lihat E-Receipt',
                onPressed: onReceiptPressed,
                size: HapHapButtonSize.medium,
                isOutline: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFFF1F1F1),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.black,      
            fontWeight: FontWeight.w600, 
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.greyDark,   
            fontWeight: FontWeight.w400, 
          ),
        ),
      ],
    );
  }
}