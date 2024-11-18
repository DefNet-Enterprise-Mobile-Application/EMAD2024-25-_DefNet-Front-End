import 'package:defnet_front_end/screens/login_screen.dart';
import 'package:defnet_front_end/shared/components/shape_lines/ellipse_custom.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Importa il pacchetto per le icone

import '../shared/services/registration_service.dart'; // Importa il RegistrationService

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Controller per raccogliere i dati di input dell'utente
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false; // Variabile per gestire il loading
  bool _isPasswordVisible = false; // Variabile per la visibilità della password
  String _passwordErrorMessage = ''; // Messaggio di errore per la password

  // Funzione che mostra un dialog personalizzato
  void _showMessageDialog(BuildContext context, String message, bool success) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impedisce di chiudere il dialog cliccando fuori
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[900], // Sfondo blu
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Bordi arrotondati
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              // Mostra l'icona solo in caso di errore
              if (!success)
                Icon(
                  FontAwesomeIcons.timesCircle,
                  color: Colors.red,
                  size: 50, // Aumentato per renderlo più visibile
                ),
              if (success) ...[
                // Se la registrazione è riuscita, non mostrare l'icona
                const SizedBox(height: 10), // Spazio per l'allineamento
              ],
              const SizedBox(height: 10),
              // Mostra solo il messaggio
              Text(
                message, // Messaggio dinamico
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );

    // Chiude il dialog dopo 2 secondi
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Chiude il dialog
      if (success) {
        // Naviga alla schermata di login se la registrazione ha successo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  // Funzione per verificare la validità della password
  void _validatePassword(String password) {
    String errorMessage = '';
    final hasUppercase = RegExp(r'[A-Z]');
    final hasLowercase = RegExp(r'[a-z]');
    final hasDigits = RegExp(r'[0-9]');
    final hasMinLength = password.length >= 8;

    if (!hasUppercase.hasMatch(password)) {
      errorMessage += 'Password must contain at least one uppercase letter.\n';
    }
    if (!hasLowercase.hasMatch(password)) {
      errorMessage += 'Password must contain at least one lowercase letter.\n';
    }
    if (!hasDigits.hasMatch(password)) {
      errorMessage += 'Password must contain at least one number.\n';
    }
    if (!hasMinLength) {
      errorMessage += 'Password must be at least 8 characters long.\n';
    }

    setState(() {
      _passwordErrorMessage = errorMessage;
    });
  }

  // Funzione per gestire la registrazione
  Future<void> _handleRegister() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      // Mostra un messaggio di errore se i campi sono vuoti
      _showMessageDialog(context, 'Please fill in all fields', false);
      return;
    }

    setState(() {
      _isLoading = true; // Mostra il loading durante la registrazione
    });

    // Chiama il servizio di registrazione
    final registrationService = RegistrationService();
    bool success = await registrationService.registerUser(context, username, password);

    setState(() {
      _isLoading = false; // Nasconde il loading
    });

    // Mostra il messaggio in base al risultato della registrazione
    if (success) {
      _showMessageDialog(context, 'Registration successful', true);
    } else {
      _showMessageDialog(context, 'Registration failed. Please try again.', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Sfondo bianco
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: screenHeight,
          child: Stack(
            children: <Widget>[
              // Onda Superiore
              EllipseUp(),

              // Contenuto Centrale
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20), // Spazio tra l'onda superiore e il logo

                  // Logo
                  Image.asset(
                    'lib/assets/logo.png', // Sostituisci con il percorso del tuo logo
                    width: 150,
                    height: 150,
                  ),

                  // Scritta "Registration"
                  Text(
                    'Registration',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[800], // Colore scuro per il testo
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50], // Colore di sfondo del form
                        borderRadius: BorderRadius.circular(12), // Bordi arrotondati
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3), // Ombra blu chiara
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: const Offset(0, 10), // Posizione ombra
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
                              color: Colors.indigo[700], // Colore del testo dei campi
                            ),
                          ),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue[800]!), // Bordo blu
                              ),
                              hintText: 'Enter your username...',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.indigo[700], // Colore del testo dei campi
                            ),
                          ),
                          // Campo della password senza icona per la visibilità
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible, // Mostra o nasconde la password
                            onChanged: _validatePassword, // Verifica la password ad ogni cambiamento
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue[800]!), // Bordo blu
                              ),
                              hintText: 'Enter your password...',
                            ),
                          ),
                          if (_passwordErrorMessage.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              _passwordErrorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
                                backgroundColor: Colors.blue[700], // Colore blu per il pulsante
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
                                'To log in click here!',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
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
