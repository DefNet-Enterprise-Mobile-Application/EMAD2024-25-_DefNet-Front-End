import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa flutter_dotenv

class LoginService {


  // TODO : Inserire il proprio IPv4 del PC in maniera custom
  static const String port = '8000';
  static const String url = 'http://';
  static String? IP_RASP = dotenv.env['IP_RASP'];
  static String baseUrl = url+IP_RASP!+':'+port+'/login';



  // Funzione per effettuare la login
  Future<bool> login(String username, String password) async {
    // Costruisci l'URL per l'endpoint della login
    final Uri url = Uri.parse('$baseUrl'); // Modifica l'endpoint in base alla tua API

    // Crea il body della richiesta
    final Map<String, String> body = {
      'username': username,
      'password': password,
    };

    // Aggiungi l'header per indicare che stai inviando dati JSON
    final headers = {'Content-Type': 'application/json'};

    // Esegui la richiesta POST
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: headers,
      );

      // Verifica se la richiesta è andata a buon fine (status code 200)
      if (response.statusCode == 200) {
        // Se la login è riuscita, ritorna true
        return true;
      } else {
        // In caso di errore, stampa il codice di stato e ritorna false
        print('Login failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Gestisci eventuali errori di rete
      print('Error during login: $e');
      return false;
    }
  }
}
