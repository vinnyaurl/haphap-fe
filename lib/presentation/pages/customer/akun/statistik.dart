import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/cards/akun_gelar_card.dart';
import 'package:haphap_fe/presentation/widgets/cards/akun_statistik_pribadi.dart';

// --- IMPORT KOMPONEN LEGO KITA ---
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';

class StatistikPage extends StatelessWidget {
  const StatistikPage({super.key});

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
              
              // 1. HEADER
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: HapHapPageHeader(
                  title: 'Statistik',
                ),
              ),
              
              const SizedBox(height: 16),

              // 2. KARTU STATISTIK 1 (Menghemat Uang)
              // KUNCI: Dibungkus Padding horizontal 24px
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: HapHapStatistikPribadiCard(
                  title: 'Kamu berhasil menghemat',
                  valuePrefix: 'Rp ',
                  value: '67.067',
                  valueColor: Colors.green, 
                  dateText: 'Sejak 6 Juli 2026',
                  imagePath: 'assets/images/piggy_bank.png', // Pastikan asset ini ada
                ),
              ),

              // KUNCI: Jarak 16px antar kartu
              const SizedBox(height: 16), 

              // 3. KARTU STATISTIK 2 (Menyelamatkan Porsi)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: HapHapStatistikPribadiCard(
                  title: 'Kamu udah menyelamatkan',
                  valuePrefix: '',
                  value: '67 Porsi',
                  valueColor: AppColors.primary, 
                  dateText: 'Sejak 6 Juli 2026',
                  imagePath: 'assets/images/puy_kenyang.png', // Pastikan asset ini ada
                ),
              ),

              // KUNCI: Jarak 16px antar kartu
              const SizedBox(height: 16),

              // 4. KARTU GELAR 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: HapHapGelarCard(
                  gelar: 'Pejuang Hemat',
                  imagePath: 'assets/images/gelar_pejuang_hemat.png', // Pastikan asset ini ada
                  onShare: () {
                    print("Share ke IG Story!");
                  },
                  description: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 12, color: AppColors.greyDark, height: 1.4),
                      children: [
                        TextSpan(text: 'Sikat '),
                        TextSpan(
                          text: '67', 
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)
                        ),
                        TextSpan(text: ' porsi lagi!\nJadilah "'),
                        TextSpan(
                          text: 'Aktivis Perut', 
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)
                        ),
                        TextSpan(text: '"\nCus! Pesan Lagi!'),
                      ],
                    ),
                  ),
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