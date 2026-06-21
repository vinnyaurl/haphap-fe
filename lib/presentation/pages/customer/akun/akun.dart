import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

// --- IMPORT SERVICE & MODEL ---
import 'package:haphap_fe/data/services/user_service.dart';
import 'package:haphap_fe/data/services/application_service.dart';
import 'package:haphap_fe/data/models/user_profile_model.dart';

// --- IMPORT KOMPONEN ---
import 'package:haphap_fe/presentation/widgets/cards/akun_profile_card.dart'; 
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  UserProfileModel? _profile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfile(); // Panggil API saat halaman diload
  }

  Future<void> _fetchProfile() async {
    try {
      final profileData = await UserService.getMe();
      setState(() {
        _profile = profileData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Helper untuk format "Hemat 67rb"
  String _formatHemat(int totalSaved) {
    if (totalSaved == 0) return 'Belum ada';
    if (totalSaved >= 1000) {
      return 'Hemat ${(totalSaved / 1000).toInt()}rb';
    }
    return 'Hemat $totalSaved';
  }

  Future<void> _handleJoinMerchant(BuildContext context) async {
    // Show loading on the root navigator so it overlays everything
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );

    try {
      // Always re-fetch profile to get the latest role from server
      final freshProfile = await UserService.getMe();
      if (!mounted) return;

      // Update local state with fresh data
      setState(() {
        _profile = freshProfile;
      });

      if (freshProfile.role == 'MERCHANT') {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
        context.go(AppRoutes.merchantBeranda);
        return;
      }

      final myApps = await ApplicationService.findMyApplications();
      
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog

      final hasPending = myApps.any((app) => app.status == 'PENDING');
      final hasApproved = myApps.any((app) => app.status == 'APPROVED');

      if (hasApproved) {
        // Role on server is MERCHANT but hadn't synced — go to merchant
        context.go(AppRoutes.merchantBeranda);
      } else if (hasPending) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengajuan pendaftaran merchant Anda sedang diproses oleh Admin.'),
            backgroundColor: AppColors.primary,
          ),
        );
      } else {
        // Can register (No application, or previous ones were rejected)
        context.push(AppRoutes.merchantRegister);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, 
      body: SafeArea(
        bottom: false,
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: AppColors.white))
            : _errorMessage != null
                ? Center(
                    child: Text(
                      'Error: $_errorMessage', 
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: HapHapPageHeader(
            title: 'Profil',
            showBackButton: false, 
            titleColor: AppColors.white, 
            fontSize: 24,
          ),
        ),
        
        const SizedBox(height: 16),

        // 1. DATA DINAMIS KE KARTU PROFIL
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: HapHapProfileCard(
            name: _profile?.name ?? 'User',
            email: _profile?.email ?? '-',
            phoneNumber: _profile?.phone ?? '-',
            imageUrl: _profile?.avatar, 
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
                          context.push(AppRoutes.editProfil); 
                        },
                      ),
                      _MenuItemData(
                        icon: Icons.info, 
                        title: 'Statistik',
                        // 2. DATA DINAMIS STATISTIK
                        badge: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _formatHemat(_profile?.totalSaved ?? 0),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white),
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
                        onTap: () {
                          context.push(AppRoutes.alamat);
                        }
                      ),
                      _MenuItemData(
                        icon: Icons.language, 
                        title: 'Bahasa',
                        onTap: () {
                          context.push(AppRoutes.bahasa);
                        },
                      ),
                      _MenuItemData(
                        icon: Icons.notifications,
                        title: 'Notikasi',
                        onTap: () {
                          context.push(AppRoutes.notifikasi);
                        },
                      ),
                    ]),

                    const SizedBox(height: 32),

                    // --- SECTION 3: SELEBIHNYA DARI HAPHAP ---
                    _buildSectionTitle('Selebihnya dari HapHap'),
                    _buildMenuCard([
                      _MenuItemData(
                        icon: Icons.store,
                        title: 'Bergabung sebagai Merchant', 
                        onTap: () => _handleJoinMerchant(context),
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
                        size: HapHapButtonSize.large, 
                        onPressed: () {
                          context.go(AppRoutes.login);
                        },
                      ),
                    ),

                    const SizedBox(height: 100), 
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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