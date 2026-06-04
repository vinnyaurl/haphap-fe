import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/navigations/tab_bar.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_proses.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_lainnya.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_riwayat.dart'; 

// --- IMPORT KOMPONEN HEADER ---
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';

class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> {
  int _currentTabIndex = 0;
  bool hasOrders = true; 

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
              child: _buildTabContent(),
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
    if (!hasOrders) {
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

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              context.push(AppRoutes.detailPesanan);
            },
            child: const HapHapAktivitasCard(
              statusText: 'Makanan lagi disiapin nih!',
              mainText: '67 menit lagi...',
              restaurantName: 'Cal\'s Chicken Bowl',
              imagePath: 'assets/images/aktivitas_puy_waiting1.png',
            ),
          ),
          
          const SizedBox(height: 16),
          
          GestureDetector(
            onTap: () {
              context.push(AppRoutes.detailPesanan);
            },
            child: const HapHapAktivitasCard(
              statusText: 'Makanan lagi dikonfirmasi nih!',
              mainText: 'Ditunggu...',
              restaurantName: 'Cal\'s Chicken Bowl',
              imagePath: 'assets/images/aktivitas_puy_processing.png',
            ),
          ),
          
          const SizedBox(height: 16),
          
          GestureDetector(
            onTap: () {
              context.push(AppRoutes.detailPesanan);
            },
            child: const HapHapAktivitasCard(
              statusText: 'Makanan sudah siap nih!',
              mainText: 'Yuk ambil!',
              restaurantName: 'Cal\'s Chicken Bowl',
              imagePath: 'assets/images/aktivitas_puy_done.png',
            ),
          ),
          
          const SizedBox(height: 100), // Jarak aman bawah
        ],
      ),
    );
  }

  Widget _buildRiwayatTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        GestureDetector(
          onTap: () {
            context.push(AppRoutes.detailPesanan);
          },
          child: HapHapRiwayatCard(
            imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400', 
            dateStatusText: 'Hari ini, 06.07 · Diterima',
            restaurantName: 'Cal\'s Chicken Bowl',
            price: 'Rp 125.000',
            buttonText: 'Beri Rating',
            onButtonPressed: () {
              print("Buka modal rating dari halaman Aktivitas!");
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        GestureDetector(
          onTap: () {
            context.push(AppRoutes.detailPesanan);
          },
          child: HapHapRiwayatCard(
            imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
            dateStatusText: 'Kemarin, 06.07 · Diterima',
            restaurantName: 'Cal\'s Chicken Bowl',
            price: 'Rp 25.000',
            buttonText: 'Pesan Lagi',
            onButtonPressed: () {
              print("Pesan lagi dari halaman Aktivitas!");
            },
          ),
        ),
        
        const SizedBox(height: 100), // Jarak aman bawah
      ],
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