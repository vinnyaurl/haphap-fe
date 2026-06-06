import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_add_menu.dart';
import 'package:haphap_fe/presentation/widgets/cards/merchant_menu_list.dart';
import 'package:haphap_fe/presentation/widgets/dialog/merchant_delete_menu_dialog.dart';
import 'package:haphap_fe/presentation/widgets/dialog/merchant_edit_menu_dialog.dart';
import 'package:haphap_fe/presentation/widgets/inputs/search_bar.dart';

// --- IMPORT KOMPONEN HEADER KITA ---
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/data/services/surplus_service.dart';
import 'package:haphap_fe/data/models/merchant_model.dart';

class MenuMerchantPage extends StatefulWidget {
  const MenuMerchantPage({super.key});

  @override
  State<MenuMerchantPage> createState() => _MenuMerchantPageState();
}

class _MenuMerchantPageState extends State<MenuMerchantPage> {
  List<SurplusItemModel> _items = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final items = await SurplusService.getMySurplus();
      if (!mounted) return;
      setState(() {
        _items = items;
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

  void _showAddMenuDialog() {
    showDialog(
      context: context,
      builder: (context) => const HapHapAddMenuDialog(),
    ).then((_) => _fetchItems()); // Refresh list after adding
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _errorMessage != null
                      ? Center(child: Text('Error: $_errorMessage'))
                      : _items.isEmpty
                          ? const Center(child: Text('Belum ada menu, tambahkan sekarang!'))
                          : ListView.separated(
                              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100), 
                              itemCount: _items.length, 
                              
                              separatorBuilder: (context, index) => const Divider(
                                height: 32, 
                                thickness: 1,
                                color: Color(0xFFF1F1F1),
                              ),
                              
                              itemBuilder: (context, index) {
                                final item = _items[index];
                                final menuTitle = item.name;
                                final menuDesc = item.description ?? '';
                                final menuPrice = 'Rp ${_formatPrice(item.discountPrice)}';

                                return HapHapMerchantMenuItemCard(
                                  title: menuTitle,
                                  description: menuDesc,
                                  price: menuPrice,
                                  imageUrl: (item.image != null && item.image!.isNotEmpty)
                                      ? item.image!
                                      : 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
                                  
                                  onEdit: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => HapHapEditMenuDialog(
                                        surplusItemId: item.surplusItemId,
                                        initialName: menuTitle,
                                        initialPrice: menuPrice,
                                        initialDesc: menuDesc,
                                      ),
                                    ).then((_) => _fetchItems()); // Refresh list after edit
                                  },
                                  
                                  onDelete: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => HapHapDeleteMenuDialog(
                                        menuName: menuTitle,
                                      ),
                                    ).then((_) => _fetchItems()); // Refresh list after delete
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