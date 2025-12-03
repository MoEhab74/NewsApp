import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.isDark,
    this.obscureText,
    this.controller,
    required this.hintText,
    this.keyboardType,
    this.validator,
  });

  final bool isDark;
  final bool? obscureText;
  final TextEditingController? controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText ?? false,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: (isDark ? Colors.white12 : Colors.white70).withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}