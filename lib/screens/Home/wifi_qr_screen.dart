import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home_screen.dart';


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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(), // Naviga alla HomePage
          ),
              (Route<dynamic> route) => false, // Rimuove tutte le rotte precedenti
        );
        return false; // Impedisce il comportamento di default (ritorno alla pagina precedente)
      },
      child: Scaffold(
        appBar: AppBar(
            title: LayoutBuilder(
              builder: (context, constraints) {
                double fontSize = constraints.maxWidth > 600 ? 24 : 22; // Adatta la dimensione del testo
                  return Text(
                    "QR Code Wi-Fi",
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    ),
                  );
              },
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05), // Spazio a destra
                child: IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.house, // Usa l'icona di FontAwesome
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ),
            ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Logo
                    Image.asset(
                      'lib/assets/logodiviso.png',
                      width: screenWidth * 0.2,
                      height: screenHeight * 0.1,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(width: 10),

                    /// Titolo "DefNet"
                    Text(
                      'DefNet',
                      style: TextStyle(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),

                     /// Spazio flessibile per spingere l'icona a destra
                    Spacer(),
                  ],
                ),
              ),

              const SizedBox(height: 50),
              Center(
                child: qrCodeBase64 == null
                    ? CircularProgressIndicator()
                      : LayoutBuilder(
                        builder: (context, constraints) {
                          double imageSize = constraints.maxWidth > 600 ? 250 : 200; // Modifica la dimensione dell'immagine
                          return Image.memory(
                            base64Decode(qrCodeBase64!),
                            width: imageSize, // Imposta la larghezza responsiva
                            height: imageSize, // Imposta l'altezza responsiva
                          );
                        }
                     ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
