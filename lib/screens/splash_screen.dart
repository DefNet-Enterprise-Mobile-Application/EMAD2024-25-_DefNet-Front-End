import 'package:defnet_front_end/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(

        child: Lottie.asset(
        
          'lib/assets/logo animation.json',
          controller: _controller,
        
          onLoaded: (composition) {
        
            _controller.duration = composition.duration;
        
            _controller.forward();
        
          },
        
          width: MediaQuery.of(context).size.width, // Fill the screen width
          height: MediaQuery.of(context).size.height, // Fill the screen height
          fit: BoxFit.fitWidth , // Ensure it covers the full container
        
        ),
      ),
    );
  }
}
