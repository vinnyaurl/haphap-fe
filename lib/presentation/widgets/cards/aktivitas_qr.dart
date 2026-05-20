import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapQRCodeCard extends StatelessWidget {
  final String orderId;
  final String qrImagePath;

  const HapHapQRCodeCard({
    super.key,
    required this.orderId,
    required this.qrImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          const Text(
            'No. Pesanan',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.greyDark,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            orderId,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary, 
              letterSpacing: 2, 
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(16), 
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              qrImagePath,
              width: 145, 
              height: 145,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Scan QR Code ke Merchant',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.greyDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}