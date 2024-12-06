import 'dart:async';
import 'package:defnet_front_end/screens/Home/speed_test_component.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  // Controller per l'animazione del pulsante
  late final AnimationController _animationController;
  late final Animation<double> _pulseAnimation;

  // Lista di dispositivi connessi
  final List<Map<String, String>> _connectedDevices = [
    {"name": "Laptop", "ip": "192.168.0.101"},
    {"name": "Smartphone", "ip": "192.168.0.102"},
    {"name": "Smart TV", "ip": "192.168.0.103"},
  ];

  @override
  void initState() {
    super.initState();

    // Inizializza l'animazione pulsante
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Inizializza l'animazione pulse
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sfondo trasparente
          Container(
            color: Colors.transparent,
          ),

          // Contenuto principale
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Pulsante animato con immagine
                  Center(
                    child: ScaleTransition(
                      scale: _pulseAnimation,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SpeedTestWidget(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent.shade700,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(40),
                          elevation: 10,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo personalizzato al posto dell'icona
                            Image.asset(
                              "lib/assets/button_image/speedtest.png", // Percorso del logo
                              width: 50, // Dimensione del logo
                              height: 50, // Dimensione del logo
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Titolo dei dispositivi connessi
                  Text(
                    "Dispositivi Connessi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent.shade700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Lista dei dispositivi connessi
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _connectedDevices.length,
                    itemBuilder: (context, index) {
                      final device = _connectedDevices[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.device_hub, color: Colors.cyan),
                          title: Text(device["name"] ?? "Unknown Device"),
                          subtitle: Text("IP: ${device["ip"]}"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
