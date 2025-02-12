import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double progress;

  const CustomLoadingIndicator({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background bianco
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24), // Padding per margini laterali
          child: Column(
            mainAxisSize: MainAxisSize.min, // Per centrare meglio i contenuti
            children: [
              // Indicatore personalizzato con Spinkit
              SizedBox(height: 24),
              Text(
                'Caricamento...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
