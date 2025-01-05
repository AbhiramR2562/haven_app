import 'package:flutter/material.dart';

class QuantityButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const QuantityButtonWidget({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.black,
        ),
        onPressed: onTap,
      ),
    );
  }
}
