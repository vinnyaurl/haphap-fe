import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool isRequired; 

  const HapHapTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.isRequired = false, 
  });

  @override
  State<HapHapTextField> createState() => _HapHapTextFieldState();
}

class _HapHapTextFieldState extends State<HapHapTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.labelText, 
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.greyDark,
              fontFamily: 'Plus Jakarta Sans', 
            ),
            children: [
              if (widget.isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        
        
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _isObscured : false,
          style: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w600, 
            color: AppColors.black,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: AppColors.greyLight, 
              fontSize: 16, 
              fontWeight: FontWeight.normal,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8), 
            isDense: true,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.greyLight, width: 1),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.greyDark, width: 1.5), 
            ),
            suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            suffixIcon: widget.isPassword
                ? InkWell(
                    onTap: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.greyDark,
                        size: 22,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}