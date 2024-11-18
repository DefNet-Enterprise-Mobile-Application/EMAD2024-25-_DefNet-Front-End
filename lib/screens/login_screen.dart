import 'package:defnet_front_end/screens/Home/home_screen.dart'; // Importa la schermata Home
import 'package:defnet_front_end/screens/registration_screen.dart'; // Importa la schermata di registrazione
import 'package:flutter/material.dart'; // Importa il materiale Flutter per creare l'interfaccia

import '../shared/components/shape_lines/ellipse_custom.dart'; // Importa il widget personalizzato per le forme
import '../shared/services/login_service.dart'; // Importa il servizio di login

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState(); // Crea lo stato per la schermata di login
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller per raccogliere i dati di input dell'utente
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variabile per gestire lo stato di caricamento (loading)
  bool _isLoading = false;

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
              Text(
                message, // Messaggio dinamico
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      },
    );

    // Chiudi il dialog dopo 3 secondi
    Future.delayed(const Duration(seconds: 2), () { // Cambiato da 1 a 3 secondi
      Navigator.of(context).pop(); // Chiude il dialog
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        ); // Naviga alla schermata Home se il login ha successo
      }
    });
  }

  // Funzione che gestisce il processo di login
  Future<void> _handleLogin() async {
    final String username = _usernameController.text; // Ottieni il testo inserito per username
    final String password = _passwordController.text; // Ottieni il testo inserito per password

    // Verifica che i campi non siano vuoti
    if (username.isEmpty || password.isEmpty) {
      _showMessageDialog(context, 'Please fill in all fields', false);
      return;
    }

    // Imposta lo stato di caricamento su true per mostrare l'indicatore di progressione
    setState(() {
      _isLoading = true;
    });

    // Chiamata al servizio di login per validare le credenziali
    final loginService = LoginService();
    bool success = await loginService.login(username, password);

    // Dopo la chiamata al servizio, disabilita il loading
    setState(() {
      _isLoading = false;
    });

    // Mostra il dialog in base al risultato del login
    if (success) {
      _showMessageDialog(context, 'Login successful', true);
    } else {
      _showMessageDialog(context, 'Login failed. Please check your credentials and try again.', false);
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
              EllipseUp(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Image.asset(
                    'lib/assets/logo.png',
                    width: 150,
                    height: 150,
                  ),
                  // Scritta "Registration"
                  Text(
                    'Login',
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter your username...',
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter your password...',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Sign In'),
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
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const RegistrationScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Click here to register!',
                                style: TextStyle(color: Colors.blue),
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
