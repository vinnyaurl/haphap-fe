import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Wajib import ini buat navigasi
import 'package:haphap_fe/core/router/app_routes.dart'; // Wajib import ini buat AppRoutes
import 'package:haphap_fe/core/constants/app_icons.dart';

// --- IMPORT KOMPONEN LEGO DARI PLAYGROUND KAMU ---
import 'package:haphap_fe/presentation/widgets/inputs/search_bar.dart';
import 'package:haphap_fe/presentation/widgets/buttons/beranda_category.dart';
import 'package:haphap_fe/presentation/widgets/cards/restaurant_card.dart';

class JelajahPage extends StatefulWidget {
  const JelajahPage({super.key});

  @override
  State<JelajahPage> createState() => _JelajahPageState();
}

class _JelajahPageState extends State<JelajahPage> {
  final TextEditingController _searchController = TextEditingController();
  
  int _selectedCategoryIndex = 0;
  
  final List<String> _categories = [
    'All', 
    'Restoran', 
    'Kafe', 
    'Bakery', 
    'Grosir'
  ];

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: HapHapSearchBar(
                  hintText: 'Mau makan apa hari ini?',
                  prefixIconPath: AppIcons.magnifying_glass,
                  controller: _searchController,
                ),
              ),
              
              const SizedBox(height: 16), 
              
              // 2. CATEGORY PILLS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: List.generate(_categories.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: HapHapCategoryPill(
                        label: _categories[index],
                        isSelected: _selectedCategoryIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                      ),
                    );
                  }),
                ),
              ),
              
              const SizedBox(height: 16), 

              // 3. RESTAURANT LIST
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: List.generate(5, (index) {
                    // DIUBAH: Hilangkan 'const' di Padding ini karena ada fungsi onTap yang dinamis
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0), 
                      // --- INI DIA GESTURE DETECTOR-NYA ---
                      child: GestureDetector(
                        onTap: () {
                          // Lempar ke halaman detail restoran!
                          context.push(AppRoutes.detailRestoran); 
                        },
                        child: const HapHapRestaurantCard(
                          imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
                          distanceTime: '1.67 km - 67 menit',
                          restaurantName: 'Cal\'s Chicken Bowl',
                          ratingText: '4.8 - 6,7 rb+ rating',
                        ),
                      ),
                    );
                  }),
                ),
              ),
              
              const SizedBox(height: 40), 
            ],
          ),
        ),
      ),
    );
  }
}