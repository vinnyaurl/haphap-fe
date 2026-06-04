import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/core/constants/app_icons.dart';

// --- IMPORT KOMPONEN KITA ---
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/presentation/widgets/inputs/search_bar.dart'; 
import 'package:haphap_fe/presentation/widgets/buttons/button.dart'; 

class AlamatPage extends StatefulWidget {
  const AlamatPage({super.key});

  @override
  State<AlamatPage> createState() => _AlamatPageState();
}

class _AlamatPageState extends State<AlamatPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            // 1. HEADER (Menggunakan komponen HapHapPageHeader)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: HapHapPageHeader(
                title: 'Alamat',
              ),
            ),
            
            // 2. SEARCH BAR (Menggunakan komponen HapHapSearchBar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: HapHapSearchBar(
                hintText: 'Dimana lokasimu sekarang?',
                prefixIconPath: AppIcons.location,
                suffixIconPath: _searchController.text.isNotEmpty ? AppIcons.circle_xmark : null,
                controller: _searchController,
                onSuffixTap: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
              ),
            ),

            // 3. DAFTAR ALAMAT & BANTUAN (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daftar Alamat
                    _buildAddressItem(
                      icon: Icons.gps_fixed, 
                      title: 'Rumah denis bagus',
                      address: 'Jalan Taman Duta Mas No. 67, Grogol Petamburan, Jelambar Baru, Kota Jakarta Barat, DKI Jakarta, Indonesia.',
                    ),
                    _buildAddressItem(
                      icon: Icons.schedule, 
                      title: 'Rumah denis nis nis',
                      address: 'Jalan Taman Duta Mas No. 67, Grogol Petamburan, Jelambar Baru, Kota Jakarta Barat, DKI Jakarta, Indonesia.',
                    ),
                    _buildAddressItem(
                      icon: Icons.location_on, 
                      title: 'Rumah ander nies',
                      address: 'Jalan Taman Duta Mas No. 67, Grogol Petamburan, Jelambar Baru, Kota Jakarta Barat, DKI Jakarta, Indonesia.',
                    ),
                    _buildAddressItem(
                      icon: Icons.location_on, 
                      title: 'Rumah denis',
                      address: 'Jalan Taman Duta Mas No. 67, Grogol Petamburan, Jelambar Baru, Kota Jakarta Barat, DKI Jakarta, Indonesia.',
                      isLast: true, 
                    ),

                    // Bagian Bantuan 
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => print('Bantuan ditekan'),
                            child: const Text(
                              'Butuh Bantuan?',
                              style: TextStyle(
                                fontSize: 16, // Update ke 16px
                                fontWeight: FontWeight.bold,
                                color: AppColors.black, 
                              ),
                            ),
                          ),
                          const SizedBox(height: 16), // Gap 16px
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.map_outlined, color: AppColors.primary, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(fontSize: 16, color: AppColors.greyDark, height: 1.4), // Update ke 16px
                                    children: [
                                      TextSpan(text: 'Nggak nemu tempat atau melihat detail yang salah? '),
                                      TextSpan(
                                        text: 'Yuk beri tahu kami.',
                                        style: TextStyle(color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40), 
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // 4. TOMBOL SIMPAN
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  // ===========================================================================
  // WIDGET HELPERS
  // ===========================================================================

  Widget _buildAddressItem({
    required IconData icon,
    required String title,
    required String address,
    bool isLast = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            print('Pilih alamat: $title');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.primary, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16, // Update ke 16px
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address,
                        style: const TextStyle(
                          fontSize: 14, // Update ke 14px
                          color: AppColors.greyLight,
                          height: 1.4,
                        ),
                        maxLines: 3, 
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Garis pemisah antar list
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                //SizedBox(height: 16), // Jarak ke divider 16px
                Divider(color: AppColors.greyLight, height: 0.5, thickness: 1),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBottomButton() {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;
    
    return Container(
      padding: EdgeInsets.only(
        left: 24, 
        right: 24, 
        top: 16, 
        bottom: bottomSafeArea > 0 ? bottomSafeArea : 24,
      ),
      color: const Color(0xFFF9F9F9),
      child: Center(
        heightFactor: 1, 
        child: HapHapButton(
          text: 'Simpan',
          size: HapHapButtonSize.large,
          onPressed: () {
            print('Alamat Disimpan!');
            context.pop(); 
          },
        ),
      ),
    );
  }
}