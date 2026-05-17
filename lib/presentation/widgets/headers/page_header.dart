import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const HapHapPageHeader({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}