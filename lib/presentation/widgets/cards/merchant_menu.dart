import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapMerchantMenuCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String stockText;
  final String imageUrl;
  final bool isSoldOut;
  final VoidCallback? onDeactivate;

  const HapHapMerchantMenuCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.stockText,
    required this.imageUrl,
    this.isSoldOut = false, // Default false (belum sold out)
    this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F1F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Gambar Menu (Otomatis Hitam Putih kalau Sold Out!)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              isSoldOut ? Colors.grey : Colors.transparent,
              isSoldOut ? BlendMode.saturation : BlendMode.multiply,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network( // Atau gunakan Image.asset jika gambarmu dari lokal
                imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: AppColors.greyDark,
                      size: 36,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Info Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (onDeactivate != null)
                      GestureDetector(
                        onTap: onDeactivate,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.greyDark,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      stockText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline, 
                        decorationColor: AppColors.primary,
                        // Kalau sold out warna merah, kalau sisa stock warna oren
                        color: isSoldOut ? Colors.red : AppColors.primary, 
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}