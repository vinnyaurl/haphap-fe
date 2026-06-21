import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart'; 

class HapHapRiwayatCard extends StatelessWidget {
  final String imageUrl;
  final String dateStatusText;
  final String restaurantName;
  final String price;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const HapHapRiwayatCard({
    super.key,
    required this.imageUrl,
    required this.dateStatusText,
    required this.restaurantName,
    required this.price,
    required this.buttonText,
    required this.onButtonPressed,
  });

  Widget _placeholder() {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.storefront_outlined, size: 40, color: AppColors.greyDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 160,
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF1F1F1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          
          const SizedBox(width: 16), 
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateStatusText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 16), 
                
                Text(
                  restaurantName,
                  style: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 16), 
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.greyDark,
                      ),
                    ),
                    
                    HapHapButton(
                      text: buttonText,
                      onPressed: onButtonPressed,
                      size: HapHapButtonSize.tiny, 
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