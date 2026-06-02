import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/cards/akun_profile_card.dart'; 
import 'package:haphap_fe/presentation/widgets/buttons/button.dart'; 

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, 
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Profil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: HapHapProfileCard(
                name: 'PUYPUY',
                email: 'puypuy@haphap.com',
                phoneNumber: '+6286767676767',
                imagePath: 'assets/images/profile_image.png', 
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF9F9F9), 
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32), 
                    topRight: Radius.circular(32), 
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0), 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- SECTION 1: AKUN ---
                        _buildSectionTitle('Akun'),
                        _buildMenuCard([
                          _MenuItemData(
                            icon: Icons.edit,
                            title: 'Edit Profil',
                            onTap: () {
                              context.push(AppRoutes.editProfil); // <-- INI NAVIGASINYA
                            },
                          ),
                          _MenuItemData(
                            icon: Icons.info, 
                            title: 'Statistik',
                            badge: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'Hemat 67rb',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white),
                              ),
                            ),
                            onTap: () {
                              context.push(AppRoutes.statistik);
                            },
                          ),
                        ]),

                        const SizedBox(height: 32),

                        // --- SECTION 2: PREFERENSI ---
                        _buildSectionTitle('Preferensi'),
                        _buildMenuCard([
                          _MenuItemData(
                            icon: Icons.bookmark,
                            title: 'Alamat',
                            onTap: () => print('Ke Pengaturan Alamat'),
                          ),
                          _MenuItemData(
                            icon: Icons.language, 
                            title: 'Bahasa',
                            onTap: () => print('Ke Pengaturan Bahasa'),
                          ),
                          _MenuItemData(
                            icon: Icons.notifications,
                            title: 'Notifications',
                            onTap: () => print('Ke Notifikasi User'),
                          ),
                        ]),

                        const SizedBox(height: 32),

                        // --- SECTION 3: SELEBIHNYA DARI HAPHAP ---
                        _buildSectionTitle('Selebihnya dari HapHap'),
                        _buildMenuCard([
                          _MenuItemData(
                            icon: Icons.store,
                            title: 'Bergabung sebagai Merchant', // Teks diupdate sesuai desain baru
                            onTap: () {
                              context.go(AppRoutes.merchantBeranda); 
                            },
                          ),
                        ]),

                        const SizedBox(height: 32),

                        // --- SECTION 4: LAINNYA ---
                        _buildSectionTitle('Lainnya'),
                        _buildMenuCard([
                          _MenuItemData(
                            icon: Icons.help,
                            title: 'Bantuan & Dukungan',
                            onTap: () => print('Ke Bantuan'),
                          ),
                          _MenuItemData(
                            icon: Icons.description, 
                            title: 'Syarat & Ketentuan',
                            onTap: () => print('Ke S&K'),
                          ),
                        ]),

                        const SizedBox(height: 32),

                        // --- TOMBOL KELUAR ---
                        Center(
                          child: HapHapButton(
                            text: 'Keluar',
                            size: HapHapButtonSize.large, // Menggunakan ukuran large sesuai komponen
                            onPressed: () {
                              // Logika logout, misal lempar kembali ke halaman Login
                              context.go(AppRoutes.login);
                            },
                          ),
                        ),

                        const SizedBox(height: 100), // Jarak napas bawah sebelum navbar
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HELPER WIDGETS
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
              borderRadius: BorderRadius.circular(16), 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    Icon(item.icon, size: 20, color: const Color(0xFF505050)), 
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
                    if (item.badge != null) ...[
                      item.badge!,
                      const SizedBox(width: 8),
                    ],
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

class _MenuItemData {
  final IconData icon;
  final String title;
  final Widget? badge; 
  final VoidCallback onTap;

  _MenuItemData({
    required this.icon,
    required this.title,
    this.badge,
    required this.onTap,
  });
}