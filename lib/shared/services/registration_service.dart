import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../screens/Home/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa flutter_dotenv

class RegistrationService {

  // TODO : Inserire il proprio IPv4 del PC in maniera custom
  static const String port = '8000';
  static const String url = 'http://';
  static String? IP_RASP = dotenv.env['IP_RASP'];
  static String baseUrl = url+IP_RASP!+':'+port+'/register';

  // Funzione per registrare l'utente
  Future<void> registerUser(BuildContext context , String username,String password) async {

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
          print("[katia] Registrazione riuscita");
          // Registrazione riuscita, vai alla HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          // Gestione degli errori
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Errore"),
              content: Text("Registrazione fallita"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        // Gestione degli errori
        final errorMessage = json.decode(response.body)['detail'];
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Errore"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Errore durante la registrazione: $e");
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Errore"),
          content: Text("Si è verificato un errore durante la registrazione."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}