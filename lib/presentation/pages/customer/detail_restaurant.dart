import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/router/app_routes.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

// --- IMPORT KOMPONEN LEGO KITA ---
import 'package:haphap_fe/presentation/widgets/cards/restaurant_card.dart';
import 'package:haphap_fe/presentation/widgets/cards/menu_card.dart'; // Sesuaikan path jika beda

class DetailRestoranPage extends StatefulWidget {
  const DetailRestoranPage({super.key});

  @override
  State<DetailRestoranPage> createState() => _DetailRestoranPageState();
}

class _DetailRestoranPageState extends State<DetailRestoranPage> {
  // Dummy State untuk Keranjang
  int _cartTotalItems = 1;
  int _cartTotalPrice = 25000;

  // Dummy State untuk Menu
  int _szechuanCartCount = 1;
  int _blackpepperCartCount = 0;

  void _updateCart() {
    setState(() {
      _cartTotalItems = _szechuanCartCount + _blackpepperCartCount;
      _cartTotalPrice = (_szechuanCartCount * 25000) + (_blackpepperCartCount * 25000);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HERO SECTION (Banner Merchant + Overlap Card)
            _buildHeroSection(),
            
            // JARAK 24px DARI HERO KE TITLE MENU
            const SizedBox(height: 24),
            
            // 2. DAFTAR MENU (Pesanan terakhir dihilangkan sementara)
            _buildDaftarMenuSection(),
            
            // Jarak ekstra di bawah biar menu paling bawah gak ketutupan dialog keranjang
            const SizedBox(height: 120), 
          ],
        ),
      ),
      
      // 3. FLOATING CART BOTTOM DIALOG (Muncul kalau ada barang)
      bottomNavigationBar: _cartTotalItems > 0 ? _buildFloatingCart() : const SizedBox.shrink(),
    );
  }

  // ===========================================================================
  // WIDGET HELPERS
  // ===========================================================================

  Widget _buildHeroSection() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // 1. BANNER TOKO
        SizedBox(
          width: double.infinity,
          height: 220,
          child: Image.network(
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&q=80&w=1000', 
            fit: BoxFit.cover,
          ),
        ),
        
        // 2. OVERLAP RESTAURANT CARD 
        const Padding(
          padding: EdgeInsets.only(top: 160, left: 24, right: 24), 
          child: HapHapRestaurantCard(
            imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
            distanceTime: '1.67 km - 67 menit',
            restaurantName: "Cal's Chicken Bowl",
            ratingText: '4.8 - 6,7 rb+ rating',
          ),
        ),
      ],
    );
  }

  Widget _buildDaftarMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Cal's Chicken Bowl",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
          ),
        ),
        
        // JARAK 16px DARI TITLE KE KARTU MENU PERTAMA
        const SizedBox(height: 16),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              HapHapMenuCard( 
                imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
                title: 'Szechuan Chicken Bowl',
                description: 'Nasi + Ayam Saus Szechuan',
                price: 'Rp 25.000',
                stockCount: 2,
                cartCount: _szechuanCartCount,
                onAdd: () {
                  if (_szechuanCartCount < 2) {
                    setState(() => _szechuanCartCount++);
                    _updateCart();
                  }
                },
                onRemove: () {
                  if (_szechuanCartCount > 0) {
                    setState(() => _szechuanCartCount--);
                    _updateCart();
                  }
                },
              ),
              const SizedBox(height: 16), // Jarak antar kartu menu
              HapHapMenuCard(
                imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
                title: 'Blackpepper Chicken Bowl',
                description: 'Nasi + Ayam Saus Blackpepper',
                price: 'Rp 25.000',
                stockCount: 2,
                cartCount: _blackpepperCartCount,
                onAdd: () {
                  if (_blackpepperCartCount < 2) {
                    setState(() => _blackpepperCartCount++);
                    _updateCart();
                  }
                },
                onRemove: () {
                  if (_blackpepperCartCount > 0) {
                    setState(() => _blackpepperCartCount--);
                    _updateCart();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingCart() {
    // Mengambil ukuran safe area bawah (buat iPhone berponi/bergaris bawah)
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return Container(
      // Tinggi 81px + safe area bawah agar tidak nabrak garis iPhone
      height: 81 + bottomSafeArea, 
      padding: EdgeInsets.only(
        left: 20, // Padding kiri tombol 20px
        right: 20, // Padding kanan tombol 20px
        bottom: bottomSafeArea, 
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), // Radius atas
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08), // Efek shadow lembut
            blurRadius: 16,
            offset: const Offset(0, -4), // Arah shadow ke atas
          ),
        ],
      ),
      // Center akan menengahkan tombol secara vertikal di dalam area 81px
      child: Center( 
        child: InkWell(
          onTap: () {
            context.push(AppRoutes.checkout);
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 48, // Standar tinggi tombol
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.primary, 
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Keranjang - $_cartTotalItems Hidangan',
                  style: const TextStyle(
                    fontSize: 16, // Font size 16px
                    fontWeight: FontWeight.bold, 
                    color: AppColors.white
                  ),
                ),
                Text(
                  'Rp ${_cartTotalPrice.toStringAsFixed(0)}', 
                  style: const TextStyle(
                    fontSize: 16, // Font size 16px
                    fontWeight: FontWeight.bold, 
                    color: AppColors.white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}