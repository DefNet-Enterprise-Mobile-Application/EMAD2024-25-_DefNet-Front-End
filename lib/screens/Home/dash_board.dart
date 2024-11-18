import 'dart:async';
import 'package:flutter/material.dart';
import '../../shared/components/shape_lines/ellipse_custom.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Variabili per lo stato dello speed test
  bool _isTesting = false;
  String _downloadSpeed = "--";
  String _uploadSpeed = "--";
  String _latency = "--";

  // Lista di dispositivi connessi
  final List<Map<String, String>> _connectedDevices = [
    {"name": "Laptop", "ip": "192.168.0.101"},
    {"name": "Smartphone", "ip": "192.168.0.102"},
    {"name": "Smart TV", "ip": "192.168.0.103"},
  ];

  // Simula lo speed test
  Future<void> _startSpeedTest() async {
    setState(() {
      _isTesting = true;
      _downloadSpeed = "--";
      _uploadSpeed = "--";
      _latency = "--";
    });

    await Future.delayed(const Duration(seconds: 2)); // Simula il tempo del test

    setState(() {
      _isTesting = false;
      _downloadSpeed = "85 Mbps"; // Valore simulato
      _uploadSpeed = "30 Mbps";  // Valore simulato
      _latency = "12 ms";       // Valore simulato
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sezione dello Speed Test
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Speed Test Connessione",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isTesting ? null : _startSpeedTest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent.shade700,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: _isTesting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Avvia Speed Test"),
                    ),
                    const SizedBox(height: 20),
                    _isTesting
                        ? const Text(
                      "Esecuzione in corso...",
                      style: TextStyle(fontSize: 16),
                    )
                        : Column(
                      children: [
                        Text("Download: $_downloadSpeed",
                            style: const TextStyle(fontSize: 16)),
                        Text("Upload: $_uploadSpeed",
                            style: const TextStyle(fontSize: 16)),
                        Text("Latenza: $_latency",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sezione dei Dispositivi Connessi
            Text(
              "Dispositivi Connessi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent.shade700,
              ),
            ),
            const SizedBox(height: 10),
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
    );
  }
}
