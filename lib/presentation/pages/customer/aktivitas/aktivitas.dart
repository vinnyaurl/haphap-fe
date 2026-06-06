import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/navigations/tab_bar.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_proses.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_lainnya.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_riwayat.dart'; 

import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/data/models/order_model.dart';
import 'package:haphap_fe/data/services/order_service.dart';

class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> {
  int _currentTabIndex = 0;
  
  List<OrderModel> _orders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final orders = await OrderService.fetchMyOrders();
      if (!mounted) return;
      setState(() {
        _orders = orders;
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
        bottom: false, // Disamakan agar konsisten
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16), // Jarak atas konsisten

            // 1. HEADER (Sudah pakai komponen)
            _buildHeader(context),

            // KUNCI: Jarak presisi 16px langsung ke Tab Bar (Divider & padding dobel dihapus)
            const SizedBox(height: 16),

            // 2. TAB BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: HapHapTabBar(
                currentIndex: _currentTabIndex,
                onTap: (index) {
                  setState(() {
                    _currentTabIndex = index;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // 3. KONTEN TAB
            Expanded(
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _error != null
                      ? Center(child: Text('Error: $_error'))
                      : _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // WIDGET HELPERS
  // ===========================================================================

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          // HapHapPageHeader dibungkus Expanded agar mengambil sisa ruang di kiri
          const Expanded(
            child: HapHapPageHeader(
              title: 'Aktivitas',
              showBackButton: false, // Ini halaman utama navbar, jadi matikan back-nya
              fontSize: 24,          // Font dibesarkan sesuai desain aslimu
            ),
          ),
          
          // Tombol Laporan Transaksi di kanan
          GestureDetector(
            onTap: () {
              context.push(AppRoutes.laporanTransaksi);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF505050), 
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/icons/circle_arrow_down.svg',
                width: 16,
                height: 16,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.arrow_downward, size: 16, color: AppColors.white);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return _buildProsesTab();
      case 1:
        return _buildRiwayatTab();
      case 2:
        return _buildLainnyaTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildProsesTab() {
    final activeOrders = _orders.where((o) => o.isInProgress).toList();

    if (activeOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/puypuy_laper_nih.png',
              width: 250,
            ),
            const SizedBox(height: 16),
            const Text(
              'Puypuy laper nih... 🥺',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: activeOrders.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == activeOrders.length) return const SizedBox(height: 100);
        
        final order = activeOrders[index];
        final statusText = order.status == 'PENDING' ? 'Menunggu Pembayaran' : 'Pesanan Diproses';
        final mainText = order.status == 'PENDING' ? 'Bayar Sekarang!' : 'Ditunggu...';
        final imagePath = order.status == 'PENDING' ? 'assets/images/aktivitas_puy_waiting1.png' : 'assets/images/aktivitas_puy_processing.png';

        return GestureDetector(
          onTap: () {
            context.push('${AppRoutes.detailPesanan}/${order.orderId}');
          },
          child: HapHapAktivitasCard(
            statusText: statusText,
            mainText: mainText,
            restaurantName: order.merchant.merchantName,
            imagePath: imagePath,
          ),
        );
      },
    );
  }

  Widget _buildRiwayatTab() {
    final historyOrders = _orders.where((o) => o.isCompleted || o.isCancelled).toList();

    if (historyOrders.isEmpty) {
      return const Center(child: Text('Belum ada riwayat pesanan.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: historyOrders.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == historyOrders.length) return const SizedBox(height: 100);
        
        final order = historyOrders[index];
        final statusString = order.status == 'COMPLETED' ? 'Selesai' : 'Dibatalkan';
        final dateStatus = '${_formatDate(order.createdAt)} · $statusString';
        
        // Use placeholder if avatar is null
        final avatar = (order.merchant.avatar != null && order.merchant.avatar!.isNotEmpty) 
            ? order.merchant.avatar! 
            : 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400';

        return GestureDetector(
          onTap: () {
            context.push('${AppRoutes.detailPesanan}/${order.orderId}');
          },
          child: HapHapRiwayatCard(
            imageUrl: avatar, 
            dateStatusText: dateStatus,
            restaurantName: order.merchant.merchantName,
            price: 'Rp ${_formatPrice(order.totalAmount)}',
            buttonText: order.status == 'COMPLETED' ? 'Beri Rating' : 'Pesan Lagi',
            onButtonPressed: () {
              print("Action for order ${order.orderId}");
            },
          ),
        );
      },
    );
  }

  Widget _buildLainnyaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: const [
          HapHapAktivitasLainnyaCard(
            title: 'HapHap lagi ada promo\nspesial nih 😋',
            subtitle: 'Ayo buruan pesan sebelum kehabisan!',
            imagePath: 'assets/images/logo_haphap.png', // Pastikan assetnya ada
          ),
          SizedBox(height: 100), // Jarak aman bawah
        ],
      ),
    );
  }
}