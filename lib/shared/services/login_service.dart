import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../Models/User.dart';
import '../../shared/services/secure_storage_service.dart'; // Importa flutter_dotenv

class LoginService {

  static const String port = '8000';
  static const String url = 'http://';

  static String? IP_RASP = dotenv.env['IP_RASP']; // IP del tuo server
  static String baseUrl = url + IP_RASP! + ':' + port + '/login';  // URL base per la login

  // Funzione per effettuare la login
  Future<Map<String,dynamic>> login(String username, String password) async {

    if (username.isEmpty || password.isEmpty) {
      return {'success': false, 'message': 'Username and password cannot be empty'};
    }

    // Costruisci l'URL per l'endpoint della login
    final Uri url = Uri.parse('$baseUrl'); // Modifica l'endpoint in base alla tua API
    final headers = {'Content-Type': 'application/json'};
    final Map<String, String> body = {
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (!responseData.containsKey('access_token') || !responseData.containsKey('token_type')) {
          throw Exception('Invalid server response');
        }

        // Se la login è riuscita, salva l'username, password e userId
        final accessToken = responseData['access_token'];
        final tokenType = responseData['token_type'];
        final expiresIn = responseData['expires_in'];

        // Decodifica il token per estrarre i dati
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        final int id = decodedToken['user_id']; // Chiave specifica per l'ID
        final String extractedUsername = decodedToken['sub']; // Chiave per l'username
        final String extractedEmail = decodedToken['email']; // Aggiungi l'email estratta dal token

        //print('email : ${response.body}');
        print('email: $extractedEmail');

        // Puoi usare questi dati per salvare il token in un servizio sicuro
        final secureStorageService = GetIt.I<SecureStorageService>();

        // Salva il token e altri dati necessari (ad esempio l'ID dell'utente)
        await secureStorageService.saveToken(accessToken);
        await secureStorageService.saveTokenType(tokenType);

        // Decodifica e verifica token
        if (JwtDecoder.isExpired(accessToken)) {
          return {'success': false, 'message': 'Token has already expired'};
        }

        // Crea l'oggetto User
        final loggedUser = User(id: id,username: username,  passwordHash: responseData['passwordHash'] ?? '', email : extractedEmail);

        // Salva l'utente in SecureStorage
        await secureStorageService.save(loggedUser);

        // Registriamo l'utente in GetIt per l'accesso globale
        GetIt.I.registerSingleton<User>(loggedUser);

        // Se la login è riuscita, ritorna true
        return{
          'success': true,
          'message': 'Login successful!',
          'access_token': accessToken,
          'token_type': tokenType,
          'expires_in': expiresIn,
          'email': extractedEmail,
          //'user': responseData['user'],
        };
      } else {
        // In caso di errore, stampa il codice di stato e ritorna false
        return {
          'success': false,
          'message': 'Login failed: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error during login: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Funzione per ottenere l'ID dell'utente loggato
  static String? getUserId() {
    final user = GetIt.I<User>();
    return user.getId;  // Restituisce l'ID dell'utente salvato dopo il login
  }

  // Funzione per ottenere l'username dell'utente loggato
  static String? getUsername() {
    final user = GetIt.I<User>();
    return user.getUsername;  // Restituisce l'username dell'utente loggato
  }

  // Funzione per ottenere l'email dell'utente loggato
  static String? getUserEmail() {
    final user = GetIt.I<User>();
    return user.getEmail;  // Restituisce l'email dell'utente loggato
  }

}
