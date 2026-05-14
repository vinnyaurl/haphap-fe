import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapCheckbox extends StatelessWidget {
  final String label;
  final bool value; 
  final ValueChanged<bool?> onChanged;

  const HapHapCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(6), 
              border: Border.all(
                color: AppColors.primary, 
                width: 1.5,
              ),
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    size: 14,
                    color: AppColors.white,
                  )
                : null, 
          ),
          
          const SizedBox(width: 8), 
          
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.greyDark, 
            ),
          ),
        ],
      ),
    );
  }
}