import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'dart:ui'; // Per usare il BackdropFilter

Color color = Colors.blue.shade900; // Definizione del colore

/// Esempio di colore principale; assicurati di definirlo o sostituirlo
final Color primaryColor = Colors.blueAccent;

/// Widget che crea l'onda in alto in modo responsive
Widget EllipseUp(BuildContext context) {
  // Ottiene le dimensioni dello schermo
  final Size screenSize = MediaQuery.of(context).size;
  final double screenWidth = screenSize.width;
  final double screenHeight = screenSize.height;

  // Definisci l'altezza dell'onda in base allo schermo.
  // In questo esempio, l'onda occuperà il 50% dell'altezza dello schermo.
  final double waveHeight = screenHeight * 0.6;

  // Imposta l'ampiezza dell'onda in modo responsive.
  // Puoi modificare questo valore per aumentare o diminuire il dinamismo.
  final double waveAmplitude = screenHeight * 0.015;

  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Stack(
      children: [
        // BackdropFilter per applicare un leggero blur all'onda
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
          child: Container(
            color: Colors.transparent,
          ),
        ),
        // Trasformazione per capovolgere l'onda verticalmente
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(3.14159), // oppure usa math.pi
          child: WaveWidget(
            config: CustomConfig(
              gradients: [
                [color, Colors.blue.shade700],
                [Colors.blue.shade700, Colors.blue.shade500],
              ],
              durations: [5000, 5000],
              heightPercentages: const [0.35, 0.40], // Incrementa per aumentare l'altezza
              gradientBegin: Alignment.centerLeft,
              gradientEnd: Alignment.centerRight,
            ),
            size: const Size(double.infinity, 340), // Aumenta l'altezza
            waveAmplitude: 10, // Incrementa per dare maggiore dinamismo
          ),
        ),
      ],
    ),
  );
}