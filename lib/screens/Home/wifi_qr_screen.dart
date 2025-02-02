import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wifi_iot/wifi_iot.dart';

class WifiQRScreen extends StatefulWidget {
  const WifiQRScreen({Key? key}) : super(key: key);

  @override
  State<WifiQRScreen> createState() => _WifiQRScreenState();
}

class _WifiQRScreenState extends State<WifiQRScreen> {
  String? qrCodeBase64;

 final String  baseUrl = "wifi/qr";
 final String baseUrlTest = "wifi/qr_test";

  @override
  void initState() {
    super.initState();
    fetchQRCode();
  }

  Future<void> fetchQRCode() async {
    print("Sono all'interno del metodo!");
    try {
      final response = await http.get(Uri.parse('http://10.71.71.1:8000/$baseUrlTest')); // Cambia l'URL in base alla tua configurazione
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          qrCodeBase64 = data['qr_code'];
        });
      } else {
        print(response.body);
        throw Exception('Errore nel recupero del QR code');
      }
    } catch (e) {
      print('Errore: $e');
    }
  }

  Map<String, String>? parseWifiQRCode(String qrCode) {
    try {
      final regex = RegExp(r'WIFI:T:(.+);S:(.+);P:(.+);;');
      final match = regex.firstMatch(qrCode);
      if (match != null) {
        return {
          'encryption': match.group(1)!,
          'ssid': match.group(2)!,
          'password': match.group(3)!,
        };
      }
    } catch (e) {
      print('Errore nel parsing del QR code Wi-Fi: $e');
    }
    return null;
  }

  Future<void> connectToWifi(String ssid, String password) async {
    try {
      final success = await WiFiForIoTPlugin.connect(ssid, password: password);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connesso alla rete Wi-Fi')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connessione fallita')),
        );
      }
    } catch (e) {
      print('Errore nella connessione alla rete Wi-Fi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wi-Fi QR Code'),
      ),
      body: Center(
        child: qrCodeBase64 != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(
              base64Decode(qrCodeBase64!),
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final wifiData = parseWifiQRCode(qrCodeBase64!);
                if (wifiData != null) {
                  connectToWifi(wifiData['ssid']!, wifiData['password']!);
                }
              },
              child: const Text('Connetti alla rete'),
            ),
          ],
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
