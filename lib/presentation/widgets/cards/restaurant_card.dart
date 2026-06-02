import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapRestaurantCard extends StatelessWidget {
  final String imageUrl; // Kembali pakai imageUrl
  final String distanceTime;
  final String restaurantName;
  final String ratingText;

  const HapHapRestaurantCard({
    super.key,
    required this.imageUrl, 
    required this.distanceTime,
    required this.restaurantName,
    required this.ratingText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 128, 
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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            // Kembali pakai Image.network
            child: Image.network(
              imageUrl,
              width: 128,
              height: 128,
              fit: BoxFit.cover,
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    distanceTime,
                    style: const TextStyle(fontSize: 12, color: AppColors.greyDark),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    restaurantName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, 
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        ratingText,
                        style: const TextStyle(fontSize: 12, color: AppColors.greyDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}