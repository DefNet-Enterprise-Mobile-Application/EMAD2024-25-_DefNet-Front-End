import 'package:flutter/material.dart';
import 'package:defnet_front_end/screens/splash_screen.dart'; // Per la logica di logout
import 'package:defnet_front_end/shared/components/navigation_menu.dart'; // FloatingBottomNavBar
import 'package:defnet_front_end/shared/components/shape_lines/ellipse_custom.dart'; // EllipseUp

class WifiSettingsScreen extends StatefulWidget {
  const WifiSettingsScreen({Key? key}) : super(key: key);

  @override
  State<WifiSettingsScreen> createState() => _WifiSettingsScreenState();
}

class _WifiSettingsScreenState extends State<WifiSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Onda in alto
          EllipseUp(),

          // Contenuto della pagina
          Padding(
            padding: const EdgeInsets.only(top: 40.0), // Spazio per logo e icone
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo e icone di notifica/logout
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
                            // Logica per le notifiche
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

                    // Spazio per il contenuto principale
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0), // Spazio sotto il logo
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Impostazioni Wi-Fi',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Nome Wi-Fi',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Azione per salvare le impostazioni
                              },
                              child: const Text('Salva Impostazioni'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const FloatingBottomNavBar(), // Navbar fissa in basso
    );
  }

  // Metodo per mostrare la finestra di dialogo di logout
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
