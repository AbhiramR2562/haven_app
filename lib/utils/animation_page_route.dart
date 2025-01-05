import 'package:flutter/material.dart';

class AnimationPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  AnimationPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // Start from the right (horizontal)
            const end = Offset.zero; // End at the original position
            const curve = Curves.easeInOut; // Smooth transition

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
}
