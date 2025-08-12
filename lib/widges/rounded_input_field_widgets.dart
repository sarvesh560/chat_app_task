import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class RoundedInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? initialValue;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const RoundedInputField({
    Key? key,
    this.controller,
    required this.label,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.initialValue,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        filled: true,
        fillColor: AppColors.primary.withOpacity(0.05),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}
