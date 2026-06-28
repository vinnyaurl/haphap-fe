import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/data/services/merchant_service.dart';
import 'package:haphap_fe/data/models/merchant_model.dart';
import 'package:haphap_fe/presentation/widgets/cards/akun_profile_card.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/core/network/token_manager.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_edit_profil.dart';

class AkunMerchantPage extends StatefulWidget {
  const AkunMerchantPage({super.key});

  @override
  State<AkunMerchantPage> createState() => _AkunMerchantPageState();
}

class _AkunMerchantPageState extends State<AkunMerchantPage>
    with WidgetsBindingObserver {
  MerchantDetailModel? _merchant;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isUnauthorized = false;
  bool _needsRefresh = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchProfile();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _needsRefresh) {
      _needsRefresh = false;
      _fetchProfile();
    }
  }

  Future<void> _fetchProfile() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _isUnauthorized = false;
      });
    }

    try {
      final merchantData = await MerchantService.getMe();
      if (!mounted) return;
      setState(() {
        _merchant = merchantData;
        _isLoading = false;
        _errorMessage = null;
        _isUnauthorized = false;
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
        _errorMessage = 'Tidak dapat memuat data profil. Periksa koneksi internet kamu.';
      });
    }
  }

  Future<void> _handleLogout() async {
    await TokenManager.deleteToken();
    if (!mounted) return;
    context.go(AppRoutes.login);
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
                ? _buildErrorState()
                : _buildContent(context),
      ),
    );
  }
  
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
              color: AppColors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Terjadi kesalahan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.9),
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
                    context.go(AppRoutes.login);
                  } else {
                    _fetchProfile();
                  }
                },
              ),
            ),
          ],
        ),
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
            title: 'Profile Toko',
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
                    _buildSectionTitle('Akun'),
                    _buildMenuCard([
                      _MenuItemData(
                        icon: Icons.edit,
                        title: 'Edit Detail',
                        onTap: () async {
                          _needsRefresh = true;
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const EditProfilMerchantPage(),
                            ),
                          );
                          if (!mounted) return;
                          _needsRefresh = false;
                          setState(() => _isLoading = true);
                          _fetchProfile();
                        },
                      ),
                      _MenuItemData(
                        icon: Icons.info, 
                        title: 'Statistik',
                        onTap: () {
                          context.push(AppRoutes.merchantStatistik);
                        },
                      ),
                    ]),

                    const SizedBox(height: 32),

                    _buildSectionTitle('Selebihnya dari HapHap'),
                    _buildMenuCard([
                      _MenuItemData(
                        icon: Icons.person,
                        title: 'Kembali Sebagai Customer',
                        onTap: () {
                          debugPrint('Switch to Customer mode');
                          context.go(AppRoutes.beranda); 
                        },
                      ),
                    ]),



                    const SizedBox(height: 32),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: HapHapButton(
                        text: 'Keluar',
                        isExpanded: true,
                        size: HapHapButtonSize.large,
                        onPressed: _handleLogout,
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
  final VoidCallback onTap;

  _MenuItemData({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
