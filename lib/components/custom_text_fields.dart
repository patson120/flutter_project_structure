import 'package:flutter/material.dart';
import 'package:project_structure/theme/Palette.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  const CustomTextField({super.key, this.controller, this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontSize: 16,
        color: Palette.whiteColor,
        decoration: TextDecoration.none,
      ),
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  const BorderSide(width: 1.6, color: Palette.blueColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  const BorderSide(width: 1.6, color: Palette.greyColor)),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 16, color: Palette.whiteColor),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8)),
    );
  }
}
