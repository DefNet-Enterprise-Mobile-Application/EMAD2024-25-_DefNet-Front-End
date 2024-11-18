import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:defnet_front_end/screens/Profile/profile_screen.dart';
import 'package:defnet_front_end/screens/Service/service_screen.dart';
import 'package:defnet_front_end/screens/Wifi_Settings/wifi_settings_screen.dart';
import 'package:defnet_front_end/screens/Home/dash_board.dart';
import 'package:flutter/material.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                            // Icona di notifica
                            IconButton(
                              icon: Image.asset(
                                'lib/assets/icons/notification.png',
                                width: screenWidth * 0.15, // Icona adattiva
                                height: screenHeight * 0.15, // Icona adattiva
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Logica per le notifiche
                              },
                            ),
                            SizedBox(width:  screenWidth * 0.05),
                            // Icona per il logout
                            IconButton(
                              icon: Image.asset(
                                'lib/assets/icons/logout.png',
                                width: screenWidth * 0.15, // Icona adattiva
                                height: screenWidth * 0.15, // Icona adattiva
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Logica per il logout
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => SplashScreen()),
                                );
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
        color: Colors.cyanAccent.shade700.withOpacity(0.9),
        buttonBackgroundColor: Colors.blueAccent,
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
}
