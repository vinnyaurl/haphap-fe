import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_add_menu.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_menu_list.dart';
import 'package:haphap_fe/presentation/widgets/dialog/merchant_delete_menu_dialog.dart';
import 'package:haphap_fe/presentation/widgets/dialog/merchant_edit_menu_dialog.dart';
import 'package:haphap_fe/presentation/widgets/inputs/search_bar.dart';

// --- IMPORT KOMPONEN HEADER KITA ---
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';

class MenuMerchantPage extends StatefulWidget {
  const MenuMerchantPage({super.key});

  @override
  State<MenuMerchantPage> createState() => _MenuMerchantPageState();
}

class _MenuMerchantPageState extends State<MenuMerchantPage> {

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
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16), // Jarak 16px dari atas (status bar)
            
            // 1. HEADER MENGGUNAKAN KOMPONEN
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: HapHapPageHeader(
                title: 'Menu',
                showBackButton: false, // Karena ini halaman utama tab, matikan tombol back
                fontSize: 24,          // Font dibesarkan sesuai desain
              ),
            ),
            
            const SizedBox(height: 16), // Jarak 16px dari header ke search bar
            
            // 2. SEARCH BAR 
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: HapHapSearchBar(
                hintText: 'Cari menu...',
                prefixIconPath: 'assets/icons/magnifying_glass.svg', 
              ),
            ),
            
            const SizedBox(height: 20), // Jarak dari search bar ke list menu
            
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
    );
  }
}