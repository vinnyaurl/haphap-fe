import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/navigations/tab_bar.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart'; 

// --- IMPORT KOMPONEN HEADER KITA ---
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/data/services/order_service.dart';
import 'package:haphap_fe/data/models/order_model.dart';
import 'package:haphap_fe/presentation/widgets/dialog/merchant_scan_qr_dialog.dart';

class AktivitasMerchantPage extends StatefulWidget {
  const AktivitasMerchantPage({super.key});

  @override
  State<AktivitasMerchantPage> createState() => _AktivitasMerchantPageState();
}

class _AktivitasMerchantPageState extends State<AktivitasMerchantPage> {
  int _currentTabIndex = 0;
  List<OrderModel> _orders = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final orders = await OrderService.fetchOrderMerchant();
      if (!mounted) return;
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16), // Jarak 16px dari atas
            
            // 1. HEADER (Menggunakan komponen & struktur yang sama dengan Customer)
            _buildHeader(context),

            // KUNCI: Jarak presisi 16px langsung ke Tab Bar (tanpa Divider)
            const SizedBox(height: 16),

            // 2. TAB BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: HapHapTabBar(
                  currentIndex: _currentTabIndex,
                  tabs: const ['Menunggu Bayar', 'Siap Diambil', 'Selesai', 'Dibatalkan'],
                  onTap: (index) {
                    setState(() {
                      _currentTabIndex = index;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16), // Jarak 16px dari tab bar ke konten list

            // 3. KONTEN TAB
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          // HapHapPageHeader dibungkus Expanded agar tombol di kanan nggak tergeser
          const Expanded(
            child: HapHapPageHeader(
              title: 'Aktivitas',
              showBackButton: false, // Halaman utama tab, matikan tombol back
              fontSize: 24,          // Font besar sesuai desain
            ),
          ),
          
          GestureDetector(
            // --- NAVIGASI KE LAPORAN TRANSAKSI ---
            onTap: () {
              context.push(AppRoutes.laporanTransaksi);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Color(0xFF505050), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_downward, size: 16, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }

    List<OrderModel> filteredOrders;
    MerchantOrderStatus currentStatus;

    switch (_currentTabIndex) {
      case 0:
        filteredOrders = _orders.where((o) => o.status == 'PENDING').toList();
        currentStatus = MerchantOrderStatus.baru;
        break;
      case 1:
        filteredOrders = _orders.where((o) => o.status == 'PAID').toList();
        currentStatus = MerchantOrderStatus.menunggu; // Siap Diambil
        break;
      case 2:
        filteredOrders = _orders.where((o) => o.status == 'COMPLETED').toList();
        currentStatus = MerchantOrderStatus.selesai;
        break;
      case 3:
      default:
        filteredOrders = _orders.where((o) => o.status == 'CANCELLED').toList();
        currentStatus = MerchantOrderStatus.dibatalkan;
        break;
    }

    return _buildListPesanan(filteredOrders, currentStatus);
  }

  Widget _buildListPesanan(List<OrderModel> pesananList, MerchantOrderStatus status) {
    if (pesananList.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada pesanan.',
          style: TextStyle(color: AppColors.greyDark, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: pesananList.length,
      itemBuilder: (context, index) {
        final order = pesananList[index];
        final itemsList = order.orderItems.map((i) => '${i.quantity}x ${i.name}').toList();
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: HapHapMerchantOrderCard(
            status: status,
            customerName: 'Customer', // User name is not included in backend OrderMerchantInfo sadly
            orderId: order.orderId,
            items: itemsList,
            totalPrice: 'Rp ${_formatPrice(order.totalAmount)}',
            onAccept: () {
              if (status == MerchantOrderStatus.menunggu) {
                showDialog(
                  context: context,
                  builder: (context) => HapHapScanQRDialog(orderId: order.orderId),
                ).then((success) {
                  if (success == true) {
                    _fetchOrders(); // Refresh setelah berhasil scan
                  }
                });
              }
            },
          ),
        );
      },
    );
  }
}

// ============================================================================
// KOMPONEN: KARTU ORDER MERCHANT
// ============================================================================
enum MerchantOrderStatus { baru, menunggu, selesai, dibatalkan }

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
        badgeText = 'MENUNGGU BAYAR';
        badgeColor = const Color(0xFFF2994A);
        badgeBgColor = const Color(0xFFFFF6ED);
        break;
      case MerchantOrderStatus.menunggu:
        badgeText = 'SIAP DIAMBIL';
        badgeColor = const Color(0xFFF2994A); 
        badgeBgColor = const Color(0xFFFFF6ED);
        break;
      case MerchantOrderStatus.selesai:
        badgeText = 'SELESAI';
        badgeColor = Colors.green;
        badgeBgColor = const Color(0xFFE8F5E9);
        break;
      case MerchantOrderStatus.dibatalkan:
        badgeText = 'DIBATALKAN';
        badgeColor = Colors.red;
        badgeBgColor = const Color(0xFFFFEBEB);
        break;
    }

    return Container(
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
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black),
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
          const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
          const SizedBox(height: 16),
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
          const SizedBox(height: 8), 
          const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pesanan', style: TextStyle(fontSize: 12, color: AppColors.greyDark)),
                Text(totalPrice, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black)),
              ],
            ),
          ),
          if (status == MerchantOrderStatus.menunggu) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: HapHapButton(
                      text: 'Tolak',
                      isOutline: true, 
                      onPressed: onReject ?? () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HapHapButton(
                      text: 'Scan QR Pengambil',
                      onPressed: onAccept ?? () {},
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}