import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../screens/Service/SecureStorageService.dart';

class ProfileService {
  static const String port = '8000';
  static const String url = 'http://';
  static String? IP_RASP = dotenv.env['IP_RASP'];
  static String baseUrl = url + IP_RASP! + ':' + port + '/users';

  // Funzione per ottenere il profilo dell'utente
  Future<Map<String, dynamic>> getProfile(int userId) async {
    final Uri endpoint = Uri.parse('$baseUrl/$userId/profile');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(endpoint, headers: headers);

      if (response.statusCode == 200) {
        // Se la risposta è corretta, ritorna i dati come mappa
        return json.decode(response.body);
      } else {
        print('Failed to load profile: ${response.statusCode} ${response.body}');
        return {};
      }
    } catch (e) {
      print('Error during profile load: $e');
      return {};
    }
  }

  // Funzione per aggiornare la password del profilo
  Future<bool> changePassword({required int userId, required String currentPassword,required String newPassword}) async {
    final Uri endpoint = Uri.parse('$baseUrl/$userId/change-password');

    // Recupera il token dall'archiviazione sicura
    final token = await SecureStorageService().getToken();
    if (token == null) {
      print("User is not authenticated.");
      return false;
    }

    final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Aggiungi il token di autenticazione
      };

    final body = json.encode({
      'current_password': currentPassword,
      'new_password': newPassword,
    });

    try {
      final response = await http.put(endpoint, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update profile: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during profile update: $e');
      return false;
    }
  }
}
