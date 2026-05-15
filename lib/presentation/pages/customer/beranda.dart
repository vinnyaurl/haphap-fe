import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/core/constants/app_icons.dart';

import 'package:haphap_fe/presentation/widgets/inputs/search_bar.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/beranda_stats.dart'; 
import 'package:haphap_fe/presentation/widgets/buttons/beranda_merchant_category.dart'; 
import 'package:haphap_fe/presentation/widgets/cards/restaurant_card.dart'; 
import 'package:haphap_fe/presentation/widgets/navigations/navigation_bar.dart';

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
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER OREN ---
            _buildHeader(context),
            
            // --- KONTEN BAWAH (Di-grup dan ditarik 60px ke atas) ---
            Transform.translate(
              offset: const Offset(0, -60), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // 1. KARTU STATISTIK
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        const HapHapStatsCard(
                          title: 'Berhasil Hemat',
                          prefixText: 'Rp ',
                          mainValue: '67.6rb',
                          valueColor: Colors.green, 
                          subtitle: 'Sejak 6 Juli 2026',
                        ),
                        
                        // Jarak antar Stats Card = 16
                        const SizedBox(width: 16), 
                        
                        HapHapStatsCard(
                          title: 'Berhasil Selamatin',
                          mainValue: '67 Porsi',
                          valueColor: AppColors.primary,
                          subtitle: 'Sejak 6 Juli 2026',
                        ),
                      ],
                    ),
                  ),

                  // Jarak dari Stats Card ke Kategori = 32
                  const SizedBox(height: 32), 
                  
                  // 2. BAGIAN KATEGORI
                  _buildKategoriSection(),
                  
                  // Jarak dari Kategori ke Sekitar Kamu = 32
                  const SizedBox(height: 32),
                  
                  // 3. BAGIAN SEKITAR KAMU
                  _buildSekitarKamuSection(),
                  
                  // Padding ekstra di bawah agar konten terakhir tidak tertutup Nav Bar
                  const SizedBox(height: 80), 
                ],
              ),
            ),
          ],
        ),
      ),

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
          HapHapSearchBar(
            hintText: 'Mau makan apa hari ini?',
            prefixIconPath: AppIcons.magnifying_glass,
          ),
          const SizedBox(height: 24),
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
              // --- SUDAH DIGANTI MENJADI IMAGE.ASSET (PNG) ---
              Image.asset(
                'assets/images/puy_beranda.png',
                width: 120, 
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
              const SizedBox(width: 20),
              HapHapCategoryButton(iconPath: AppIcons.restaurant, label: 'Restoran', onTap: () {}),
              const SizedBox(width: 20),
              HapHapCategoryButton(iconPath: AppIcons.cafe, label: 'Kafe', onTap: () {}),
              const SizedBox(width: 20),
              HapHapCategoryButton(iconPath: AppIcons.grocery, label: 'Grocery', onTap: () {}),
              const SizedBox(width: 20),
              HapHapCategoryButton(iconPath: AppIcons.jajanan, label: 'Jajanan', onTap: () {}),
              const SizedBox(width: 20),
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
                imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400', 
                distanceTime: '1.67 km · 67 menit',
                restaurantName: 'Cal\'s Chicken Bowl',
                ratingText: '4.8 · 6,7 rb+ rating',
              ),
              SizedBox(width: 16),
              HapHapRestaurantCard(
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