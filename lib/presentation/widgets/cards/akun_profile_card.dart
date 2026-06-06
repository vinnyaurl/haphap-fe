import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String? imageUrl; // Ubah jadi nullable String untuk URL

  const HapHapProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.imageUrl, // Optional
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan image provider, dari network jika ada url, atau asset default
    final imageProvider = (imageUrl != null && imageUrl!.isNotEmpty)
        ? NetworkImage(imageUrl!) as ImageProvider
        : const AssetImage('assets/images/profile_image.png');

    return Container(
      width: 354,
      height: 128,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20), 
        border: Border.all(
          color: const Color(0xFFF1F1F1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF8F8F8), 
              image: DecorationImage(
                image: imageProvider, // Gunakan provider yang sudah ditentukan
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(width: 16), 
          
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name, 
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.black,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  phoneNumber,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}