import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';

import 'speed_test_screen.dart';

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

  // Lista dinamica di dispositivi connessi
  List<Map<String, String>> _connectedDevices = [];

  // Stato della scansione
  bool isScanning = false;

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

    // Avvia la scansione all'avvio
    _scanNetwork();
  }
  void _editDeviceName(int index) {
    final TextEditingController nameController = TextEditingController(
      text: _connectedDevices[index]["name"], // Precompila il campo con il nome corrente
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifica Nome Dispositivo"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: "Inserisci un nuovo nome",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialogo senza fare nulla
              },
              child: const Text("Annulla"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _connectedDevices[index]["name"] = nameController.text;
                });
                Navigator.of(context).pop(); // Chiudi il dialogo
              },
              child: const Text("Salva"),
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Funzione per ottenere il subnet dinamico
  Future<String?> _getSubnet() async {
    final info = NetworkInfo();
    final wifiIP = await info.getWifiIP();
    if (wifiIP != null) {
      return wifiIP.substring(0, wifiIP.lastIndexOf('.'));
    }
    return null;
  }

  // Funzione per scansionare la rete
  Future<void> _scanNetwork() async {
    setState(() {
      isScanning = true;
      _connectedDevices = [];
    });

    final subnet = await _getSubnet();
    if (subnet == null) {
      setState(() {
        isScanning = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossibile ottenere il subnet.')),
      );
      return;
    }

    final port = 80; // Porta standard
    final stream = NetworkAnalyzer.discover2(subnet, port);

    stream.listen((NetworkAddress address) {
      if (address.exists) {
        setState(() {
          _connectedDevices.add({
            "name": "Device ${_connectedDevices.length + 1}", // Nome generico
            "ip": address.ip,
          });
        });
      }
    }).onDone(() {
      setState(() {
        isScanning = false;
      });
    });
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dispositivi Connessi",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent.shade700,
                        ),
                      ),
                      if (isScanning)
                        const CircularProgressIndicator()
                      else
                        IconButton(
                          onPressed: _scanNetwork,
                          icon:  Image.asset(
                            "lib/assets/button_image/aggiorna.png", // Percorso del logo
                            width: 50, // Dimensione del logo
                            height: 50, // Dimensione del logo
                          ),
                          color: Colors.cyan,
                        ),
                    ],
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
                          leading:  Image.asset(
                            "lib/assets/button_image/dispositivi.png", // Percorso del logo
                            width: 50, // Dimensione del logo
                            height: 50, // Dimensione del logo
                          ),
                          title: Text(device["name"] ?? "Unknown Device"),
                          subtitle: Text("IP: ${device["ip"]}"),
                          onLongPress: () => _editDeviceName(index), // Rileva la pressione prolungata
                        ),
                      );
                    },
                  ),

                  if (_connectedDevices.isEmpty && !isScanning)
                    const Text(
                      'Nessun dispositivo trovato.',
                      style: TextStyle(color: Colors.red),
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
