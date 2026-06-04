import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';
import 'package:haphap_fe/presentation/widgets/buttons/button.dart';

class HapHapGelarCard extends StatelessWidget {
  final String gelar;
  final Widget description;
  final String imagePath;
  final VoidCallback onShare;

  const HapHapGelarCard({
    super.key,
    required this.gelar,
    required this.description,
    required this.imagePath,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 208,
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 8),
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
      child: Row(
        children: [
          Expanded(
            flex: 3, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Gelar Kamu: ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    children: [
                      TextSpan(
                        text: gelar,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),

                description,

                const SizedBox(height: 24),

                SizedBox(
                  child: HapHapButton(
                    text: 'Share',
                    size: HapHapButtonSize.tiny,
                    onPressed: onShare,
                  ),
                )
              ],
            ),
          ),

          Expanded(
            flex: 2, 
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              height: 200, 
            ),
          ),
        ],
      ),
    );
  }
}
