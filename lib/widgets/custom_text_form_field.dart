// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  Icon prefixIcon;
  Icon? suffixIcon;
  TextEditingController controller;
  CustomTextFormField({
    required this.controller,
    required this.prefixIcon,
    this.suffixIcon,
    required this.labelText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        prefixIcon: prefixIcon, // Icon at the start
        border: OutlineInputBorder(
          // Adds a border around the field
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners

          // Border when not focused
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners

          // Border when focused
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        ),
        fillColor: Colors.grey[200], // Background color
        filled: true, // Enable the fill color
        contentPadding: const EdgeInsets.symmetric(
            vertical: 20.0, horizontal: 16.0), // Padding inside the field
      ),
    );
  }
}
