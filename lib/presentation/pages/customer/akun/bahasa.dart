import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

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
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: HapHapPageHeader(
                title: 'Bahasa',
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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.check,
              size: 24,
              color: isSelected ? Colors.green : Colors.transparent, 
            ),
            
            const SizedBox(width: 12),
            
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}