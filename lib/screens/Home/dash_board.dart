import 'package:defnet_front_end/shared/services/wifi_settings_service.dart';
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


  final WifiSettingsService _wifiSettingsService = WifiSettingsService();

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
    _loadDevices();
  }

   void _loadDevices() async {
    try {
      List<Map<String, String>> devices =
          await _wifiSettingsService.fetchConnectedDevices();
      setState(() {
        _connectedDevices = devices;
      });
    } catch (e) {
      // Gestisci errori (ad esempio, mostrare un messaggio di errore)
      print('Error loading devices: $e');
    }
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

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.0001), // Spostato più in alto
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
                      padding: EdgeInsets.all(width * 0.1), // Responsivo
                      elevation: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo personalizzato al posto dell'icona
                        Image.asset(
                          "lib/assets/button_image/speedtest.png", // Percorso del logo
                          width: width * 0.12, // Adatta la dimensione per schermi diversi
                          height: width * 0.12, // Adatta la dimensione per schermi diversi
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.05), // Spazio responsivo ridotto

              // Titolo dei dispositivi connessi
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:Text(
                      "Connected Devices",
                      style: TextStyle(
                        fontSize: width * 0.05, // Responsivo
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent.shade700,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.blue.shade500.withOpacity(0.4),
                            offset: const Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis, // Evita overflow di testo
                    ),
                  ),
                  if (isScanning)
                    const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator()
                      //const Expanded(
                      //child: Align(
                        //alignment: Alignment.centerRight,
                  )
                  else
                    //Flexible(
                      //child:
                    IconButton(
                      onPressed: _loadDevices,
                      icon: Image.asset(
                        "lib/assets/button_image/aggiorna.png", // Percorso del logo
                        width: width * 0.1, // Adatta la dimensione per schermi diversi
                        height: width * 0.1, // Adatta la dimensione per schermi diversi
                      ),
                        //color: Colors.cyan,
                    ),
                ],
              ),

              SizedBox(height: height * 0.001), // Spazio responsivo ridotto

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
                      leading: Image.asset(
                        "lib/assets/button_image/dispositivi.png", // Percorso del logo
                        width: width * 0.12, // Responsivo
                        height: width * 0.12, // Responsivo
                      ),
                      title: Text(
                        device["name"] ?? "Unknown Device",
                        style: TextStyle(fontSize: width * 0.05), // Responsivo
                      ),
                      subtitle: Text(
                        "IP: ${device["ip"]}",
                        style: TextStyle(fontSize: width * 0.04), // Responsivo
                      ),
                      onLongPress: () => _editDeviceName(index), // Rileva la pressione prolungata
                    ),
                  );
                },
              ),

              if (_connectedDevices.isEmpty && !isScanning)
                Text(
                  'Nessun dispositivo trovato.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: width * 0.05, // Responsivo
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}




