import 'package:flutter/material.dart';

class DialogHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;

  const DialogHeader({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor = const Color(0xFF980101),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor, size: 30),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
      ],
    ); 
  }
}