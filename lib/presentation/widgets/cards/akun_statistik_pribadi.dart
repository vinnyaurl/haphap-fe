import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapStatistikPribadiCard extends StatelessWidget {
  final String title;
  final String valuePrefix;
  final String value;
  final Color valueColor;
  final String dateText;
  final String imagePath;

  const HapHapStatistikPribadiCard({
    super.key,
    required this.title,
    this.valuePrefix = '',
    required this.value,
    required this.valueColor,
    required this.dateText,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 128, 
      clipBehavior: Clip.hardEdge, 
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
      child: Stack(
        children: [
          // --- 1. GAMBAR MASKOT ---
          Positioned(
            right: -4, 
            bottom: 0, 
            child: Image.asset(
              imagePath,
              height: 115, 
              fit: BoxFit.contain,
            ),
          ),
          
          // --- 2. TEKS ---
          Padding(
            // KUNCI: Jarak Atas 24, Bawah 24, Kiri 24 (Kanan tetep dikasih jarak biar ga nabrak maskot)
            padding: const EdgeInsets.only(left: 24, top: 24, bottom: 24, right: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // KUNCI: spaceBetween bikin teks atas nempel atap padding (24), teks bawah nempel lantai padding (24)
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12, 
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyDark, 
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // SizedBox dihilangkan karena spaceBetween sudah otomatis ngatur jarak tengahnya
                
                RichText(
                  text: TextSpan(
                    children: [
                      if (valuePrefix.isNotEmpty)
                        TextSpan(
                          text: valuePrefix,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: valueColor,
                          ),
                        ),
                      TextSpan(
                        text: value,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: valueColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Text(
                  dateText,
                  style: const TextStyle(
                    fontSize: 12, 
                    color: Color(0xFFAAAAAA),
                  ), 
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}