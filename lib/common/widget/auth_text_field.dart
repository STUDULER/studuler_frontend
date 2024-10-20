import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.obscureText,
    this.readOnly,
    this.showCursor, 
    this.keyboardType,
    this.onTap,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool? obscureText;
  final bool? readOnly;
  final bool? showCursor;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextField(
            controller: controller,
            obscureText: obscureText ?? false,
            readOnly: readOnly ?? false,
            showCursor: showCursor ?? true,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
