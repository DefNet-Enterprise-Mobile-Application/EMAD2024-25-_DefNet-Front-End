import 'dart:convert';
import 'package:http/http.dart' as http;




// Services
import '../../shared/services/secure_storage_service.dart';
import 'package:defnet_front_end/shared/services/configuration_service.dart';


class ProfileService {


  final ConfigurationService _configurationService = ConfigurationService();



  // Funzione per ottenere il profilo dell'utente
  Future<Map<String, dynamic>> getProfile(int userId) async {


    String? url = _configurationService.getBasicUrlHttp();
    
    String? ip = _configurationService.getIpRaspberryPi();

    String? port = _configurationService.getPortMicroservice();
    

    String baseUrl = "$url$ip:$port/users";

    
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
    String? url = _configurationService.getBasicUrlHttp();
    
    String? ip = _configurationService.getIpRaspberryPi();

    String? port = _configurationService.getPortMicroservice();
    

    String baseUrl = "$url$ip:$port/users";


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
