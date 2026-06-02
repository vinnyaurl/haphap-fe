import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/core/constants/app_icons.dart';

import 'package:haphap_fe/presentation/widgets/headers/page_header.dart'; 

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'QRIS'; 

  int _szechuanCount = 2;
  int _blackpepperCount = 2;
  int _saltedEggCount = 1;

  int get _totalPrice {
    return (_szechuanCount * 25000) + (_blackpepperCount * 25000) + (_saltedEggCount * 25000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: HapHapPageHeader(
                  title: "Cal's Chicken Bowl",
                ),
              ),
              
              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rangkuman Pesanan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pop(); 
                      },
                      child: const Text(
                        'Tambah Pesanan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_szechuanCount > 0) ...[
                        _buildCartItem(
                          imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
                          title: 'Szechuan Chicken Bowl',
                          description: 'Nasi + Ayam Saus Szechuan',
                          price: 'Rp 25.000',
                          count: _szechuanCount,
                          onAdd: () => setState(() => _szechuanCount++),
                          onRemove: () => setState(() => _szechuanCount--),
                        ),
                        const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
                      ],
                      
                      if (_blackpepperCount > 0) ...[
                        _buildCartItem(
                          imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
                          title: 'Blackpepper Chicken Bowl',
                          description: 'Nasi + Ayam Saus Blackpepper',
                          price: 'Rp 25.000',
                          count: _blackpepperCount,
                          onAdd: () => setState(() => _blackpepperCount++),
                          onRemove: () => setState(() => _blackpepperCount--),
                        ),
                        const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
                      ],

                      if (_saltedEggCount > 0) ...[
                        _buildCartItem(
                          imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
                          title: 'Salted Egg Chicken Bowl',
                          description: 'Nasi + Ayam Saus Salted Egg',
                          price: 'Rp 25.000',
                          count: _saltedEggCount,
                          onAdd: () => setState(() => _saltedEggCount++),
                          onRemove: () => setState(() => _saltedEggCount--),
                        ),
                        const Divider(color: Color(0xFFF1F1F1), height: 1, thickness: 1),
                      ],

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rincian Pembayaran',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(fontSize: 14, color: AppColors.greyDark),
                                ),
                                Text(
                                  'Rp ${_totalPrice.toStringAsFixed(0)}', 
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 140), 
            ],
          ),
        ),
      ),
      
      bottomNavigationBar: _buildCheckoutBottomBar(),
    );
  }

  Widget _buildCartItem({
    required String imageUrl,
    required String title,
    required String description,
    required String price,
    required int count,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 12, color: AppColors.greyDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: onRemove,
                            behavior: HitTestBehavior.opaque,
                            child: const Icon(Icons.remove_circle, color: AppColors.primary, size: 24),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              '$count',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black),
                            ),
                          ),
                          GestureDetector(
                            onTap: onAdd,
                            behavior: HitTestBehavior.opaque,
                            child: const Icon(Icons.add_circle, color: AppColors.primary, size: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBottomBar() {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24, 
        right: 24, 
        top: 20, 
        bottom: bottomSafeArea > 0 ? bottomSafeArea : 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // BARIS 1: Metode Pembayaran
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  _selectedPaymentMethod == 'QRIS'
                      ? SvgPicture.asset(AppIcons.QRIS, height: 24) // Tinggi disamakan dengan icon 24px
                      : const Icon(Icons.payments, color: Colors.green, size: 24),
                  
                  // Gap 12px antara icon dan teks
                  const SizedBox(width: 12), 
                  
                  // Teks Metode Pembayaran
                  Text(
                    _selectedPaymentMethod,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _showPaymentMethodDialog,
                child: const Text(
                  'Ubah',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // BARIS 2: Tombol Buat Pesanan
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                print("Pesanan Dibuat pakai $_selectedPaymentMethod!");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Buat Pesanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 34),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Metode Pembayaran',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 24),
              
              _buildPaymentOption(
                title: 'Cash',
                icon: const Icon(Icons.payments, color: Colors.green, size: 24),
                value: 'Cash',
              ),
              
              const SizedBox(height: 24),
              
              _buildPaymentOption(
                title: 'QRIS', 
                icon: SvgPicture.asset(AppIcons.QRIS, height: 24), // Tinggi disamakan dengan Cash
                value: 'QRIS',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required Widget icon,
    required String value,
  }) {
    bool isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
        Navigator.pop(context); 
      },
      child: Container(
        color: Colors.transparent, 
        child: Row(
          children: [
            icon,
            
            // Gap 12px
            const SizedBox(width: 12), 
            
            // Teks selalu ditampilkan
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
            ),
            const Spacer(),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.greyLight,
                  width: isSelected ? 6 : 1, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}