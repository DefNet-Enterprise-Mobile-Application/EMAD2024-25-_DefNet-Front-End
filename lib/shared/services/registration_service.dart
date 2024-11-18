import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa flutter_dotenv

class RegistrationService {
  // TODO : Inserire il proprio IPv4 del PC in maniera custom
  static const String port = '8000';
  static const String url = 'http://';
  static String? IP_RASP = dotenv.env['IP_RASP'];
  static String baseUrl = url + IP_RASP! + ':' + port + '/register';

  // Funzione per registrare l'utente
  Future<bool> registerUser(BuildContext context, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      // Stampa lo stato della risposta
      print("[katia] Stato della response: ${response.statusCode}");
      // Stampa anche il corpo della risposta per capire meglio il contenuto
      print("[katia] Corpo della response: ${response.body}");

      if (response.statusCode == 200) {
        // Parse the response body to get the boolean value
        bool isSuccess = json.decode(response.body);

        if (isSuccess) {
          return true; // Registrazione avvenuta con successo
        } else {
          // Registrazione fallita
          //_showErrorDialog(context, "Registrazione fallita. Riprova.");
          return false;
        }
      } else {
        // Gestione degli errori generali
        final errorMessage = json.decode(response.body)['detail'] ?? 'Errore sconosciuto';
        print("Error: $errorMessage");
        //_showErrorDialog(context, errorMessage);
        return false;
      }
    } catch (e) {
      print("Errore durante la registrazione: $e");
      //_showErrorDialog(context, "Si è verificato un errore durante la registrazione.");
      return false; // In caso di errore durante la chiamata
    }
  }

  // Funzione per mostrare un dialogo di errore
  /*void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Chiude il dialogo
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }*/
}
