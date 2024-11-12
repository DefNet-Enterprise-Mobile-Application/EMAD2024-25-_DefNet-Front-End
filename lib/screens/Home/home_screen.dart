import 'package:defnet_front_end/screens/login_screen.dart';
import 'package:defnet_front_end/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../shared/components/shape_lines/ellipse_custom.dart';
import 'button_home_screen.dart';

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
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(

            children: <Widget>[

              // Wave Down
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child:
                    EllipseUp(rotateImage: true,), // Widget personalizzato per l'onda inferiore
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 40),
                  // Logo Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'lib/assets/logo.png', // Sostituisci con il percorso del tuo logo
                        width: 170,
                        height: 150,
                      ),
                      const Spacer(), // This will push the icons to the end
                      IconButton(
                        icon: Image.asset(
                          'lib/assets/icons/notification.png', // Percorso della tua immagine
                          width: screenWidth * 0.10, // Imposta la larghezza dell'immagine
                          height: screenWidth * 0.10, // Imposta l'altezza dell'immagine
                        ),
                        onPressed: () {
                          // Aggiungi qui la logica per le notifiche
                        },
                      ),


                      SizedBox(
                          width: screenWidth * 0.03), // Space between the icons

                      IconButton(
                        icon: Image.asset(
                          'lib/assets/icons/logout.png', // Percorso della tua immagine
                          width: screenWidth * 0.10, // Imposta la larghezza dell'immagine
                          height: screenWidth * 0.10, // Imposta l'altezza dell'immagine
                        ),
                        onPressed: () {
                          // Aggiungi qui la logica per le notifiche
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SplashScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        // Setting width and height as a percentage of screen size for responsiveness
                        width: screenWidth * 0.45, // 45% of screen width
                        height: screenHeight * 0.15, // 15% of screen height

                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: screenHeight * 0.01, // 1% from the top
                              left: 0,
                              right: 0,
                              child: Text(
                                'Hello!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(30, 30, 30, 1),
                                  fontFamily: 'Inter',
                                  fontSize:
                                      screenWidth * 0.08, // 8% of screen width
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                            ),
                            Positioned(
                              top: screenHeight * 0.1, // 10% from the top
                              left: 0,
                              right: 0,
                              child: Text(
                                textName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(117, 117, 117, 1),
                                  fontFamily: 'Inter',
                                  fontSize:
                                      screenWidth * 0.07, // 6% of screen width
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                  height: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonHomeScreen(
                          buttonText: 'Dashboard',
                          iconPath:
                          'lib/assets/button_image/dashboard.png', // Replace with your icon path
                          onPressed: () {
                            print('Dashboard button pressed');
                            // Go to Registration Screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                        ),
                        ButtonHomeScreen(
                          buttonText: 'Service',
                          iconPath:
                              'lib/assets/button_image/star.png', // Replace with your icon path
                          onPressed: () {
                            print('Service button pressed');
                            // Go to Registration Screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                        ),
                      ]),
                  const SizedBox(height: 40), // Space between rows
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonHomeScreen(
                          buttonText: 'Profile',
                          iconPath:
                          'lib/assets/button_image/profile.png', // Replace with your icon path
                          onPressed: () {
                            print('Service button pressed');
                            // Go to Registration Screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                        ),
                        ButtonHomeScreen(
                          buttonText: 'Wi-Fi Settings',
                          iconPath:
                          'lib/assets/button_image/wifi.png', // Replace with your icon path
                          onPressed: () {
                            print('Statistics button pressed');
                            // Go to Registration Screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                        ),
                      ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
