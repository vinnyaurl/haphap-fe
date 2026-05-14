import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart'; 

// Onboarding Next Button
// Onboarding Next Button
class HapHapOnboardingNextButton extends StatelessWidget {
  final double? progress; // 1. Tambahkan tanda tanya (?) agar bisa menerima null
  final VoidCallback onPressed;
  final double size; 

  const HapHapOnboardingNextButton({
    super.key,
    required this.progress,
    required this.onPressed,
    this.size = 128.0, 
  });

  @override
  Widget build(BuildContext context) {
    final double strokeThickness = size * 0.09; 
    final double innerSize = size * 0.65; 
    final double iconSize = size * 0.3; 

    return SizedBox(
      width: size, 
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress, // Jika null, ini akan otomatis berputar
              strokeWidth: strokeThickness,
              backgroundColor: Colors.grey.shade300, 
              // 2. Logika warna: Kalau null (muter), warnanya abu-abu tua. Kalau tidak, oranye.
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == null ? Colors.grey.shade500 : AppColors.primary,
              ),
              strokeCap: StrokeCap.round, 
            ),
          ),
          
          SizedBox(
            width: innerSize, 
            height: innerSize,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: const CircleBorder(), 
                padding: EdgeInsets.zero,
                elevation: 0, 
              ),
              child: Icon(Icons.arrow_forward, size: iconSize),
            ),
          ),
        ],
      ),
    );
  }
}

class HapHapSkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isWhiteVariant; 

  const HapHapSkipButton({
    super.key,
    required this.onPressed,
    this.isWhiteVariant = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = isWhiteVariant ? AppColors.white : AppColors.primary;

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent), 
        foregroundColor: WidgetStateProperty.all(color), 
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
        ),
        textStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline, 
              decorationColor: color,
            );
          }
          return const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          );
        }),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Lewati'), 
          const SizedBox(width: 8), 
          Icon(Icons.arrow_forward, size: 20, color: color),
        ],
      ),
    );
  }
}