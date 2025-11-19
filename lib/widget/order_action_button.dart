import 'package:flutter/material.dart';

class OrderActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isEnabled;

  const OrderActionButton({
    super.key,
    required this.icon,
    required this.label, 
    required this.onPressed,
    this.isEnabled = true,
  }); 

  @override
  Widget build(BuildContext context) {
    final Color color = isEnabled ? Colors.black54 : Colors.grey[400]!;

    return TextButton.icon(
      // Si no está habilitado, onPressed será null, deshabilitando el botón.
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color),
        ),
      ),
    );
  }
}