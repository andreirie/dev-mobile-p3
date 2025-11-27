import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          fillColor: Color(0xFFBDBDBD),
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
