import 'package:flutter/material.dart';

// Reusable Button Component
class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onPressed, child: Text(text));
  }
}
