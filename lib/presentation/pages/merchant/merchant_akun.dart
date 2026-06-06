import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

// --- IMPORT KOMPONEN HEADER KITA ---
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/data/services/merchant_service.dart';
import 'package:haphap_fe/data/models/merchant_model.dart';
import 'package:haphap_fe/presentation/widgets/cards/akun_profile_card.dart';

class AkunMerchantPage extends StatefulWidget {
  const AkunMerchantPage({super.key});

  @override
  State<AkunMerchantPage> createState() => _AkunMerchantPageState();
}

class _AkunMerchantPageState extends State<AkunMerchantPage> {
  MerchantDetailModel? _merchant;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final merchantData = await MerchantService.getMe();
      if (!mounted) return;
      setState(() {
        _merchant = merchantData;
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

  @override
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
            title: 'Akun Toko',
            showBackButton: false, 
            titleColor: AppColors.white, 
            fontSize: 24,
          ),
        ),
        
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: HapHapProfileCard(
            name: _merchant?.merchantName ?? 'Toko',
            email: _merchant?.description ?? '-',
            phoneNumber: _merchant?.phone ?? '-',
            imageUrl: _merchant?.avatar, 
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
                    _buildSectionTitle('Umum'),
                    _buildMenuCard([
                      _MenuItemData(
                        icon: Icons.edit,
                        title: 'Edit Detail',
                        onTap: () {
                          context.push(AppRoutes.merchantEditProfil).then((_) {
                            setState(() => _isLoading = true);
                            _fetchProfile(); // Refresh profile after returning
                          });
                        },
                      ),
                _MenuItemData(
                  icon: Icons.info, 
                  title: 'Statistik',
                  onTap: () {
                    context.push(AppRoutes.merchantStatistik);
                  },
                ),
                _MenuItemData(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    context.push(AppRoutes.merchantNotifikasi);
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
                    context.go(AppRoutes.beranda); // Kembali ke shell rute customer
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

                    const SizedBox(height: 100), // Jarak napas bawah sebelum navbar
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