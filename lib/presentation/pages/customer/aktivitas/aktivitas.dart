import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/pages/customer/beranda.dart';
import 'package:haphap_fe/presentation/widgets/navigations/navigation_bar.dart';
import 'package:haphap_fe/presentation/widgets/navigations/tab_bar.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_proses.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_lainnya.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_riwayat.dart'; 
import 'package:haphap_fe/presentation/pages/customer/aktivitas/laporan_transaksi.dart';
import 'package:haphap_fe/presentation/pages/customer/aktivitas/detail_pesanan.dart';

class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> {
  int _currentNavIndex = 2;
  int _currentTabIndex = 0;

  bool hasOrders = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            const Divider(
              color: Color(0xFFF1F1F1),
              height: 1,
              thickness: 1,
            ),
            
            const SizedBox(height: 16),

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

            Expanded(
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HapHapNavBar(
        currentIndex: _currentNavIndex, 
        type: NavBarType.user,
        onTap: (index) {
          if (_currentNavIndex == index) return;

          setState(() {
            _currentNavIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BerandaPage(),
                ),
              );
              break;
            case 1:
              // TODO: Navigate to Jelajah screen
              break;
            case 2:
              break;
            case 3:
              // TODO: Navigate to Akun screen
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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              fontFamily: 'Plus Jakarta Sans', 
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LaporanTransaksiPage(),
                ),
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DetailPesananPage(isCompleted: false)),
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DetailPesananPage(isCompleted: false)),
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DetailPesananPage(isCompleted: false)),
              );
            },
            child: const HapHapAktivitasCard(
              statusText: 'Makanan sudah siap nih!',
              mainText: 'Yuk ambil!',
              restaurantName: 'Cal\'s Chicken Bowl',
              imagePath: 'assets/images/aktivitas_puy_done.png',
            ),
          ),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DetailPesananPage(isCompleted: true)),
            );
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DetailPesananPage(isCompleted: true)),
            );
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
            imagePath: 'assets/images/logo_haphap.png',
          ),
        ],
      ),
    );
  }
}