import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WifiQRScreen extends StatefulWidget {
  @override
  _WifiQRScreenState createState() => _WifiQRScreenState();
}

class _WifiQRScreenState extends State<WifiQRScreen> {
  String? qrCodeBase64;
  final String backendURL = "${dotenv.env['URL']}${dotenv.env['IP_RASP']}:${dotenv.env['PORT_MICROSERVICE']}";
  final String baseUrl = "wifi/qr";
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
        setState(() {
          qrCodeBase64 = jsonDecode(response.body)["qr_code"];
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
      print("Errore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QR Code Wi-Fi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.house, // Usa l'icona di FontAwesome
          ),
          onPressed: () {
            // Torna alla pagina precedente senza creare una nuova istanza
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: qrCodeBase64 == null
            ? CircularProgressIndicator()
            : Image.memory(base64Decode(qrCodeBase64!)),
      ),
    );
  }
}
