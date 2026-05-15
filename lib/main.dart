import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/pages/splash/splash_screen.dart';
import 'package:haphap_fe/presentation/pages/customer/beranda.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HapHap',
      theme: ThemeData(
        useMaterial3: true, 
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ),
        colorSchemeSeed: AppColors.primary),
      // home: const SplashScreen(),
      home: const BerandaPage(),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart';
import 'package:haphap_fe/presentation/widgets/buttons/onboarding_buttons.dart';
import 'package:haphap_fe/presentation/widgets/buttons/beranda_category.dart';
import 'package:haphap_fe/presentation/widgets/buttons/beranda_merchant_category.dart';
import 'package:haphap_fe/presentation/widgets/cards/beranda_stats.dart';
import 'package:haphap_fe/presentation/widgets/cards/restaurant_card.dart';
import 'package:haphap_fe/presentation/widgets/inputs/checkbox.dart'; 
import 'package:haphap_fe/core/constants/app_icons.dart'; // Import class konstantamu
import 'package:haphap_fe/presentation/widgets/inputs/search_bar.dart'; 
import 'package:haphap_fe/presentation/widgets/navigations/navigation_bar.dart';
import 'package:haphap_fe/presentation/widgets/navigations/tab_bar.dart';

void main() {
  runApp(const HapHapPlayground());
}

// 1. Sekarang jadi StatefulWidget
class HapHapPlayground extends StatefulWidget {
  const HapHapPlayground({super.key});

  @override
  State<HapHapPlayground> createState() => _HapHapPlaygroundState();
}

