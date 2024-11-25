import 'package:flutter/material.dart';
import 'package:defnet_front_end/screens/Home/speed_test_screen.dart'; // Assicurati che il percorso sia corretto

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sezione dello Speed Test
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Speed Test Connessione",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Naviga verso la schermata SpeedTestScreen quando il bottone è premuto
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SpeedTestScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9, // Larghezza quasi piena
                        height: 60, // Altezza fissa del bottone
                        child: const Center(
                          child: Text(
                            "Avvia Speed Test",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sezione dei Dispositivi Connessi
            Text(
              "Dispositivi Connessi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent.shade700,
              ),
            ),
            const SizedBox(height: 10),
            // Aggiungi la logica per visualizzare i dispositivi connessi se necessario
          ],
        ),
      ),
    );
  }
}