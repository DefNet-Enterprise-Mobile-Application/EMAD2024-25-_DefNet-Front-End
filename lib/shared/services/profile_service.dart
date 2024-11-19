import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  // Funzione per aggiornare i dati del profilo
  Future<bool> updateProfile(int userId, String? username, String? currentPassword, String? newPassword) async {
    final Uri endpoint = Uri.parse('$baseUrl/$userId/profile');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'username': username,
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
