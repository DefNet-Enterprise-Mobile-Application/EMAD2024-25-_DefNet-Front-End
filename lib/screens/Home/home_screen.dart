import 'package:defnet_front_end/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:defnet_front_end/shared/components/navigation_menu.dart'; // Aggiungi il file NavigationMenu
import 'package:defnet_front_end/screens/Notifications/notification_screen.dart'; // Aggiorna l'importazione
import '../../shared/components/shape_lines/ellipse_custom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Onda in alto
          EllipseUp(),

          // Contenuto della pagina
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40),
                  // Immagine del logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'lib/assets/logo.png',
                        width: 170,
                        height: 150,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Image.asset(
                          'lib/assets/icons/notification.png',
                          width: screenWidth * 0.10,
                          height: screenWidth * 0.10,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Naviga alla schermata delle notifiche
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationScreen()),
                          );
                        },
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      IconButton(
                        icon: Image.asset(
                          'lib/assets/icons/logout.png',
                          width: screenWidth * 0.10,
                          height: screenWidth * 0.10,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FloatingBottomNavBar(),
    );
  }

  // Metodo per mostrare la finestra di dialogo
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Bordi arrotondati
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.indigo[900], // Sfondo blu scuro
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are you sure you want to leave?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Sfondo bianco
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        "NO",
                        style: TextStyle(
                          color: Colors.indigo, // Testo blu scuro
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Chiude il dialog
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Sfondo bianco
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        "YES",
                        style: TextStyle(
                          color: Colors.indigo, // Testo blu scuro
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Chiude il dialog
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SplashScreen()),
                        ); // Naviga alla pagina iniziale
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
