import 'package:defnet_front_end/screens/Home/home_screen.dart';
import 'package:defnet_front_end/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:defnet_front_end/shared/services/login_service.dart'; // Importa il servizio di login

import '../shared/components/shape_lines/ellipse_custom.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller per i campi di input
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  // Funzione per gestire la login
  Future<void> _handleLogin() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      // Mostra un messaggio di errore se i campi sono vuoti
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Mostra il loading durante la richiesta
    });

    // Chiama il servizio di login
    final loginService = LoginService();
    bool success = await loginService.login(username, password);

    setState(() {
      _isLoading = false; // Nasconde il loading
    });

    if (success) {
      // Se la login è andata a buon fine, naviga alla HomeScreen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Se la login fallisce, mostra un messaggio di errore
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              // Wave up
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: EllipseUp(rotateImage: false), // Widget personalizzato per l'onda superiore
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
                  SizedBox(height: 20), // Spazio tra l'onda superiore e il logo
                  // Logo
                  Image.asset(
                    'lib/assets/logo.png', // Sostituisci con il percorso del tuo logo
                    width: 150,
                    height: 150,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
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
                            controller: _usernameController, // Collega il controller
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Inserisci il tuo username...',
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          TextField(
                            controller: _passwordController, // Collega il controller
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Inserisci la tua password...',
                            ),
                          ),
                          SizedBox(height: 16),
                          // Button SignIn
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin, // Usa _handleLogin quando premuto
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : Text('Sign In'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                // Go to Registration Page
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                                );
                              },
                              child: Text(
                                'Per registrarti clicca qui!',
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
