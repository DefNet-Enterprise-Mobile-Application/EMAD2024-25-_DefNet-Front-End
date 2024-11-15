import 'package:defnet_front_end/screens/login_screen.dart';
import 'package:defnet_front_end/shared/components/shape_lines/ellipse_custom.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Home/home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //raccogliamo i dati inseriti
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

// Funzione per registrare l'utente
  Future<void> registerUser() async {
    const String baseurl = 'http://172.19.178.160:8000/register';

    try {
      final response = await http.post(
        Uri.parse(baseurl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _usernameController.text,
          'password': _passwordController.text,
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


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              // Wave Up
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: EllipseUp(rotateImage: false,), // Widget personalizzato per l'onda superiore
              ),
              // Wave Down
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: EllipseDown(), // Widget personalizzato per l'onda inferiore
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20), // Spazio tra l'onda superiore e il logo
                  // Logo Image
                  Image.asset(
                    'lib/assets/logo.png', // Sostituisci con il percorso del tuo logo
                    width: 150,
                    height: 150,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          TextField(
                            controller : _usernameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Inserisci il tuo username...',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Inserisci la tua password...',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                registerUser();
                                // Press Sign Up to reach the Home Page Dashboard
                                //Navigator.pushReplacement(
                                  //context,
                                 // MaterialPageRoute(builder: (context) =>  HomeScreen()),
                               // );

                              },
                              child: const Text('Sign Up'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                // Go to Registration Screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              },
                              child: const Text(
                                'Per loggarti clicca qui!',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
