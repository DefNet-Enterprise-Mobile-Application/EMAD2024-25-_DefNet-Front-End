import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:defnet_front_end/screens/Profile/profile_screen.dart';
import 'package:defnet_front_end/screens/Service/service_screen.dart';
import 'package:defnet_front_end/screens/Wifi_Settings/wifi_settings_screen.dart';
import 'package:defnet_front_end/screens/Home/dash_board.dart';
import 'package:flutter/material.dart';
import '../../shared/components/shape_lines/ellipse_custom.dart'; // Update the Ellipse widget as needed

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
    return Scaffold(
      body: Stack(
        children: [
          // Contenuto dinamico con scrolling
          CustomScrollView(
            slivers: [
              // SliverAppBar per l'ellisse con logo sovrapposto
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 250, // Altezza ellisse + logo
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Onda (ellisse)
                      EllipseUp(),
                      // Logo posizionato sopra l'ellisse
                      Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          'lib/assets/logo.png',
                          height: 200, // Altezza del logo
                          width: 200, // Larghezza del logo
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
        height: 60,
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
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          Image.asset(
            'lib/assets/icons/wifi.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          Image.asset(
            'lib/assets/icons/service.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          Image.asset(
            'lib/assets/icons/profile.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
