import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapStatsCard extends StatelessWidget {
  final String title;
  final String prefixText;
  final String mainValue;
  final Color valueColor;
  final String subtitle;

  const HapHapStatsCard({
    super.key,
    required this.title,
    this.prefixText = '',
    required this.mainValue,
    required this.valueColor,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 169, 
      height: 169, 
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
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0), 
        child: SizedBox(
          width: double.infinity, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, 
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 9), 
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: valueColor, fontWeight: FontWeight.bold),
                  children: [
                    if (prefixText.isNotEmpty)
                      TextSpan(
                        text: prefixText, 
                        style: const TextStyle(fontSize: 20) 
                      ),
                    TextSpan(
                      text: mainValue, 
                      style: const TextStyle(fontSize: 24) 
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24), 
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12, 
                  color: AppColors.greyLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}