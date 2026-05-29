import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_akun.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_beranda.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_menu.dart';
import 'package:haphap_fe/presentation/widgets/navigations/navigation_bar.dart';
import 'package:haphap_fe/presentation/widgets/navigations/tab_bar.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart'; 

// --- IMPORT HALAMAN LAIN UNTUK NAVIGASI ---
// Sesuaikan path ini dengan folder kamu yang sebenarnya
import 'package:haphap_fe/presentation/pages/customer/aktivitas/laporan_transaksi.dart'; 

class AktivitasMerchantPage extends StatefulWidget {
  const AktivitasMerchantPage({super.key});

  @override
  State<AktivitasMerchantPage> createState() => _AktivitasMerchantPageState();
}

class _AktivitasMerchantPageState extends State<AktivitasMerchantPage> {
  int _currentNavIndex = 2; // Aktivitas = Index 2
  int _currentTabIndex = 0;

  // ===========================================================================
  // DUMMY STATE: Simulasi Database Lokal
  // Nanti saat integrasi BE, list ini diganti dengan data dari API
  // ===========================================================================
  List<Map<String, dynamic>> pesananBaru = [
    {
      'id': 'S6I7X6S7E6V7E6N7',
      'name': 'Anderies Nomanto',
      'items': ['Szechuan Chicken Bowl', 'Szechuan Chicken Bowl'],
      'price': 'Rp 25.000'
    },
    {
      'id': 'S6I7X6S7E6V7E6N8',
      'name': 'Vinny',
      'items': ['Blackpepper Chicken Bowl'],
      'price': 'Rp 25.000'
    }
  ];
  
  List<Map<String, dynamic>> pesananDisiapkan = [];
  List<Map<String, dynamic>> pesananMenunggu = [];
  List<Map<String, dynamic>> pesananSelesai = [];

  // ===========================================================================
  // FUNGSI SIMULASI PINDAH TAB
  // ===========================================================================
  void terimaPesanan(Map<String, dynamic> pesanan) {
    setState(() {
      pesananBaru.remove(pesanan);
      pesananDisiapkan.add(pesanan);
      _currentTabIndex = 1; // Otomatis pindah ke tab "Disiapkan"
    });
  }

  void tolakPesanan(Map<String, dynamic> pesanan) {
    setState(() {
      pesananBaru.remove(pesanan);
      // Logika tolak pesanan (bisa dihapus atau masuk riwayat tersendiri)
    });
  }

  void pesananSiapAmbil(Map<String, dynamic> pesanan) {
    setState(() {
      pesananDisiapkan.remove(pesanan);
      pesananMenunggu.add(pesanan);
      _currentTabIndex = 2; // Otomatis pindah ke tab "Menunggu"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: HapHapTabBar(
                  currentIndex: _currentTabIndex,
                  tabs: const ['Baru', 'Disiapkan', 'Menunggu', 'Selesai'],
                  onTap: (index) {
                    setState(() {
                      _currentTabIndex = index;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
      bottomNavigationBar: HapHapNavBar(
        currentIndex: _currentNavIndex,
        type: NavBarType.merchant, 
        onTap: (index) {
          if (_currentNavIndex == index) return;

          setState(() => _currentNavIndex = index);

          // --- NAVIGASI NAVBAR ---
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BerandaMerchantPage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MenuMerchantPage()),
              );
              break;
            case 2:
              // Sudah di halaman Aktivitas
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AkunMerchantPage()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Aktivitas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.black),
          ),
          GestureDetector(
            // --- NAVIGASI KE LAPORAN TRANSAKSI ---
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LaporanTransaksiPage()),
              );
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
    switch (_currentTabIndex) {
      case 0: return _buildListPesanan(pesananBaru, MerchantOrderStatus.baru);
      case 1: return _buildListPesanan(pesananDisiapkan, MerchantOrderStatus.disiapkan);
      case 2: return _buildListPesanan(pesananMenunggu, MerchantOrderStatus.menunggu);
      case 3: return _buildListPesanan(pesananSelesai, MerchantOrderStatus.selesai);
      default: return const SizedBox();
    }
  }

  // Fungsi dinamis untuk me-render list sesuai tab yang aktif
  Widget _buildListPesanan(List<Map<String, dynamic>> pesananList, MerchantOrderStatus status) {
    if (pesananList.isEmpty) {
      return Center(
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
        final pesanan = pesananList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: HapHapMerchantOrderCard(
            status: status,
            customerName: pesanan['name'],
            orderId: pesanan['id'],
            items: List<String>.from(pesanan['items']),
            totalPrice: pesanan['price'],
            onAccept: () => terimaPesanan(pesanan),
            onReject: () => tolakPesanan(pesanan),
            onReady: () => pesananSiapAmbil(pesanan),
          ),
        );
      },
    );
  }
}

// ============================================================================
// KOMPONEN: KARTU ORDER MERCHANT
// ============================================================================
enum MerchantOrderStatus { baru, disiapkan, menunggu, selesai }

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
        badgeText = 'BARU';
        badgeColor = Colors.red;
        badgeBgColor = const Color(0xFFFFEBEB);
        break;
      case MerchantOrderStatus.disiapkan:
        badgeText = 'SEDANG DISIAPKAN';
        badgeColor = const Color(0xFFF2994A); 
        badgeBgColor = const Color(0xFFFFF6ED);
        break;
      case MerchantOrderStatus.menunggu:
        badgeText = 'MENUNGGU PENGAMBILAN';
        badgeColor = Colors.red;
        badgeBgColor = const Color(0xFFFFEBEB);
        break;
      case MerchantOrderStatus.selesai:
        badgeText = 'SELESAI';
        badgeColor = Colors.green;
        badgeBgColor = const Color(0xFFE8F5E9);
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
          if (status == MerchantOrderStatus.baru) ...[
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
                      text: 'Terima',
                      onPressed: onAccept ?? () {},
                    ),
                  ),
                ],
              ),
            ),
          ] else if (status == MerchantOrderStatus.disiapkan) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 140,
                  child: HapHapButton(
                    text: 'Siap Ambil',
                    onPressed: onReady ?? () {},
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}