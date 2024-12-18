import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'dart:ui'; // Per usare il BackdropFilter

Color color = Colors.blue.shade900; // Definizione del colore

// Funzione per creare l'onda
Widget EllipseUp() {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Stack(
      children: [
        // Aggiungi il BackdropFilter per sfocare l'onda
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0), // Applica il blur
          child: Container(
            color: Colors.transparent,
          ),
        ),
        // WaveWidget con dimensioni maggiori
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(3.14159), // Inverte l'onda verticalmente
          child: WaveWidget(
            config: CustomConfig(
              gradients: [
                [color, Colors.blue.shade700],
                [Colors.blue.shade700, Colors.blue.shade500],
              ],
              durations: [5000, 5000],
              heightPercentages: const [0.50, 0.55], // Incrementa per aumentare l'altezza
              gradientBegin: Alignment.centerLeft,
              gradientEnd: Alignment.centerRight,
            ),
            size: const Size(double.infinity, 620), // Aumenta l'altezza
            waveAmplitude: 10, // Incrementa per dare maggiore dinamismo
          ),
        ),
      ],
    ),
  );
}
