import 'package:defnet_front_end/screens/Home/home_screen.dart';  // Importa la schermata Home
import 'package:defnet_front_end/screens/registration_screen.dart'; // Importa la schermata di registrazione
import 'package:flutter/material.dart';  // Importa il materiale Flutter per creare l'interfaccia
import 'package:lottie/lottie.dart';  // Importa il pacchetto Lottie per animazioni

import '../shared/components/shape_lines/ellipse_custom.dart';  // Importa il widget personalizzato per le forme
import '../shared/services/login_service.dart';  // Importa il servizio di login

// La schermata di login è un StatefulWidget, quindi consente di gestire stati dinamici come il loading
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();  // Crea lo stato per la schermata di login
}

class _LoginScreenState extends State<LoginScreen> {

  // Controller per raccogliere i dati di input dell'utente
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variabile per gestire lo stato di caricamento (loading)
  bool _isLoading = false;

  // Funzione che gestisce il processo di login
  Future<void> _handleLogin() async {

    final String username = _usernameController.text;  // Ottieni il testo inserito per username
    final String password = _passwordController.text;  // Ottieni il testo inserito per password


    // Verifica che i campi non siano vuoti
    if (username.isEmpty || password.isEmpty) {
      // Mostra un messaggio di errore se i campi sono vuoti
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
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

    // Se la login è riuscita, naviga alla HomeScreen
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // Se la login fallisce, mostra un messaggio di errore
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(  // Rende la schermata scrollabile
        child: Container(
          width: double.infinity,  // Imposta la larghezza del container al 100% della schermata
          height: MediaQuery.of(context).size.height,  // Imposta l'altezza al 100% della schermata
          child: Stack(  // Usa uno Stack per sovrapporre gli elementi (come il logo e le forme)
            children: <Widget>[
              EllipseUp(),  // Widget personalizzato per l'onda superiore (background)

              // Colonna principale che allinea gli elementi al centro
              Column(
                mainAxisAlignment: MainAxisAlignment.center,  // Allinea gli elementi al centro verticalmente
                children: <Widget>[
                  const SizedBox(height: 20),  // Aggiungi uno spazio sopra il logo
                  Image.asset(
                    'lib/assets/logo.png',  // Mostra il logo
                    width: 150,
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),  // Padding orizzontale per i campi di input
                    child: Container(
                      padding: const EdgeInsets.all(16),  // Padding interno del container
                      decoration: BoxDecoration(
                        color: Colors.white,  // Sfondo bianco
                        borderRadius: BorderRadius.circular(8),  // Angoli arrotondati
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,  // Ombra del box
                            blurRadius: 10,  // Raggio di sfocatura dell'ombra
                            offset: Offset(0, 10),  // Posizione dell'ombra
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,  // Allinea a sinistra gli elementi nel form
                        children: <Widget>[
                          // Campo per l'username
                          Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],  // Colore del testo
                            ),
                          ),
                          TextField(
                            controller: _usernameController,  // Associa il controller all'input dell'username
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),  // Bordo del campo di testo
                              hintText: 'Inserisci il tuo username...',  // Testo di suggerimento
                            ),
                          ),
                          const SizedBox(height: 16),  // Spazio tra i campi
                          // Campo per la password
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],  // Colore del testo
                            ),
                          ),
                          TextField(
                            controller: _passwordController,  // Associa il controller all'input della password
                            obscureText: true,  // Nasconde il testo della password
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),  // Bordo del campo di testo
                              hintText: 'Inserisci la tua password...',  // Testo di suggerimento
                            ),
                          ),
                          const SizedBox(height: 16),  // Spazio tra i campi
                          // Bottone di login
                          Container(
                            width: double.infinity,  // Larghezza completa del bottone
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,  // Se in caricamento, disabilita il bottone
                              child: _isLoading
                                  ? const CircularProgressIndicator()  // Mostra l'indicatore di caricamento
                                  : const Text('Sign In'),  // Testo del bottone
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),  // Padding verticale del bottone
                                backgroundColor: Colors.blue,  // Colore di sfondo del bottone
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),  // Angoli arrotondati del bottone
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),  // Spazio sotto il bottone
                          // Collegamento alla pagina di registrazione
                          Center(
                            child: TextButton(
                              onPressed: () {
                                // Naviga alla schermata di registrazione
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                                );
                              },
                              child: const Text(
                                'Per registrarti clicca qui!',
                                style: TextStyle(
                                  color: Colors.blue,  // Colore del testo
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
