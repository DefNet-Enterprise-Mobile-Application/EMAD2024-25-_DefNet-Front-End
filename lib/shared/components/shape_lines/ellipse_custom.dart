import 'package:flutter/material.dart';

Color color = Colors.blue.shade900; // Definizione del colore

// Funzione per creare l'onda
Widget EllipseUp() {
  Color color = Colors.blue.shade900; // Definizione del colore
  double height = 200; // Altezza dell'onda
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: WaveWidget(
      color: color,
      height: height,
    ),
  );
}

// Widget che rappresenta l'onda
class WaveWidget extends StatelessWidget {
  final Color color;
  final double height;

  const WaveWidget({required this.color, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(), // Definizione del clipper personalizzato
      child: Container(
        color: color,
        height: height,
      ),
    );
  }
}

// Clipper personalizzato per creare l'onda
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.7); // Partenza da un po' più in basso

    // Prima curva: inizio basso a sinistra
    path.quadraticBezierTo(
        size.width * 0.25, size.height,       // Punto di controllo
        size.width * 0.5, size.height * 0.85  // Punto finale
    );

    // Seconda curva: salita verso destra
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.7, // Punto di controllo
        size.width, size.height * 0.9         // Punto finale
    );

    path.lineTo(size.width, 0); // Chiude il percorso
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false; // Riclip obbligatorio
}
