import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

// --- IMPORT KOMPONEN HEADER ---
import 'package:haphap_fe/presentation/widgets/headers/page_header.dart';

class BahasaPage extends StatefulWidget {
  const BahasaPage({super.key});

  @override
  State<BahasaPage> createState() => _BahasaPageState();
}

class _BahasaPageState extends State<BahasaPage> {
  String _selectedLanguage = 'ID';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            // 1. HEADER
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: HapHapPageHeader(
                title: 'Bahasa',
              ),
            ),
            
            const SizedBox(height: 16),

            // 2. KARTU PILIHAN BAHASA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildLanguageItem(
                      code: 'ID',
                      label: '(ID) Indonesia',
                    ),
                    _buildLanguageItem(
                      code: 'EN',
                      label: '(EN) English',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // WIDGET HELPERS
  // ===========================================================================

  Widget _buildLanguageItem({required String code, required String label}) {
    final isSelected = _selectedLanguage == code;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = code;
        });
        print('Bahasa diubah ke: $label');
      },
      borderRadius: BorderRadius.circular(16), 
      child: Padding(
        // KUNCI: Padding 16px di setiap sisi.
        // Ini bikin pinggiran luar berjarak 16px, 
        // dan jarak antar-item di tengah jadi 32px (16 bawah + 16 atas).
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon checkmark
            Icon(
              Icons.check,
              size: 24, // Disesuaikan agar tebal & jelas
              // Kalau nggak dipilih, dibikin transparan biar teks tetap sejajar
              color: isSelected ? Colors.green : Colors.transparent, 
            ),
            
            const SizedBox(width: 12), // Jarak icon ke teks
            
            Text(
              label,
              style: const TextStyle(
                fontSize: 16, // Font size dinaikkan ke 16 sesuai standar
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}