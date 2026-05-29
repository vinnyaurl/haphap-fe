import 'package:flutter/material.dart';
import 'package:haphap_fe/core/constants/app_icons.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_aktivitas.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_akun.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_menu.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_statistik.dart';
import 'package:haphap_fe/presentation/widgets/buttons/beranda_merchant_category.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_add_stock.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_menu.dart';
import 'package:haphap_fe/presentation/widgets/navigations/navigation_bar.dart';
import 'package:haphap_fe/presentation/widgets/cards/beranda_stats.dart';

// ---------------------------------------------------------------------------
// Layout constants
// ---------------------------------------------------------------------------
class _BerandaMerchantLayout {
  // Hero section
  static const double heroTopPadding = 40; 
  static const double heroHorizontalPadding = 24;
  static const double heroTaglineToCards = 32;
  static const double heroRedBgBottomCut = 80;

  // Stats cards
  static const double statCardSpacing = 16;

  // Features & Active Menu sections
  static const double sectionHorizontalPadding = 24;
  static const double sectionTitleToContent = 16;
  static const double fiturToMenuAktif = 32;
  static const double menuAktifSpacing = 16;
  static const double categoryItemSpacing = 20;

  // Bottom padding 
  static const double bottomScrollPadding = 80;
}

// ---------------------------------------------------------------------------
// Content constants
// ---------------------------------------------------------------------------
class _BerandaMerchantContent {
  static const String restoName = "Cal's Chicken Bowl";
  static const String tagline = 'Welcome,\n$restoName!';

  static const String statsIncomeTitle = 'Total Penghasilan';
  static const String statsIncomePrefix = 'Rp ';
  static const String statsIncomeValue = '500.000';
  static const String statsIncomeSubtitle = 'Sejak 6 Juli 2026';

  static const String statsSavedTitle = 'Berhasil Selamatin';
  static const String statsSavedValue = '67 Porsi';
  static const String statsSavedSubtitle = 'Sejak 6 Juli 2026';
}

// ---------------------------------------------------------------------------
// Main page
// ---------------------------------------------------------------------------
class BerandaMerchantPage extends StatefulWidget {
  const BerandaMerchantPage({super.key});

  @override
  State<BerandaMerchantPage> createState() => _BerandaMerchantPageState();
}

class _BerandaMerchantPageState extends State<BerandaMerchantPage> {
  int _currentNavIndex = 0; // Beranda = Index 0

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _HeroSection(),
            SizedBox(height: 32),
            _FiturSection(),
            SizedBox(height: _BerandaMerchantLayout.fiturToMenuAktif),
            _MenuAktifSection(),
            SizedBox(height: _BerandaMerchantLayout.bottomScrollPadding),
          ],
        ),
      ),
      bottomNavigationBar: HapHapNavBar(
        currentIndex: _currentNavIndex,
        type: NavBarType.merchant, 
        onTap: (index) {
          if (_currentNavIndex == index) return;
          
          setState(() => _currentNavIndex = index);

          // --- LOGIKA PERPINDAHAN HALAMAN ---
          switch (index) {
            case 0:
              // Sudah di Beranda
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
}

// ---------------------------------------------------------------------------
// Hero section
// ---------------------------------------------------------------------------
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: _BerandaMerchantLayout.heroRedBgBottomCut,
          child: const _RedBackground(),
        ),

        SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: _BerandaMerchantLayout.heroTopPadding),
              
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _BerandaMerchantLayout.heroHorizontalPadding,
                ),
                child: Text(
                  _BerandaMerchantContent.tagline,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    height: 1.3,
                  ),
                ),
              ),
              
              const SizedBox(height: _BerandaMerchantLayout.heroTaglineToCards),
              
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _BerandaMerchantLayout.heroHorizontalPadding,
                ),
                child: _StatsRow(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RedBackground extends StatelessWidget {
  const _RedBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary, 
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: HapHapStatsCard(
            title: _BerandaMerchantContent.statsIncomeTitle,
            prefixText: _BerandaMerchantContent.statsIncomePrefix,
            mainValue: _BerandaMerchantContent.statsIncomeValue,
            valueColor: Colors.green, 
            subtitle: _BerandaMerchantContent.statsIncomeSubtitle,
          ),
        ),
        SizedBox(width: _BerandaMerchantLayout.statCardSpacing),
        Expanded(
          child: HapHapStatsCard(
            title: _BerandaMerchantContent.statsSavedTitle,
            mainValue: _BerandaMerchantContent.statsSavedValue,
            valueColor: AppColors.primary, 
            subtitle: _BerandaMerchantContent.statsSavedSubtitle,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Fitur section
// ---------------------------------------------------------------------------
class _FiturSection extends StatelessWidget {
  const _FiturSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _BerandaMerchantLayout.sectionHorizontalPadding,
          ),
          child: _SectionTitle(text: 'Fitur'),
        ),
        const SizedBox(height: _BerandaMerchantLayout.sectionTitleToContent),
        
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _BerandaMerchantLayout.sectionHorizontalPadding,
          ),
          child: Row(
            children: [
              HapHapCategoryButton(
                iconPath: AppIcons.menu,
                label: 'Menu',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuMerchantPage()),
                  );
                },
              ),
              const SizedBox(width: _BerandaMerchantLayout.categoryItemSpacing),
              HapHapCategoryButton(
                iconPath: AppIcons.statistics,
                label: 'Statistik',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StatistikMerchantPage()),
                  );
                },
              ),
              const SizedBox(width: _BerandaMerchantLayout.categoryItemSpacing),
              HapHapCategoryButton(
                iconPath: AppIcons.scan,
                label: 'Scan QR',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Menu Aktif section
// ---------------------------------------------------------------------------
class _MenuAktifSection extends StatelessWidget {
  const _MenuAktifSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _BerandaMerchantLayout.sectionHorizontalPadding,
          ),
          child: _SectionTitle(text: 'Menu Aktif'),
        ),
        const SizedBox(height: _BerandaMerchantLayout.sectionTitleToContent),
        
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _BerandaMerchantLayout.sectionHorizontalPadding,
          ),
          child: Column(
            children: const [
              HapHapMerchantAddStockCard(
                imagePath: 'assets/images/puypuy_laper_nih.png',
              ),
              
              SizedBox(height: _BerandaMerchantLayout.menuAktifSpacing),
              
              HapHapMerchantMenuCard(
                title: 'Szechuan Chicken Bowl',
                description: 'Nasi + Ayam Saus Szechuan',
                price: 'Rp 25.000',
                stockText: '2 left',
                imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
              ),
              
              SizedBox(height: _BerandaMerchantLayout.menuAktifSpacing),
              
              HapHapMerchantMenuCard(
                title: 'Szechuan Chicken Bowl',
                description: 'Nasi + Ayam Saus Szechuan',
                price: 'Rp 25.000',
                stockText: 'Sold',
                isSoldOut: true, 
                imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared small widgets
// ---------------------------------------------------------------------------
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
    );
  }
}