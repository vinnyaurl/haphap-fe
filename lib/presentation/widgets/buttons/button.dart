import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

enum HapHapButtonSize { tiny, small, medium, large }

class HapHapButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final HapHapButtonSize size;
  final bool isOutline; 

  const HapHapButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = HapHapButtonSize.tiny, 
    this.isOutline = false,             
  });

  
  double get _buttonWidth {
    switch (size) {
      case HapHapButtonSize.tiny:
        return 96.0;
      case HapHapButtonSize.small:
        return 169.0;
      case HapHapButtonSize.medium:
        return 322.0;
      case HapHapButtonSize.large:
        return 354.0;
    }
  }

  
  double get _fontSize {
    if (size == HapHapButtonSize.large) {
      return 16.0;
    } else {
      return 12.0; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32),
    );

    final textStyle = TextStyle(
      fontSize: _fontSize, 
      fontWeight: FontWeight.w600,
    );

    return SizedBox(
      width: _buttonWidth,
      height: 32.0, 
      child: isOutline
          // outline button
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary, 
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: shape,
                padding: EdgeInsets.zero, 
              ),
              child: Text(text, style: textStyle),
            )
          // solid button
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0, 
                shape: shape,
                padding: EdgeInsets.zero,
              ),
              child: Text(text, style: textStyle),
            ),
    );
  }
}