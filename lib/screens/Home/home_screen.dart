import 'package:defnet_front_end/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:defnet_front_end/shared/components/navigation_menu.dart'; // Aggiungi il file NavigationMenu
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
    final screenHeight = MediaQuery.of(context).size.height;
    final textName = "Marta Coiro";

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
                          // Logica per il logout
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SplashScreen()),
                          );
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
}
