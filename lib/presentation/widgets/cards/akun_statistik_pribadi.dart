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
          Positioned(
            right: -4, 
            bottom: 0, 
            child: Image.asset(
              imagePath,
              height: 115, 
              fit: BoxFit.contain,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 24, bottom: 24, right: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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