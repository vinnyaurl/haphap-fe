import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart'; 

// Onboarding Next Button
class HapHapOnboardingNextButton extends StatelessWidget {
  final double progress; 
  final VoidCallback onPressed;

  const HapHapOnboardingNextButton({
    super.key,
    required this.progress,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72, 
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              value: progress, 
              strokeWidth: 4.0,
              backgroundColor: AppColors.greyLight.withValues(alpha: 0.05),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          
          
          SizedBox(
            width: 56, 
            height: 56,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: const CircleBorder(), 
                padding: EdgeInsets.zero,
                elevation: 0, 
              ),
              child: const Icon(Icons.arrow_forward, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}

//Onboarding Skip Button
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