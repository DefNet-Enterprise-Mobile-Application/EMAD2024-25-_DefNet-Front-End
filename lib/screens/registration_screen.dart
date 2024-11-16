import 'package:defnet_front_end/screens/login_screen.dart';
import 'package:defnet_front_end/shared/components/shape_lines/ellipse_custom.dart';
import 'package:flutter/material.dart';

import 'Home/home_screen.dart';
import '../shared/services/registration_service.dart';  // Importa il RegistrationService

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  // Controller per raccogliere i dati di input dell'utente
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;  // Variabile per gestire il loading

  // Funzione per gestire la registrazione
  Future<void> _handleRegister() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      // Mostra un messaggio di errore se i campi sono vuoti
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;  // Mostra il loading durante la registrazione
    });

    // Chiama il servizio di registrazione
    final registrationService = RegistrationService();
    await registrationService.registerUser(context, username, password);

    setState(() {
      _isLoading = false;  // Nasconde il loading
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: screenHeight,
          child: Stack(
            children: <Widget>[
              // Wave Up
              EllipseUp(),  // Widget personalizzato per l'onda superiore

              // Wave Down
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
                            controller: _usernameController,
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
                              onPressed: _isLoading ? null : _handleRegister, // Usa _handleRegister quando premuto
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Sign Up'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.blue,
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
                                // Vai alla schermata di login
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
