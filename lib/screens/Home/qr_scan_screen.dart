import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:wifi_iot/wifi_iot.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({Key? key}) : super(key: key);

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    controller?.pauseCamera();
    controller?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        final wifiData = parseWifiQRCode(scanData.code!);
        if (wifiData != null) {
          await connectToWifi(wifiData['ssid']!, wifiData['password']!);
          controller.pauseCamera(); // Ferma la scansione dopo la connessione
        }
      }
    });
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
      // Connetti alla rete Wi-Fi
      bool isConnected = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: NetworkSecurity.WPA, // Cambia in base alla tua configurazione
        joinOnce: true,
      );

      if (isConnected) {
        // Forza l'uso della rete Wi-Fi
        await WiFiForIoTPlugin.forceWifiUsage(true);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Errore nella connessione')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scansiona QR Code')),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
