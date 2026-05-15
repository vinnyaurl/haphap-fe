import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/core/constants/app_icons.dart';

import 'package:haphap_fe/presentation/widgets/inputs/search_bar.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/beranda_stats.dart'; 
import 'package:haphap_fe/presentation/widgets/buttons/beranda_merchant_category.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/restaurant_card.dart'; 
import 'package:haphap_fe/presentation/widgets/navigations/navigation_bar.dart'; // Path disesuaikan

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, 
      
      // 1. KONTEN HALAMAN
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER OREN ---
            _buildHeader(context),
            
            // --- KARTU STATISTIK (Ditarik ke atas menimpa header) ---
            Transform.translate(
              offset: const Offset(0, -60), 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const HapHapStatsCard(
                      title: 'Berhasil Hemat',
                      prefixText: 'Rp ',
                      mainValue: '67.6rb',
                      valueColor: Colors.green, 
                      subtitle: 'Sejak 6 Juli 2026',
                    ),
                    HapHapStatsCard(
                      title: 'Berhasil Selamatin',
                      mainValue: '67 Porsi',
                      valueColor: AppColors.primary,
                      subtitle: 'Sejak 6 Juli 2026',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 0), 
            
            // --- BAGIAN KATEGORI ---
            _buildKategoriSection(),
            
            const SizedBox(height: 32),
            
            // --- BAGIAN SEKITAR KAMU ---
            _buildSekitarKamuSection(),
            
            const SizedBox(height: 40), 
          ],
        ),
      ),

      // 2. BOTTOM NAVIGATION BAR
      bottomNavigationBar: HapHapNavBar(
        currentIndex: _currentNavIndex,
        type: NavBarType.user,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }

  // ==============================================================
  // WIDGET HELPERS
  // ==============================================================

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16, 
        left: 24, 
        right: 24, 
        bottom: 80, 
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Search Bar
          HapHapSearchBar(
            hintText: 'Mau makan apa hari ini?',
            prefixIconPath: AppIcons.magnifying_glass,
          ),
          const SizedBox(height: 24),
          
          // 2. Teks Promo & Karakter (Puy)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selalu hemat beli\nmakanan pakai HapHap.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Text(
                          'Lihat diskon selengkapnya disini',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right, color: AppColors.white, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
              // --- INI PEMANGGILAN IMAGE PUY BERANDA ---
              // Catatan: Pastikan ukurannya pas. Kalau kekecilan/kebesaran, 
              // atur angka width & height di bawah ini.
              SvgPicture.asset(
                'assets/images/puy_beranda.svg',
                width: 120, // Disesuaikan agar proposional
                height: 120,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Kategori',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              HapHapCategoryButton(iconPath: AppIcons.bakery, label: 'Bakery', onTap: () {}),
              const SizedBox(width: 16),
              HapHapCategoryButton(iconPath: AppIcons.restaurant, label: 'Restoran', onTap: () {}),
              const SizedBox(width: 16),
              HapHapCategoryButton(iconPath: AppIcons.cafe, label: 'Kafe', onTap: () {}),
              const SizedBox(width: 16),
              HapHapCategoryButton(iconPath: AppIcons.bakery, label: 'Grocery', onTap: () {}),
              const SizedBox(width: 16),
              HapHapCategoryButton(iconPath: AppIcons.restaurant, label: 'Jajanan', onTap: () {}),
              const SizedBox(width: 16),
              HapHapCategoryButton(iconPath: AppIcons.dessert, label: 'Dessert', onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSekitarKamuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Sekitar Kamu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: const [
              HapHapRestaurantCard(
                // Gambar Chicken Bowl HD
                imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400', 
                distanceTime: '1.67 km · 67 menit',
                restaurantName: 'Cal\'s Chicken Bowl',
                ratingText: '4.8 · 6,7 rb+ rating',
              ),
              SizedBox(width: 16),
              HapHapRestaurantCard(
                // Gambar Croissant/Bakery Estetik
                imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&q=80&w=400', 
                distanceTime: '2.1 km · 15 menit',
                restaurantName: 'Bakery Enak Jaya',
                ratingText: '4.9 · 1,2 rb+ rating',
              ),
            ],
          ),
        ),
      ],
    );
  }
}