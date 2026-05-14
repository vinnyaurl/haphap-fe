import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapSearchBar extends StatelessWidget {
  final String hintText;
  final String prefixIconPath; 
  final String? suffixIconPath; 
  final VoidCallback? onSuffixTap; 
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const HapHapSearchBar({
    super.key,
    required this.hintText,
    required this.prefixIconPath,
    this.suffixIconPath,
    this.onSuffixTap,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Color(0xFFF1F1F1), width: 1), 
    );

    return Container(
      width: 354, 
      height: 40, 
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(50), 
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center, 
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.black,
        ),
        decoration: InputDecoration(
          isDense: true, 
          filled: true,
          fillColor: AppColors.white,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.greyLight, 
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          
          border: borderStyle,
          enabledBorder: borderStyle,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
          
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: SizedBox(
              width: 20, 
              height: 20,
              child: Center(
                child: SvgPicture.asset(prefixIconPath),
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 52, 
            minHeight: 40, 
          ),

          suffixIcon: suffixIconPath != null
              ? GestureDetector(
                  onTap: onSuffixTap,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, left: 12),
                    child: SizedBox(
                      width: 20, 
                      height: 20,
                      child: Center(
                        child: SvgPicture.asset(suffixIconPath!),
                      ),
                    ),
                  ),
                )
              : null,
          suffixIconConstraints: suffixIconPath != null
              ? const BoxConstraints(
                  minWidth: 52,
                  minHeight: 40,
                )
              : null,
        ),
      ),
    );
  }
}