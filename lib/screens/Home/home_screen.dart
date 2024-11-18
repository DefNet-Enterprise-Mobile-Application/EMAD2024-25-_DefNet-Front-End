import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:defnet_front_end/screens/Profile/profile_screen.dart';
import 'package:defnet_front_end/screens/Service/service_screen.dart';
import 'package:defnet_front_end/screens/Wifi_Settings/wifi_settings_screen.dart';
import 'package:defnet_front_end/screens/Home/dash_board.dart';
import 'package:flutter/material.dart';

import 'package:defnet_front_end/shared/components/navigation_menu.dart'; // Aggiungi il file NavigationMenu
import 'package:defnet_front_end/screens/Notifications/notification_screen.dart'; // Aggiorna l'importazione
import '../../shared/components/shape_lines/ellipse_custom.dart';
import '../splash_screen.dart'; // Update the Ellipse widget as needed

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Indice corrente della pagina visualizzata

  final List<Widget> _pages = [
    DashboardScreen(),
    WifiSettingsScreen(),
    ServiceScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Recupera le dimensioni dello schermo per una gestione dinamica
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Contenuto dinamico con scrolling
          CustomScrollView(
            slivers: [
              // SliverAppBar per l'ellisse con logo sovrapposto
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: screenHeight * 0.2, // Altezza dell'ellisse in base all'altezza dello schermo
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Onda (ellisse)
                      EllipseUp(),

                      // Logo e icone nella parte superiore
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Logo posizionato a sinistra, dimensione adattiva
                            Image.asset(
                              'lib/assets/logo.png',
                              width: screenWidth * 0.5, // Il logo si adatta alla larghezza dello schermo
                              height: screenHeight * 0.25, // Altezza adattiva per il logo
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
                ),
                ],
                ),
      ),
                pinned: true, // Mantieni visibile l'ellisse anche dopo lo scroll
              ),
              // Contenuto dinamico in base alla pagina selezionata
              SliverFillRemaining(
                child: IndexedStack(
                  index: _currentIndex,
                  children: _pages,
                ),
              ),
            ],
          ),
        ],
      ),

      // Barra di navigazione curva
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.blueAccent,
        buttonBackgroundColor: Colors.blueAccent.shade100,
        height: screenHeight * 0.08, // Altezza della barra di navigazione adattiva
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          Image.asset(
            'lib/assets/icons/home.png',
            width: screenWidth * 0.08, // Dimensione adattiva delle icone
            height: screenWidth * 0.08, // Dimensione adattiva delle icone
            color: Colors.white,
          ),
          Image.asset(
            'lib/assets/icons/wifi.png',
            width: screenWidth * 0.08, // Dimensione adattiva delle icone
            height: screenWidth * 0.08, // Dimensione adattiva delle icone
            color: Colors.white,
          ),
          Image.asset(
            'lib/assets/icons/service.png',
            width: screenWidth * 0.08, // Dimensione adattiva delle icone
            height: screenWidth * 0.08, // Dimensione adattiva delle icone
            color: Colors.white,
          ),
          Image.asset(
            'lib/assets/icons/profile.png',
            width: screenWidth * 0.08, // Dimensione adattiva delle icone
            height: screenWidth * 0.08, // Dimensione adattiva delle icone
            color: Colors.white,
          ),
        ],
      ),
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
