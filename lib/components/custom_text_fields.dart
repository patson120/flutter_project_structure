import 'package:flutter/material.dart';
import 'package:project_structure/theme/Palette.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLines;
  final Color? hintColor;
  final TextInputType? keyboardType;
  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.maxLines,
    this.hintColor,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        fontSize: 16,
        color: hintColor ?? Colors.black,
        decoration: TextDecoration.none,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  const BorderSide(width: 1.6, color: Palette.blueColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  BorderSide(width: 1.6, color: hintColor ?? Colors.grey)),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 16, color: hintColor ?? Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8)),
    );
  }
}
