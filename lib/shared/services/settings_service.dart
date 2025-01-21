import 'dart:convert';

import 'package:http/http.dart' as http;



class SettingsService{

  final String apiUrl = "http://10.71.71.1:8000"; // URL del back-end

  // Funzione per attivare o disattivare un servizio
  Future<bool> toggleService(String serviceName, bool isEnabled) async {
    try {
      // Costruisci il corpo della richiesta
      final Map<String, dynamic> body = {
        'service_name': serviceName,
        'enabled': isEnabled,
      };

      // Invia la richiesta PUT al back-end
      final response = await http.put(
        Uri.parse('$apiUrl/services/$serviceName'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      // Controlla la risposta del server
      if (response.statusCode == 200) {
        // La richiesta è andata a buon fine
        return true;
      } else {
        // In caso di errore, puoi loggare il messaggio o restituire false
        print('Errore durante la modifica del servizio: ${response.body}');
        return false;
      }
    } catch (e) {
      // Gestione degli errori
      print('Errore nella richiesta: $e');
      return false;
    }
  }

  Future<Map<String, bool>> fetchServicesStatus() async {
    try {
      final url = Uri.parse("$apiUrl/services");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode della risposta JSON
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Converti il tipo della mappa a Map<String, bool>
        final Map<String, bool> servicesStatus = data.map((key, value) => MapEntry(key, value as bool));

        return servicesStatus;

      } else {
        print("Errore durante il recupero degli stati dei servizi: ${response.statusCode}");
        throw Exception("Errore durante il recupero degli stati dei servizi: ${response.statusCode}");
      }
    } catch (e) {
      print("Eccezione durante il recupero degli stati dei servizi: $e");
      throw Exception("Eccezione durante il recupero degli stati dei servizi: $e");
    }
  }




}