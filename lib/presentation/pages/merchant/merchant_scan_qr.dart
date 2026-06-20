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

    // The QR data encoded by qr_flutter is just the orderId string.
    // But your backend scanOrder expects both orderId AND qrCode.
    // So the QR payload needs to carry both — see note below.
    final rawValue = barcode!.rawValue!;

    setState(() => _isProcessing = true);

    try {
      // Pass rawValue as qrCode; orderId needs to be known too
      // → depends on what your backend expects as qrCode (see note)
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
              Navigator.pop(context); // close dialog
              if (success) {
                Navigator.pop(context); // go back to beranda merchant
              } else {
                setState(() => _isProcessing = false); // allow retry
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

          // Visual scan guide overlay
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
