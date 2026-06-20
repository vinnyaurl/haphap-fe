import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/navigations/tab_bar.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_order.dart';
import 'package:haphap_fe/data/services/order_service.dart';
import 'package:haphap_fe/data/models/order_model.dart';
import 'package:haphap_fe/presentation/widgets/dialog/merchant_scan_qr_dialog.dart';
import 'package:haphap_fe/core/network/api_client.dart';

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
  bool _isUnauthorized = false;

  // Tracks PREPARING orders where merchant tapped "Siap Ambil".
  // UI-only: flips card from sedangDisiapkan → siapDiambil (shows Scan QR).
  // Cleared on every _fetchOrders() so a hard refresh resets it.
  final Set<String> _readyOrderIds = {};

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    // Jika dipanggil ulang (refresh), reset state terlebih dahulu
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _isUnauthorized = false;
      });
    }

    try {
      final orders = await OrderService.fetchOrderMerchant();
      if (!mounted) return;
      setState(() {
        _orders = orders;
        _isLoading = false;
        _errorMessage = null;
        _isUnauthorized = false;
        _readyOrderIds.clear();
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        if (e.statusCode == 401) {
          _isUnauthorized = true;
          _errorMessage = 'Sesi kamu telah berakhir. Silakan login kembali.';
        } else if (e.statusCode == 403) {
          _errorMessage = 'Kamu tidak memiliki akses ke halaman ini.';
        } else {
          _errorMessage = e.message;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Tidak dapat memuat data pesanan. Periksa koneksi internet kamu.';
      });
    }
  }

  /// Pull-to-refresh handler
  Future<void> _onRefresh() async {
    try {
      final orders = await OrderService.fetchOrderMerchant();
      if (!mounted) return;
      setState(() {
        _orders = orders;
        _errorMessage = null;
        _isUnauthorized = false;
        _readyOrderIds.clear();
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        if (e.statusCode == 401) {
          _isUnauthorized = true;
          _errorMessage = 'Sesi kamu telah berakhir. Silakan login kembali.';
        } else {
          _errorMessage = e.message;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Tidak dapat memuat data pesanan. Periksa koneksi internet kamu.';
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
                  tabs: const ['Baru', 'Sedang Disiapkan', 'Selesai'],
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
      return _buildErrorState();
    }

    List<OrderModel> filteredOrders;
    MerchantOrderStatus currentStatus;

    switch (_currentTabIndex) {
      case 0:
        // Baru = PROCESSING (payment confirmed via webhook, waiting merchant action)
        filteredOrders = _orders.where((o) => o.status == 'PROCESSING').toList();
        currentStatus = MerchantOrderStatus.baru;
        break;
      case 1:
        // Sedang Disiapkan = PREPARING (merchant accepted, currently preparing).
        // Card status per-order: siapDiambil if merchant tapped "Siap Ambil",
        // otherwise sedangDisiapkan. Handled inside _buildListPesanan for tab 1.
        filteredOrders = _orders.where((o) => o.status == 'PREPARING').toList();
        currentStatus = MerchantOrderStatus.sedangDisiapkan; // default; overridden per-card
        break;
      case 2:
      default:
        // Selesai tab: shows both COMPLETED and CANCELLED orders
        filteredOrders = _orders
            .where((o) => o.status == 'COMPLETED' || o.status == 'CANCELLED')
            .toList();
        currentStatus = MerchantOrderStatus.selesai; // overridden per-card below
        break;
    }

    return _buildListPesanan(filteredOrders, currentStatus);
  }

  /// Widget untuk menampilkan error state yang user-friendly dengan tombol retry.
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isUnauthorized ? Icons.lock_outline : Icons.error_outline,
              size: 48,
              color: AppColors.greyDark,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Terjadi kesalahan.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.greyDark,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              child: HapHapButton(
                text: _isUnauthorized ? 'Login Ulang' : 'Coba Lagi',
                onPressed: () {
                  if (_isUnauthorized) {
                    // Navigasi ke halaman login jika token expired
                    context.go(AppRoutes.login);
                  } else {
                    _fetchOrders();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListPesanan(List<OrderModel> pesananList, MerchantOrderStatus status) {
    if (pesananList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: AppColors.greyDark,
            ),
            const SizedBox(height: 12),
            const Text(
              'Belum ada pesanan.',
              style: TextStyle(color: AppColors.greyDark, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        itemCount: pesananList.length,
        itemBuilder: (context, index) {
          final order = pesananList[index];

          // Resolve the actual card status per-order:
          // - Tab 1 (PREPARING): siapDiambil if merchant already tapped "Siap Ambil"
          // - Tab 2 (Selesai): dibatalkan for CANCELLED, selesai for COMPLETED
          // - All other tabs: use the tab-level status directly
          final MerchantOrderStatus cardStatus;
          if (order.status == 'PREPARING') {
            cardStatus = _readyOrderIds.contains(order.orderId)
                ? MerchantOrderStatus.siapDiambil
                : MerchantOrderStatus.sedangDisiapkan;
          } else if (order.status == 'CANCELLED') {
            cardStatus = MerchantOrderStatus.dibatalkan;
          } else {
            cardStatus = status;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: HapHapMerchantOrderCard(
              status: cardStatus,
              customerName: order.customerName ?? 'Customer',
              orderId: order.orderId,
              items: order.orderItems,
              totalPrice: 'Rp ${_formatPrice(order.totalAmount)}',
              onAccept: cardStatus == MerchantOrderStatus.baru
                  ? () async {
                      try {
                        await OrderService.acceptOrder(order.orderId);
                        if (!mounted) return;
                        _fetchOrders();
                      } catch (_) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal menerima pesanan. Coba lagi.')),
                        );
                      }
                    }
                  : null,
              onReject: cardStatus == MerchantOrderStatus.baru
                  ? () async {
                      try {
                        await OrderService.rejectOrder(order.orderId);
                        if (!mounted) return;
                        _fetchOrders();
                      } catch (_) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal menolak pesanan. Coba lagi.')),
                        );
                      }
                    }
                  : null,
              onReady: cardStatus == MerchantOrderStatus.sedangDisiapkan
                  ? () {
                      setState(() => _readyOrderIds.add(order.orderId));
                    }
                  : null,
              onScanQR: cardStatus == MerchantOrderStatus.siapDiambil
                  ? () {
                      showDialog(
                        context: context,
                        builder: (context) => HapHapScanQRDialog(orderId: order.orderId),
                      ).then((success) {
                        if (success == true) {
                          _fetchOrders();
                        }
                      });
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }
}