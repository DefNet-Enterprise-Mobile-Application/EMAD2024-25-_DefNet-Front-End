import 'package:defnet_front_end/screens/Home/home_screen.dart';  // Importa la schermata Home
import 'package:defnet_front_end/screens/registration_screen.dart'; // Importa la schermata di registrazione
import 'package:flutter/material.dart';  // Importa il materiale Flutter per creare l'interfaccia
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:defnet_front_end/Models/User.dart';
import '../shared/components/shape_lines/ellipse_custom.dart';  // Importa il widget personalizzato per le forme
import '../shared/services/login_service.dart';  // Importa il servizio di login
import 'package:jwt_decoder/jwt_decoder.dart';


// Per memorizzare i dati in modo sicuro
import 'package:defnet_front_end/shared/services/secure_storage_service.dart'; 





class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState(); // Crea lo stato per la schermata di login
}

class _LoginScreenState extends State<LoginScreen> {


  // Controller per raccogliere i dati di input dell'utente
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final SecureStorageService _secureStorage = GetIt.I.get<SecureStorageService>();


  final LoginService _loginService = LoginService();

  // Variabile per gestire lo stato di caricamento (loading)
  bool _isLoading = false;

  bool _isPasswordVisible = false;
  
  String _passwordErrorMessage = '';


  


  // Funzione che mostra un dialog personalizzato
  void _showMessageDialog(BuildContext context, String message, bool success) {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Impedisce di chiudere il dialog cliccando fuori
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[700], // Sfondo blu
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Bordi arrotondati
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              if (!success)
                Icon(
                  FontAwesomeIcons.timesCircle,
                  color: Colors.red,
                  size: 50,
                ),

              if (success) ...[

              Icon(

                FontAwesomeIcons.check,
                color: Colors.green,
                size: 50,
              
              ),
              
              const SizedBox(height: 10),
                
              ],

               Text(
                message,
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

    String username = _usernameController.text.trim(); // Ottieni il testo inserito per username
    String password = _passwordController.text.trim(); // Ottieni il testo inserito per password

    // Verifica che i campi non siano vuoti
    if (username.isEmpty || password.isEmpty) {
      _showMessageDialog(context, 'Please fill in all fields', false);
      return;
    }

    // Imposta lo stato di caricamento su true per mostrare l'indicatore di progressione
    setState(() {
      _isLoading = true;
    });

    FocusScope.of(context).unfocus();

    try {

      
      Map<String, dynamic> response = await _loginService.login(username, password);

      print("Response data: $response");

      if (response['success'] == true && response['access_token'] != null) {
        String token = response['access_token'];

        // Decodifica l'access token
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        int userId = decodedToken['user_id']; // Estrarre l'ID
        String usernameFromToken = decodedToken['sub'];
        String emailFromToken = decodedToken['email'];

        // Salva l'username o usalo per sessione
        print("Logged in as: $usernameFromToken");

        // Salva l'utente in modo sicuro usando GetIt e il servizio SecureStorage
        final user = User(id: userId, username: usernameFromToken, passwordHash: "", email: emailFromToken );
        await _secureStorage.save(user);
        
        /// Return value of Token from SecureStorage of Device  
        String? storedToken = await _secureStorage.getToken();
        print("Stored Token: $storedToken");  // Aggiungi questa riga per verificare
        print('Navigating to HomeScreen...');
        
        
        try {
          // Controlla se l'utente è già registrato
          if (GetIt.I.isRegistered<User>()) {
            print('User already registered in GetIt');
          } else {
            print('Registering user in GetIt');
            GetIt.I.registerSingleton<User>(user);
          }
        } catch (e) {
          print('Error registering user in GetIt: $e');
        }

        /// Login Successful : Message of Success
        _showMessageDialog(context, "Login Successful ", true);

      } else {
        
        
        // Se la login fallisce, mostra un messaggio di errore
        String errorMessage = response['message'] ?? 'Login failed';
        
        /// Login Failed Dialog : Message of Error !  
        _showMessageDialog(context, response['message'], false);
      
      }
    } catch (e) {

      /// Login Failed Dialog 
      _showMessageDialog(context, "Login Failed!", false);

    } finally {
      // Dopo la chiamata al servizio, disabilita il loading
      setState(() {
        _isLoading = false;
      });
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
                  const SizedBox(height: 130),
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

                          /// Password Controller - Form to control the password 
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            onChanged: _onValidatePassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue[800]!),
                              ),
                              hintText: 'Enter your password...',
                              suffixIcon: IconButton(
                                icon: _isPasswordVisible
                                    ? SvgPicture.asset(
                                        'lib/assets/icons/eye-password-see-view.svg',
                                      )
                                    : SvgPicture.asset(
                                        'lib/assets/icons/eye-password-hide.svg',
                                      ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
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


  // validatePassword() - method to validate the password that we have setted 
  void _onValidatePassword(String password) {
    
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





}

