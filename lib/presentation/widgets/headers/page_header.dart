import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton; 
  final Color titleColor;    
  final double fontSize;     

  const HapHapPageHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showBackButton = true,              
    this.titleColor = AppColors.black,       
    this.fontSize = 20,                      
  });

  @override
  Widget build(BuildContext context) {
    // KUNCI: Bungkus pakai Container dan set minHeight 44px
    return Container(
      constraints: const BoxConstraints(minHeight: 44), 
      alignment: Alignment.centerLeft, // Pastikan isinya rata kiri
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showBackButton) 
            GestureDetector(
              onTap: onBackPressed ?? () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  print("Ini halaman paling awal, tidak bisa back!");
                }
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            ),
          
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize,              
                fontWeight: FontWeight.w600,
                color: titleColor,               
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}