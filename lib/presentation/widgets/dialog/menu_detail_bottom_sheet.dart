import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';

void showMenuDetailBottomSheet(
  BuildContext context, {
  required String imageUrl,
  required String title,
  required String description,
  required String price,
  required VoidCallback onAddToCart,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
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
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 300,
                            color: const Color(0xFFF1F1F1),
                            child: const Icon(Icons.fastfood, color: AppColors.greyDark, size: 64),
                          );
                        },
                      )
                    : Container(
                        width: double.infinity,
                        height: 300,
                        color: const Color(0xFFF1F1F1),
                        child: const Icon(Icons.fastfood, color: AppColors.greyDark, size: 64),
                      ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.greyDark,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              price,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            
            const SizedBox(height: 24),
            
            HapHapButton(
              text: 'Tambahkan ke Keranjang - $price',
              isExpanded: true,
              onPressed: () {
                onAddToCart();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}