class _HapHapPlaygroundState extends State<HapHapPlayground> {
  // 2. Variabel untuk menyimpan status Checkbox (default: false / tidak dicentang)
  bool isRememberMeChecked = false;
  int _currentNavIndex = 0; // Menyimpan indeks tab yang sedang aktif
  bool _isMerchantMode = false; // Toggle untuk ngetes UI User / Merchant
  int _currentTabIndex = 0; // Untuk menyimpan tab aktivitas mana yang aktif

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HapHap UI',
      home: Scaffold(
        appBar: AppBar(
          // Judul berubah otomatis tergantung mode
          title: Text(_isMerchantMode ? 'Playground (Merchant)' : 'Playground (User)'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          actions: [
            // Tombol di pojok kanan atas untuk ganti role
            IconButton(
              icon: Icon(_isMerchantMode ? Icons.store : Icons.person),
              onPressed: () {
                setState(() {
                  _isMerchantMode = !_isMerchantMode; // Balikkan status
                  _currentNavIndex = 0; // Reset ke tab Beranda tiap ganti role
                });
              },
            )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- SECTION 1: BUTTONS ---
                const Text('1. Buttons', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                HapHapButton(text: 'Masuk', size: HapHapButtonSize.large, onPressed: () {}),
                const SizedBox(height: 8),
                HapHapButton(text: 'Daftar Sekarang', size: HapHapButtonSize.large, isOutline: true, onPressed: () {}),
                const SizedBox(height: 40),

                // --- SECTION 2: TEXT FIELDS ---
                const Text('2. Text Fields', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                HapHapTextField(
                  labelText: 'Alamat Email',
                  hintText: 'PuyPuy@gmail.com',
                  controller: TextEditingController(), 
                ),
                const SizedBox(height: 16),
                HapHapTextField(
                  labelText: 'Kata Sandi',
                  hintText: 'PuyPuyTopuy',
                  controller: TextEditingController(),
                  isPassword: true, 
                  isRequired: true,
                ),
                const SizedBox(height: 40),

                // --- SECTION 3: ONBOARDING BUTTONS ---
                const Text('3. Onboarding Buttons', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: AppColors.greyLight, // Background sementara biar tombol putih kelihatan
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HapHapSkipButton(onPressed: () {}, isWhiteVariant: true),
                      HapHapSkipButton(onPressed: () {}, isWhiteVariant: false),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HapHapOnboardingNextButton(progress: 0.33, onPressed: () {}),
                    HapHapOnboardingNextButton(progress: 1.0, onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 40),

                // --- SECTION 4: CHECKBOX (BARU) ---
                const Text('4. Checkbox', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                // Ini cara ngetes Checkbox-nya!
                HapHapCheckbox(
                  label: 'Ingat Saya',
                  value: isRememberMeChecked, // Lempar nilai false/true saat ini
                  onChanged: (newValue) {
                    // setState akan me-render ulang layar saat diklik
                    setState(() {
                      isRememberMeChecked = newValue ?? false;
                    });
                  },
                ),
                const SizedBox(height: 40),


                // --- SECTION 5: HOME CARDS & PILLS ---
                const Text('5. Home Cards & Pills', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // Mengetes Stats Cards (Jejer ke samping)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HapHapStatsCard(
                      title: 'Berhasil Hemat',
                      prefixText: 'Rp ',
                      mainValue: '67.6rb',
                      valueColor: Colors.green, 
                      subtitle: 'Sejak 6 Juli 2026',
                      // imageAssetPath dihapus dari sini
                    ),
                    const HapHapStatsCard(
                      title: 'Berhasil Selamatin',
                      mainValue: '67 Porsi',
                      valueColor: AppColors.primary,
                      subtitle: 'Sejak 6 Juli 2026',
                      // imageAssetPath dihapus dari sini
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Mengetes Category Pills
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HapHapCategoryPill(label: 'All', isSelected: false, onTap: () {}),
                    const SizedBox(width: 8),
                    HapHapCategoryPill(label: 'Restoran', isSelected: true, onTap: () {}),
                    const SizedBox(width: 8),
                    HapHapCategoryPill(label: 'Kafe', isSelected: false, onTap: () {}),
                  ],
                ),
                const SizedBox(height: 24),

                // Mengetes Restaurant Card
                const HapHapRestaurantCard(
                  // Pakai gambar dari internet dulu buat ngetes
                  imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400', 
                  distanceTime: '1.67 km · 67 menit',
                  restaurantName: 'Cal\'s Chicken Bowl',
                  ratingText: '4.8 · 6,7 rb+ rating',
                ),
                const SizedBox(height: 40),

                // --- SECTION 6: CATEGORY ICON BUTTONS ---
                const Text('6. Category Icon Buttons', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HapHapCategoryButton(
                    iconPath: AppIcons.bakery, // Nah, ini baru pemanggilan ala Pro! 😎
                    label: 'Bakery',
                    onTap: () {},
                  ),
                  HapHapCategoryButton(
                    iconPath: AppIcons.restaurant, 
                    label: 'Restoran',
                    onTap: () {},
                  ),
                  HapHapCategoryButton(
                    iconPath: AppIcons.cafe, 
                    label: 'Kafe',
                    onTap: () {},
                  ),
                ],
              ),
                const SizedBox(height: 40),

                // --- SECTION 7: SEARCH BARS ---
                const Text('7. Search Bars', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // Variasi 1: Pencarian Makanan (Tanpa Suffix Icon)
                HapHapSearchBar(
                  hintText: 'Mau makan apa hari ini?',
                  prefixIconPath: AppIcons.magnifying_glass,
                  controller: TextEditingController(),
                ),

                const SizedBox(height: 16),

                // Variasi 2: Pencarian Lokasi (Dengan Suffix Icon / Tombol Silang)
                HapHapSearchBar(
                  hintText: 'Dimana lokasimu sekarang?',
                  prefixIconPath: AppIcons.location,
                  suffixIconPath: AppIcons.circle_xmark,
                  controller: TextEditingController(),
                  onSuffixTap: () {
                    // Logika saat tombol silang diklik (misal: menghapus teks di controller)
                    print("Tombol silang diklik!"); 
                  },
                ),
                const SizedBox(height: 40),

                // --- SECTION 9: TAB BAR AKTIVITAS ---
                const Text('9. Tab Bar Aktivitas', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                // Memanggil komponen Tab Bar
                HapHapTabBar(
                  currentIndex: _currentTabIndex,
                  onTap: (index) {
                    setState(() {
                      _currentTabIndex = index;
                    });
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        bottomNavigationBar: HapHapNavBar(
          currentIndex: _currentNavIndex,
          type: _isMerchantMode ? NavBarType.merchant : NavBarType.user,
          onTap: (index) {
            setState(() {
              _currentNavIndex = index;
            });
          },
        ),
      ),
    );
  }
}
*/