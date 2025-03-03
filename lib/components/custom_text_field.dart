import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String obscuringCharacter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final TextInputAction? textInputAction;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool? enabled;

  const CustomTextField({
    super.key,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.obscuringCharacter = '*',
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.textInputAction,
    this.onSaved,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return TextFormField(
      enabled: enabled,
      controller: controller,
      textInputAction: textInputAction,
      onSaved: onSaved,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.textBase,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          top: 10,
          left: 20,
        ),
        constraints: BoxConstraints(
          maxHeight: height * 0.065,
          // maxWidth: width * 0.065,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textLight,
        ),
        errorStyle: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.redAccent,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.yellow,
            width: 2,
          ),
        ),
      ),
    );
  }
}
