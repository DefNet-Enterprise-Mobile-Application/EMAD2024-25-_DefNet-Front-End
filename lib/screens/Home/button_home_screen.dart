import 'package:flutter/material.dart';

class ButtonHomeScreen extends StatefulWidget {
  final String buttonText;
  final VoidCallback? onPressed; // Callback function for button press
  final String iconPath; // Path to the icon image

  ButtonHomeScreen({
    required this.buttonText,
    this.onPressed,
    required this.iconPath, // Pass the icon path here
  });

  @override
  State<ButtonHomeScreen> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonHomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to get the width and height of the screen
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        // Setting width and height as a percentage of screen size for responsiveness
        width: screenWidth * 0.40, // 40% of screen width
        height: screenHeight * 0.15, // 15% of screen height
        decoration: BoxDecoration(
          color: Color(0xFF03C0DB), // Background color for the button
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center content
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon placed above the text
            Image.asset(
              widget.iconPath, // Use the icon path here
              width: screenWidth * 0.10, // 8% of screen width for the icon
              height: screenWidth * 0.10, // 8% of screen width for the icon
            ),
            SizedBox(height: 8), // Space between icon and text
            Text(
              widget.buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: screenWidth * 0.04, // 4% of screen width
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}