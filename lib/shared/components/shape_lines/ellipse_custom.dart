import 'package:flutter/material.dart';

class EllipseUp extends StatelessWidget {
  final bool rotateImage; // Boolean to determine if the image should be rotated

  // Constructor with required boolean field
  EllipseUp({required this.rotateImage});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotateImage ? 3.14159 : 0, // 3.14159 radians is 180 degrees
      child: Image.asset(
        'lib/assets/ellipse2.png',  // Use the PNG file
      ),
    );
  }
}


class EllipseDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/ellipse3.png',  // Use the PNG file
    );
  }
}
