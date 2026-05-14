import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapCategoryButton extends StatelessWidget {
  final String iconPath; 
  final String label;
  final VoidCallback onTap;
  final Color? iconColor; 

  const HapHapCategoryButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12), 
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
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: iconColor != null 
                      ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                      : null,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8), 
          
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.greyDark, 
            ),
          ),
        ],
      ),
    );
  }
}