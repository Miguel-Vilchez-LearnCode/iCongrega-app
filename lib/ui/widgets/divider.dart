import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/icons/divition_border.png',
        height: 20,
        width: 240,
        fit: BoxFit.contain,
      ),
    );
  }
}
