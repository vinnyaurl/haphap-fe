import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/data/services/order_service.dart';

class MerchantScanQRPage extends StatefulWidget {
  const MerchantScanQRPage({super.key});

  @override
  State<MerchantScanQRPage> createState() => _MerchantScanQRPageState();
}

class _MerchantScanQRPageState extends State<MerchantScanQRPage> {
  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    final rawValue = barcode!.rawValue!;

    setState(() => _isProcessing = true);

    try {
      await OrderService.scanOrder(rawValue, rawValue);
      if (!mounted) return;
      _showResult(success: true, orderId: rawValue);
    } catch (e) {
      if (!mounted) return;
      _showResult(success: false, error: e.toString());
    }
  }

  void _showResult({required bool success, String? orderId, String? error}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(success ? '✅ Pesanan Terverifikasi' : '❌ Gagal'),
        content: Text(
          success ? 'Pesanan $orderId berhasil dikonfirmasi.' : 'Gagal: $error',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              if (success) {
                Navigator.pop(context);
              } else {
                setState(() => _isProcessing = false); 
              }
            },
            child: Text(success ? 'Selesai' : 'Coba Lagi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan QR Pesanan'),
      ),
      body: Stack(
        children: [
          MobileScanner(onDetect: _onDetect),

          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          if (_isProcessing)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}