// import 'package:flutter/material.dart';
// import 'package:haphap_fe/core/theme/app_colors.dart';
// import 'package:haphap_fe/presentation/pages/splash/splash_screen.dart';
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'HapHap',
//       theme: ThemeData(useMaterial3: true, colorSchemeSeed: AppColors.primary),
//       home: const SplashScreen(),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';
import 'package:haphap_fe/presentation/widgets/inputs/text_fields.dart';
import 'package:haphap_fe/presentation/widgets/buttons/onboarding_buttons.dart';
import 'package:haphap_fe/presentation/widgets/buttons/beranda_category.dart';
import 'package:haphap_fe/presentation/widgets/buttons/beranda_merchant_category.dart';
import 'package:haphap_fe/presentation/widgets/cards/beranda_stats.dart';
import 'package:haphap_fe/presentation/widgets/cards/restaurant_card.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_proses.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_status_pesanan.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_riwayat.dart';
import 'package:haphap_fe/presentation/widgets/cards/menu_card.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_detail_pesanan.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_rincian_pembayaran.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_qr.dart';
import 'package:haphap_fe/presentation/widgets/inputs/checkbox.dart'; 
import 'package:haphap_fe/core/constants/app_icons.dart'; 
import 'package:haphap_fe/presentation/widgets/inputs/search_bar.dart'; 
import 'package:haphap_fe/presentation/widgets/navigations/navigation_bar.dart';
import 'package:haphap_fe/presentation/widgets/navigations/tab_bar.dart';
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';
import 'package:haphap_fe/presentation/widgets/cards/aktivitas_lainnya.dart';

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
  int _szechuanCartCount = 0;
  
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


                // --- SECTION 5: HOME CARDS (BARU) ---
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
                    // PANGGIL GAMBAR ASSET-NYA DI SINI:
                    imageAssetPath: 'assets/images/statscard-money.svg', 
                  ),
                  const HapHapStatsCard(
                    title: 'Berhasil Selamatin',
                    mainValue: '67 Porsi',
                    valueColor: AppColors.primary,
                    subtitle: 'Sejak 6 Juli 2026',
                    // PANGGIL GAMBAR ASSET-NYA DI SINI:
                    imageAssetPath: 'assets/images/statscard-piggybank.svg', 
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

                // --- SECTION 8: AKTIVITAS CARDS ---
                const Text('8. Aktivitas Cards', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                // 1. Varian Menunggu (Waiting)
                const HapHapAktivitasCard(
                  statusText: 'Makanan lagi dikonfirmasi nih!',
                  mainText: 'Ditunggu...',
                  restaurantName: 'Cal\'s Chicken Bowl',
                  imagePath: 'assets/images/aktivitas_puy_waiting.png',
                ),
                const SizedBox(height: 16),

                // 2. Varian Proses (Processing)
                const HapHapAktivitasCard(
                  statusText: 'Makanan lagi disiapin nih!',
                  mainText: '67 menit lagi...',
                  restaurantName: 'Cal\'s Chicken Bowl',
                  imagePath: 'assets/images/aktivitas_puy_processing.png',
                ),
                const SizedBox(height: 16),

                // 3. Varian Selesai (Done)
                const HapHapAktivitasCard(
                  statusText: 'Makanan sudah siap nih!',
                  mainText: 'Yuk ambil!',
                  restaurantName: 'Cal\'s Chicken Bowl',
                  imagePath: 'assets/images/aktivitas_puy_done.png',
                ),
                const SizedBox(height: 40),

                // --- SECTION 9: STATUS PESANAN CARDS ---
                const Text('9. Status Pesanan Cards', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // 1. Pesanan Selesai
                const HapHapStatusPesananCard(
                  dateStatusText: 'Hari ini, 06.07 · Diterima',
                  mainTitle: 'Pesanan Selesai',
                  imagePath: 'assets/images/done.png',
                ),
                const SizedBox(height: 16),

                // 2. Pesanan Diproses
                const HapHapStatusPesananCard(
                  dateStatusText: 'Hari ini, 06.07 · Disiapin',
                  mainTitle: 'Pesanan Diproses',
                  imagePath: 'assets/images/on_process.png',
                ),
                const SizedBox(height: 16),

                // 3. Pesanan Gagal
                const HapHapStatusPesananCard(
                  dateStatusText: 'Hari ini, 06.07 · Dibatalkan',
                  mainTitle: 'Pesanan Gagal',
                  imagePath: 'assets/images/cancelled.png',
                ),
                const SizedBox(height: 40),

                // --- SECTION 10: RIWAYAT CARDS ---
                const Text('10. Riwayat Cards', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                // Variasi 1: Selesai & Beri Rating
                HapHapRiwayatCard(
                  imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
                  dateStatusText: 'Hari ini, 06.07 · Diterima',
                  restaurantName: 'Cal\'s Chicken Bowl',
                  price: 'Rp 125.000',
                  buttonText: 'Beri Rating',
                  onButtonPressed: () {
                    print("Buka modal rating!");
                  },
                ),
                const SizedBox(height: 16),

                // Variasi 2: Riwayat Lama & Pesan Lagi
                HapHapRiwayatCard(
                  imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
                  dateStatusText: 'Kemarin, 06.07 · Diterima',
                  restaurantName: 'Cal\'s Chicken Bowl',
                  price: 'Rp 25.000',
                  buttonText: 'Pesan Lagi',
                  onButtonPressed: () {
                    print("Masuk ke halaman resto!");
                  },
                ),
                const SizedBox(height: 40),

                // --- SECTION 11: MENU CARDS (Jelajah) ---
                const Text('11. Menu Cards (Jelajah)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                // Kartu Menu yang interaktif!
                HapHapMenuCard(
                  imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=400',
                  title: 'Szechuan Chicken Bowl',
                  description: 'Nasi + Ayam Saus Szechuan',
                  price: 'Rp 25.000',
                  stockCount: 2, // Anggap sisa stok ada 2
                  
                  // 1. Masukkan variabel state ke cartCount
                  cartCount: _szechuanCartCount, 
                  
                  // 2. Logika ketika tombol (+) ditekan
                  onAdd: () {
                    setState(() {
                      // Kita cegah user nambah melebihi stok yang ada
                      if (_szechuanCartCount < 2) {
                        _szechuanCartCount++;
                      } else {
                        // (Opsional) Bisa kasih tau kalau stok habis
                        print('Maksimal pesanan tercapai!'); 
                      }
                    });
                  },
                  
                  // 3. Logika ketika tombol (-) ditekan
                  onRemove: () {
                    setState(() {
                      // Cegah angka jadi minus
                      if (_szechuanCartCount > 0) {
                        _szechuanCartCount--;
                      }
                    });
                  },
                ),

                // --- SECTION 12: DETAIL PESANAN CARD ---
                const Text('12. Detail Pesanan Card', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                HapHapDetailPesananCard(
                  restaurantName: 'Cal\'s Chicken Bowl',
                  restaurantLogoUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&q=80&w=100', // Pakai gambar ayam sementara
                  items: const [
                    HapHapOrderItem(
                      name: 'Szechuan Chicken Bowl',
                      description: 'Nasi + Ayam Saus Szechuan',
                      price: 'Rp 25.000',
                      quantity: 2,
                    ),
                    HapHapOrderItem(
                      name: 'Blackpepper Chicken Bowl',
                      description: 'Nasi + Ayam Saus Blackpepper',
                      price: 'Rp 25.000',
                      quantity: 2,
                    ),
                    HapHapOrderItem(
                      name: 'Salted Egg Chicken Bowl',
                      description: 'Nasi + Ayam Saus Salted Egg',
                      price: 'Rp 25.000',
                      quantity: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // --- SECTION 13: RINCIAN PEMBAYARAN ---
                const Text('13. Rincian Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                HapHapRincianPembayaran(
                  paymentMethod: 'QRIS',
                  totalPrice: 'Rp 125.000',
                  orderNumber: 'S6I7X6S7E6V7E6N7',
                  paymentTime: '6 Juli 2026, 06.07',
                  completionTime: '7 Juli 2026, 06.07',
                  onReceiptPressed: () {
                    print("Buka modal/halaman E-Receipt");
                  },
                ),
                const SizedBox(height: 40),

                // --- SECTION 14: QR PEMBAYARAN ---
                const Text('14. QR Code Card', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                const Center(
                  child: HapHapQRCodeCard(
                    orderId: 'S6I7X6S7E6V7E6N7',
                    qrImagePath: 'assets/images/qr_code.png', // Ganti dengan path QR-mu
                  ),
                ),
                const SizedBox(height: 40),

                // --- SECTION 15: PAGE HEADER ---
                const Text('15. Page Header', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                const HapHapPageHeader(
                  title: 'Detail Pesanan',
                ),
                const SizedBox(height: 40),

                // --- SECTION 16: AKTIVITAS LAINNYA CARD ---
                const Text('16. Aktivitas Lainnya Card', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                const HapHapAktivitasLainnyaCard(
                  title: 'HapHap lagi ada promo spesial nih 😋',
                  subtitle: 'Ayo buruan pesan sebelum kehabisan!',
                  imagePath: 'assets/images/logo_haphap.png', // Sesuaikan dengan nama file gambarmu
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
