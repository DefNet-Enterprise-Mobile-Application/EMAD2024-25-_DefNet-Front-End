import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa flutter_dotenv

class RegistrationService {
  // TODO : Inserire il proprio IPv4 del PC in maniera custom



  static const String port = "8000";
  static const String url = "http://";
  
  static String? IP_RASP = dotenv.env['IP_RASP'];
  static String baseUrl = url + IP_RASP! + ':' + port + '/register';

  // Funzione per registrare l'utente
  Future<bool> registerUser(BuildContext context, String username, String password, String email) async {
    
    try {


      String baseUrlFinal = "http://$IP_RASP:8000/register";
      
      final response = await http.post(
        
        Uri.parse(baseUrlFinal),

        headers: {'Content-Type': 'application/json'},

        body: json.encode(
          
          {
          
          'username': username,
          'password': password,
          'email' : email,
        
        }
        ),
      );

      if (response.statusCode == 200) {
        // Parse the response body to get the boolean value
        bool isSuccess = json.decode(response.body);

        if (isSuccess) {
          
          return true; // Registrazione avvenuta con successo

        } else {
          
          // Registrazione fallita
           return false;
        }
      } else {
        // Gestione degli errori generali
        final errorMessage = json.decode(response.body)['detail'] ?? 'Errore sconosciuto';
        print("Error: $errorMessage");
        return false;
      
      }
    } catch (e) {
      
      print("Errore durante la registrazione: $e");
      return false; // In caso di errore durante la chiamata
    
    }
  }
}
