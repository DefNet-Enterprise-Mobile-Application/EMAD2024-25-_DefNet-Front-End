import 'dart:convert';
import 'package:http/http.dart' as http;

class WifiSettingsService {

  final String baseUrl = "http://10.71.71.1:8000";

  Future<Map<String, dynamic>> getWifiSettings() async {
    final url = Uri.parse('$baseUrl/wifi/settings');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Converte il body JSON in una mappa
        var settings_wifi = json.decode(response.body);
        print("Questo è l'oggetto che è stato recuperato!");
        print("Object : $settings_wifi");
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch Wi-Fi settings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }



  // Metodo per ottenere i dispositivi connessi
  Future<List<Map<String, String>>> fetchConnectedDevices() async {
    try {
      // Effettua la richiesta HTTP GET
      final response = await http.get(Uri.parse("$baseUrl/connected-devices"));

      // Se la risposta è positiva (codice 200)
      if (response.statusCode == 200) {
        // Decodifica la risposta in formato JSON
        final data = json.decode(response.body);

        // Estrai la lista dei dispositivi connessi
        List<Map<String, String>> devices = [];
        for (var device in data['connected_devices']) {
          devices.add({
            'name':
                device['hostname'] ?? 'Unknown Device', // Nome del dispositivo
            'ip': device['ip'], // IP assegnato
            'mac': device['mac'], // MAC address
            'interface': 'Defnet_Network_Adapter', // Interfaccia statica
            'tx_bytes': device['tx_bytes'], // Bytes trasmessi
            'rx_bytes': device['rx_bytes'], // Bytes ricevuti
          });
        }

        return devices;
      } else {
        // Se la risposta non è 200, lancia un'eccezione
        throw Exception('Failed to load devices');
      }
    } catch (e) {
      // Gestisci eventuali errori
      throw Exception('Error fetching devices: $e');
    }
  }

  // Metodo per aggiornare le impostazioni Wi-Fi
  Future<Map<String, dynamic>> updateSettings(Map<String, String> newSettings) async {
    try {
      // Definire l'URL completo per la PUT request
      final url = Uri.parse('$baseUrl/wifi/settings');

      // Inviare la richiesta PUT al server
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',  // Definisce il tipo di contenuto come JSON
        },
        body: json.encode(newSettings),  // Invia i nuovi settings come JSON
      );

      // Verifica la risposta del server
      if (response.statusCode == 200) {
        // Se la risposta è OK, restituisci la risposta
        return json.decode(response.body);  // Decodifica la risposta JSON in una mappa
      } else {
        // Se il server restituisce un errore, lancia un'eccezione
        throw Exception('Errore nell\'aggiornamento delle impostazioni Wi-Fi: ${response.statusCode}');
      }
    } catch (e) {
      // Gestisci eventuali errori
      return {
        'status': 'error',
        'message': 'Errore durante l\'aggiornamento delle impostazioni Wi-Fi: $e'
      };
    }
  }
}
