import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_status_pesanan.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_qr.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_detail_pesanan.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_rincian_pembayaran.dart';

import 'package:haphap_fe/data/models/order_model.dart';
import 'package:haphap_fe/data/services/order_service.dart';

class DetailPesananPage extends StatefulWidget {
  final String? orderId;

  const DetailPesananPage({
    super.key,
    this.orderId,
  });

  @override
  State<DetailPesananPage> createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  OrderModel? _order;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  Future<void> _fetchOrder() async {
    if (widget.orderId == null) {
      setState(() {
        _error = 'Order ID tidak ditemukan';
        _isLoading = false;
      });
      return;
    }

    try {
      final order = await OrderService.fetchOrder(widget.orderId!);
      if (!mounted) return;
      setState(() {
        _order = order;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final isYesterday = date.year == now.year && date.month == now.month && date.day == now.day - 1;
    
    final timeStr = '${date.hour.toString().padLeft(2, '0')}.${date.minute.toString().padLeft(2, '0')}';
    
    if (isToday) return 'Hari ini, $timeStr';
    if (isYesterday) return 'Kemarin, $timeStr';
    
    return '${date.day}/${date.month}/${date.year}, $timeStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 59.0, bottom: 8.0),
              child: HapHapPageHeader(title: 'Detail Pesanan'),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _error != null
                      ? Center(child: Text('Error: $_error'))
                      : _order == null
                          ? const Center(child: Text('Pesanan tidak ditemukan'))
                          : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final order = _order!;
    
    String mainTitle = 'Pesanan Diproses';
    String imagePath = 'assets/images/on_process.png';
    String dateStatus = '${_formatDate(order.createdAt)} · Disiapin';

    if (order.status == 'PENDING') {
      mainTitle = 'Menunggu Pembayaran';
      imagePath = 'assets/images/on_process.png'; 
      dateStatus = '${_formatDate(order.createdAt)} · Menunggu';
    } else if (order.isCompleted) {
      mainTitle = 'Pesanan Selesai';
      imagePath = 'assets/images/done.png';
      dateStatus = '${_formatDate(order.createdAt)} · Selesai';
    } else if (order.isCancelled) {
      mainTitle = 'Pesanan Dibatalkan';
      imagePath = 'assets/images/on_process.png'; 
      dateStatus = '${_formatDate(order.createdAt)} · Dibatalkan';
    }

    final avatar = (order.merchant?.avatar != null && order.merchant!.avatar!.isNotEmpty) 
        ? order.merchant!.avatar! 
        : 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=100';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          HapHapStatusPesananCard(
            dateStatusText: dateStatus,
            mainTitle: mainTitle,
            imagePath: imagePath,
          ),

          const SizedBox(height: 32),

          if (order.status == 'PENDING' || order.status == 'PAID') ...[
            Center( 
              child: HapHapQRCodeCard(
                orderId: order.orderId,
                qrImagePath: 'assets/images/qr_code.png', // QR dummy UI as fallback
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
            restaurantName: order.merchant?.merchantName ?? 'Merchant',
            restaurantLogoUrl: avatar,
            items: order.orderItems.map((item) => HapHapOrderItem(
              name: item.name,
              description: '', // Optional description if available
              price: 'Rp ${_formatPrice(item.discountPrice)}',
              quantity: item.quantity,
            )).toList(),
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
            paymentMethod: 'Tunai di Kasir', // Or map from order if added later
            totalPrice: 'Rp ${_formatPrice(order.totalAmount)}',
            orderNumber: order.orderId,
            paymentTime: order.paidAt != null ? _formatDate(order.paidAt!) : '-',
            completionTime: order.completedAt != null ? _formatDate(order.completedAt!) : '-',
            onReceiptPressed: () {
              // Add receipt logic if needed
            },
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}