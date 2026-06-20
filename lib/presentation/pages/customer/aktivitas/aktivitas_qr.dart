import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapQRCodeCard extends StatelessWidget {
  final String orderId;
  final String? qrImagePath; // keep to avoid breaking existing callers

  const HapHapQRCodeCard({
    super.key,
    required this.orderId,
    this.qrImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: orderId,           // ← real payload, no more hardcoded asset
            version: QrVersions.auto,
            size: 200,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            'Tunjukkan ke kasir',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            orderId,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}