import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapQRCodeCard extends StatelessWidget {
  final String qrToken;

  const HapHapQRCodeCard({
    super.key,
    required this.qrToken,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
            child: QrImageView(
              data: qrToken,
              version: QrVersions.auto,
              size: 145,
              backgroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Tunjukkan ke kasir',
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