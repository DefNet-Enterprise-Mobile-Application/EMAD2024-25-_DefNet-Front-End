import 'package:defnet_front_end/shared/components/shape_lines/ellipse_custom.dart';
import 'package:flutter/material.dart';
import 'package:defnet_front_end/screens/Profile/profile_screen.dart';
import 'package:defnet_front_end/screens/Service/service_screen.dart';
import 'package:defnet_front_end/screens/Home/home_screen.dart';
import 'package:defnet_front_end/screens/Wifi_Settings/wifi_settings_screen.dart';

class FloatingBottomNavBar extends StatefulWidget {

  const FloatingBottomNavBar({Key? key}) : super(key: key);

  @override
  State<FloatingBottomNavBar> createState() => _FloatingBottomNavBarState();
}

class _FloatingBottomNavBarState extends State<FloatingBottomNavBar> {

  @override
  Widget build(BuildContext context) {


    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: 300,
      height: 85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Icona Home con testo
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(0, -9), // Sposta l'icona più in alto
                  child: IconButton(
                    icon: Image.asset(
                      'lib/assets/icons/home.png',
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(), // Mantieni il SizedBox
                const Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Icona Wi-Fi con testo
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(0, -9), // Sposta l'icona più in alto
                  child: IconButton(
                    icon: Image.asset(
                      'lib/assets/icons/wifi.png',
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => WifiSettingsScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(),
                const Text(
                  'Wi-Fi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Icona Service con testo
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(0, -9), // Sposta l'icona più in alto
                  child: IconButton(
                    icon: Image.asset(
                      'lib/assets/icons/service.png',
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ServiceScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(),
                const Text(
                  'Service',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Icona Profile con testo
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(0, -9), // Sposta l'icona più in alto
                  child: IconButton(
                    icon: Image.asset(
                      'lib/assets/icons/profile.png',
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(),
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
