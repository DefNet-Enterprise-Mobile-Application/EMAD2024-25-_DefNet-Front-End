import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa flutter_dotenv

class LoginService {
  static String? _username;  // Variabile privata per memorizzare l'username
  static String? _password;  // Variabile privata per memorizzare la password dell'utente
  static String? _userId;    // Variabile privata per memorizzare l'ID dell'utente
  static const String port = '8000';
  static const String url = 'http://';
  static String? IP_RASP = dotenv.env['IP_RASP']; // IP del tuo server
  static String baseUrl = url + IP_RASP! + ':' + port + '/login';  // URL base per la login

  // Funzione per effettuare la login
  Future<bool> login(String username, String password) async {
    final Uri url = Uri.parse(baseUrl); // Modifica l'endpoint in base alla tua API

    final Map<String, String> body = {
      'username': username,
      'password': password,
    };

    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Se la login è riuscita, salva l'username, password e userId
        final Map<String, dynamic> responseData = json.decode(response.body);
        _username = responseData['username'];  // Assume che il server ritorni l'username
        _userId = responseData['user_id'];     // Assume che il server ritorni l'ID dell'utente
        _password = password;  // Salva anche la password (se desiderato)

        return true;
      } else {
        print('Login failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // Funzione per ottenere l'ID dell'utente loggato
  static String? getUserId() {
    return _userId;  // Restituisce l'ID dell'utente salvato dopo il login
  }

  // Funzione per ottenere l'username dell'utente loggato
  static String? getUsername() {
    return _username;  // Restituisce l'username dell'utente loggato
  }

  // Funzione per effettuare il logout
  static void logout() {
    _username = null;  // Reset dell'username
    _password = null;  // Reset della password
    _userId = null;    // Reset dell'ID utente
  }
}
