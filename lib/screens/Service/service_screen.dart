import 'package:flutter/material.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final List<Map<String, dynamic>> services = [
    {
      'name': 'AD Block',
      'enabled': true,
      'modifiable': false,
      'description': 'Blocks annoying ads on websites, improving the browsing experience and security.'
    },
    {
      'name': 'IDS and IPS',
      'enabled': true,
      'modifiable': true,
      'description': 'Intrusion Detection and Prevention System (IDS/IPS) detects and prevents potential security threats.'
    },
    {
      'name': 'Parental Control',
      'enabled': true,
      'modifiable': true,
      'description': 'Allows parents to monitor and control children\'s internet usage for safety.'
    },
    {
      'name': 'VPN Protection',
      'enabled': false,
      'modifiable': false,
      'comingSoon': true,
      'description': 'VPN will be available soon. It will secure your internet connection by encrypting your data.'
    },
  ];

  // Funzione per mostrare il dialogo con la descrizione del servizio
  void _showServiceInfo(String description) {
    print("Showing service info: $description"); // Controllo di debug
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Service Info',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Chiude il dialogo
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, left: 12.0, right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'lib/assets/icons/scudo.png', // Percorso immagine
                                height: 70, // Altezza immagine
                                width: 120, // Larghezza immagine
                                fit: BoxFit.contain,
                              ),
                              Text(
                                'Services',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4.0,
                                      color: Colors.blue.shade200,
                                      offset: const Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Protect and manage your connection with the following services:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 4,
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: services.map((service) {
                                  bool enabled = service['enabled'] ?? false;
                                  bool modifiable = service['modifiable'] ?? false;
                                  bool comingSoon = service['comingSoon'] ?? false;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              service['name'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: comingSoon
                                                    ? Colors.grey
                                                    : Colors.blueGrey.shade900,
                                              ),
                                            ),
                                            if (comingSoon)
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 2.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange.shade200,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: const Text(
                                                    'Coming Soon',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.orange,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        if (!comingSoon)
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _showServiceInfo(service['description']);
                                                },
                                                child: Image.asset(
                                                  'lib/assets/icons/info.png', // Percorso immagine info
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              ),
                                              Switch(
                                                value: enabled,
                                                onChanged: modifiable
                                                    ? (bool value) {
                                                  setState(() {
                                                    service['enabled'] = value;
                                                  });
                                                }
                                                    : null,
                                                activeColor: Colors.blueAccent,
                                                inactiveThumbColor:
                                                modifiable ? Colors.grey : Colors.grey.shade400,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
