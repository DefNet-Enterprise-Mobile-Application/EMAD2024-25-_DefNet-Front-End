import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WifiQRScreen extends StatefulWidget {
  @override
  _WifiQRScreenState createState() => _WifiQRScreenState();
}

class _WifiQRScreenState extends State<WifiQRScreen> {
  String? qrCodeBase64;
  final String backendURL = "${dotenv.env['URL']}${dotenv.env['IP_RASP']}:${dotenv.env['PORT_MICROSERVICE']}";

  @override
  void initState() {
    super.initState();
    _fetchQRCode();
  }

  Future<void> _fetchQRCode() async {
    try {
      final response = await http.get(Uri.parse("$backendURL/wifi/qr"));

      if (response.statusCode == 200) {
        setState(() {
          qrCodeBase64 = jsonDecode(response.body)["qr_code"];
        });
      } else {
        throw Exception("Errore nel recupero del QR Code");
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Torna indietro alla schermata precedente
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
