import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

enum HapHapButtonSize { tiny, small, medium, large }

class HapHapButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final HapHapButtonSize size;
  final bool isOutline;
  final bool isText;
  final bool isLoading;
  final bool isExpanded;
  final bool isDanger;

  const HapHapButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = HapHapButtonSize.tiny,
    this.isOutline = false,
    this.isText = false,
    this.isLoading = false,
    this.isExpanded = false,
    this.isDanger = false,
  });

  double get _buttonWidth {
    if (isExpanded) return double.infinity;
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

  double get _buttonHeight => isExpanded ? 52.0 : 32.0;

  double get _fontSize {
    if (isExpanded || size == HapHapButtonSize.large) return 16.0;
    return 12.0;
  }

  Color get _solidColor => isDanger ? AppColors.error : AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32),
    );

    final Widget child = isLoading
        ? SizedBox(
            width: isExpanded ? 22 : 16,
            height: isExpanded ? 22 : 16,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: isOutline ? _solidColor : AppColors.white,
            ),
          )
        : Text(
            text,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
            ),
          );

    if (isText) {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: _solidColor,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: child,
      );
    }

    return SizedBox(
      width: _buttonWidth,
      height: _buttonHeight,
      child: isOutline
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: shape,
                padding: EdgeInsets.zero,
              ),
              child: child,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: _solidColor,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: _solidColor.withValues(alpha: 0.6),
                elevation: 0,
                shape: shape,
                padding: EdgeInsets.zero,
              ),
              child: child,
            ),
    );
  }
}
