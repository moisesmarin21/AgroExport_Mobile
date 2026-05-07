import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscure;
  final bool? enabled;
  final EdgeInsetsGeometry? padding;

  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  // 👉 NUEVOS
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.obscure = false,
    this.enabled = true,
    this.padding,
    this.maxLength,
    this.inputFormatters,
    this.keyboardType,
    this.onChanged,
    this.suffixIcon,
    this.focusNode,
    this.onTap,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 28),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        cursorColor: AppColors.primary,
        enabled: enabled,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        obscureText: obscure,
        onChanged: onChanged,
        onTap: onTap,
        style: AppStyles.label,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppStyles.labelHintTextGris,
          labelStyle: const TextStyle(
            color: AppColors.primary,
            fontSize: 16,
          ),
          suffixIcon: suffixIcon,
          counterText: maxLength != null ? '' : null,
          contentPadding: const EdgeInsets.only(bottom: 0, top: 15),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primary,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
        ),
        validator: validator,
      ),
    );
  }
}