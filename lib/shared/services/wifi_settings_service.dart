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

  Future<void> updateSettings(Map<String, String> newSettings) async {}
}
