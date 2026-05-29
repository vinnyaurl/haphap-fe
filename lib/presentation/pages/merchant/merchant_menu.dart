import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_aktivitas.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_akun.dart';
import 'package:haphap_fe/presentation/pages/merchant/merchant_beranda.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_add_menu.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_menu_list.dart';
import 'package:haphap_fe/presentation/widgets/dialog/merchant_delete_menu_dialog.dart';
import 'package:haphap_fe/presentation/widgets/dialog/merchant_edit_menu_dialog.dart';
import 'package:haphap_fe/presentation/widgets/navigations/navigation_bar.dart';
import 'package:haphap_fe/presentation/widgets/inputs/search_bar.dart';

// --- IMPORT HALAMAN TUJUAN NAVIGASI ---
// Sesuaikan path ini dengan folder kamu yang sebenarnya

class MenuMerchantPage extends StatefulWidget {
  const MenuMerchantPage({super.key});

  @override
  State<MenuMerchantPage> createState() => _MenuMerchantPageState();
}

class _MenuMerchantPageState extends State<MenuMerchantPage> {
  int _currentNavIndex = 1; // Index 1 untuk Tab Menu

  void _showAddMenuDialog() {
    showDialog(
      context: context,
      builder: (context) => const HapHapAddMenuDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            // 1. JUDUL HALAMAN
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 2. SEARCH BAR 
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: HapHapSearchBar(
                hintText: 'Cari menu...',
                prefixIconPath: 'assets/icons/magnifying_glass.svg', 
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 3. DAFTAR MENU
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100), 
                itemCount: 4, 
                
                separatorBuilder: (context, index) => const Divider(
                  height: 32, 
                  thickness: 1,
                  color: Color(0xFFF1F1F1),
                ),
                
                itemBuilder: (context, index) {
                  String menuTitle = 'Szechuan Chicken Bowl';
                  String menuDesc = 'Nasi + Ayam Saus Szechuan';
                  String menuPrice = 'Rp 25.000';

                  return HapHapMerchantMenuItemCard(
                    title: menuTitle,
                    description: menuDesc,
                    price: menuPrice,
                    imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
                    
                    onEdit: () {
                      showDialog(
                        context: context,
                        builder: (context) => HapHapEditMenuDialog(
                          initialName: menuTitle,
                          initialPrice: menuPrice,
                          initialDesc: menuDesc,
                        ),
                      );
                    },
                    
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (context) => HapHapDeleteMenuDialog(
                          menuName: menuTitle,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      
      // 4. TOMBOL (+) MENGAMBANG
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenuDialog,
        backgroundColor: AppColors.primary, 
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: AppColors.white, size: 32),
      ),
      
      // 5. BOTTOM NAVIGATION BAR DENGAN ROUTING
      bottomNavigationBar: HapHapNavBar(
        currentIndex: _currentNavIndex,
        type: NavBarType.merchant, 
        onTap: (index) {
          if (_currentNavIndex == index) return;
          
          setState(() => _currentNavIndex = index);

          // --- LOGIKA PERPINDAHAN HALAMAN ---
          switch (index) {
            case 0: // Index 0 = Beranda
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BerandaMerchantPage()),
              );
              break;
            case 1: // Index 1 = Menu
              // Sudah berada di halaman ini, jadi tidak melakukan apa-apa
              break;
            case 2: // Index 2 = Aktivitas
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AktivitasMerchantPage()),
              );
              break;
            case 3: // Index 3 = Akun
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