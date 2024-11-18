import 'package:flutter/material.dart';
import 'package:defnet_front_end/shared/components/navigation_menu.dart'; // Assumendo che FloatingBottomNavBar sia definito qui
import 'package:defnet_front_end/shared/components/shape_lines/ellipse_custom.dart'; // Assumendo che EllipseUp sia definito qui

class WifiSettingsScreen extends StatefulWidget {
  const WifiSettingsScreen({Key? key}) : super(key: key);

  @override
  State<WifiSettingsScreen> createState() => _WifiSettingsScreenState();
}

class _WifiSettingsScreenState extends State<WifiSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Onda in alto

          // Contenuto della pagina
          Padding(
            padding: const EdgeInsets.only(top: 180.0),
            child: SingleChildScrollView(
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
          ),
        ],
      ),
 // Navbar fissa in basso
    );
  }
}
