import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_aktivitas.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_beranda.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_menu.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_notifikasi.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_statistik.dart';
import 'package:haphap_fe/presentation/widgets/navigations/navigation_bar.dart';

class AkunMerchantPage extends StatefulWidget {
  const AkunMerchantPage({super.key});

  @override
  State<AkunMerchantPage> createState() => _AkunMerchantPageState();
}

class _AkunMerchantPageState extends State<AkunMerchantPage> {
  int _currentNavIndex = 3; // Index 3 untuk Tab Akun

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Background sedikit abu-abu agar card putihnya menonjol
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // 1. JUDUL HALAMAN
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Akun',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              
              const SizedBox(height: 32), // Gap besar setelah judul

              // 2. SECTION: UMUM
              _buildSectionTitle('Umum'),
              _buildMenuCard([
                _MenuItemData(
                  icon: Icons.edit,
                  title: 'Edit Detail',
                  onTap: () => print('Ke Edit Detail'),
                ),
                _MenuItemData(
                  icon: Icons.info, 
                  title: 'Statistik',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatistikMerchantPage(),
                      ),
                    );
                  },
                ),
                _MenuItemData(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotifikasiMerchantPage(),
                      ),
                    );
                  },
                ),
              ]),

              const SizedBox(height: 32), // Gap antar section

              // 3. SECTION: SELEBIHNYA DARI HAPHAP
              _buildSectionTitle('Selebihnya dari HapHap'),
              _buildMenuCard([
                _MenuItemData(
                  icon: Icons.person,
                  title: 'Kembali Sebagai Customer',
                  onTap: () {
                    print('Switch to Customer mode');
                    // TODO: Arahkan ke Beranda Customer
                  },
                ),
              ]),

              const SizedBox(height: 32), // Gap antar section

              // 4. SECTION: LAINNYA
              _buildSectionTitle('Lainnya'),
              _buildMenuCard([
                _MenuItemData(
                  icon: Icons.help,
                  title: 'Bantuan & Dukungan',
                  onTap: () => print('Ke Bantuan'),
                ),
                _MenuItemData(
                  icon: Icons.description, // Icon dokumen
                  title: 'Syarat & Ketentuan',
                  onTap: () => print('Ke S&K'),
                ),
              ]),

              const SizedBox(height: 40), // Jarak napas bawah sebelum navbar
            ],
          ),
        ),
      ),
      
      // 5. BOTTOM NAVIGATION BAR DENGAN ROUTING LENGKAP
      bottomNavigationBar: HapHapNavBar(
        currentIndex: _currentNavIndex,
        type: NavBarType.merchant, 
        onTap: (index) {
          if (_currentNavIndex == index) return;
          
          setState(() => _currentNavIndex = index);

          // --- LOGIKA PERPINDAHAN HALAMAN ---
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AktivitasMerchantPage()),
              );
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

  // ===========================================================================
  // HELPER WIDGETS (Biar rapi dan gampang copas menu)
  // ===========================================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<_MenuItemData> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: items.map((item) {
            return InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(16), // Biar efek kliknya melengkung
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    Icon(item.icon, size: 20, color: const Color(0xFF505050)), // Warna icon abu gelap
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 24, color: AppColors.greyDark),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Data class kecil untuk menyimpan info tiap baris menu
class _MenuItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _MenuItemData({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}