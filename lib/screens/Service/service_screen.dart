import 'package:flutter/material.dart';
import 'package:defnet_front_end/shared/components/navigation_menu.dart'; // Assumendo che FloatingBottomNavBar sia definito qui
import 'package:defnet_front_end/shared/components/shape_lines/ellipse_custom.dart'; // Assumendo che EllipseUp sia definito qui


class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
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
                      'Servizi',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 20),
                    for (int i = 0; i < 5; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('AD Block'),
                          Switch(value: true, onChanged: (bool value) {}),
                        ],
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
