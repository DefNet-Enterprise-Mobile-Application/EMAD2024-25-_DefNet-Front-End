// Importa la schermata Home
import 'package:defnet_front_end/screens/Home/home_screen.dart';
import 'package:defnet_front_end/screens/Notifications/notification_state.dart';
import 'package:defnet_front_end/screens/registration_screen.dart';
// Importa la schermata di registrazione
import 'package:defnet_front_end/shared/components/password_field.dart';
import 'package:defnet_front_end/shared/components/username_field.dart';
import 'package:defnet_front_end/shared/services/websocket_service.dart';
import 'package:flutter/material.dart'; // Importa il materiale Flutter per creare l'interfaccia
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:defnet_front_end/Models/User.dart';
import 'package:provider/provider.dart';
import '../shared/components/shape_lines/ellipse_custom.dart'; // Importa il widget personalizzato per le forme
import '../shared/services/login_service.dart'; // Importa il servizio di login
import 'package:jwt_decoder/jwt_decoder.dart';

// Per memorizzare i dati in modo sicuro
import 'package:defnet_front_end/shared/services/secure_storage_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() =>
      _LoginScreenState(); // Crea lo stato per la schermata di login
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller per raccogliere i dati di input dell'utente
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final SecureStorageService _secureStorage =
      GetIt.I.get<SecureStorageService>();

  final LoginService _loginService = LoginService();

  // Variabile per gestire lo stato di caricamento (loading)
  bool _isLoading = false;

  bool _isPasswordVisible = false;

  String _passwordErrorMessage = '';

  late NotificationState _notificationState;

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
    Future.delayed(const Duration(seconds: 2), () {
      // Cambiato da 1 a 3 secondi
      Navigator.of(context).pop(); // Chiude il dialog
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        ); // Torna al login// Naviga alla schermata Home se il login ha successo
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _notificationState = Provider.of<NotificationState>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              minWidth: double.infinity),
          child: IntrinsicHeight(
            child: Stack(
              children: <Widget>[
                EllipseUp(context),
                Center(
                  // Centra il contenuto nella pagina
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: SingleChildScrollView(
                      // Permette lo scroll se il contenuto è troppo alto
                      child: Column(
                        // Usa Column per supportare Expanded
                        mainAxisSize: MainAxisSize
                            .min, // Adatta la dimensione alla schermata
                        children: <Widget>[
                          const SizedBox(height: 150),
                          _buildHeader('Login'),
                          const SizedBox(height: 20),
                          Container(
                            width: 400,
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
                              mainAxisSize:
                                  MainAxisSize.min, // Evita l'overflow
                              children: <Widget>[
                                // Username Field
                                UsernameField(
                                    usernameController: _usernameController),
                                const SizedBox(height: 16),
                                // Password Field
                                PasswordField(
                                  passwordController: _passwordController,
                                  isPasswordVisible: _isPasswordVisible,
                                  onPasswordChanged: _onValidatePassword,
                                  errorMessage: _passwordErrorMessage,
                                  onTogglePasswordVisibility: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Login Button
                                _buildLoginButton(_notificationState),
                                const SizedBox(height: 16),

                                // Navigation Button to Registration
                                _buildRegistrationNavigationButton()
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Crea un pulsante che permette di navigare alla schermata di registrazione.
  /// Questo pulsante è reattivo e si adatta alla larghezza dello schermo in modo dinamico.
  Center _buildRegistrationNavigationButton() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegistrationScreen()),
            );
          },
          child: const Text(
            'Click here to register!',
            style: TextStyle(color: Colors.blue),
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

  /// Crea un pulsante che permette di eseguire il login.
  /// Il pulsante si adatta dinamicamente alla larghezza dello schermo ed è reattivo a
  /// cambiamenti di stato (ad esempio, quando l'operazione di login è in corso).
  Container _buildLoginButton(NotificationState notificationState) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
                  await _handleLogin(notificationState);
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Sign In'),
        ),
      ),
    );
  }

  /// Crea l'intestazione della schermata di registrazione con il logo e il titolo.
  /// Questa funzione viene utilizzata all'interno del metodo `build()` per creare l'header
  /// della schermata di registrazione.
  Widget _buildHeader(String screenPage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Immagine del logo
        Image.asset(
          'lib/assets/logo.png',
          width: 150,
          height: 150,
        ),
        Text(
          screenPage,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.indigo[800], // Colore scuro per il testo
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin(NotificationState notificationState) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessageDialog(context, 'Please fill in all fields', false);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    FocusScope.of(context).unfocus();

    try {
      Map<String, dynamic> response =
          await _loginService.login(username, password);

      if (response['success'] == true && response['access_token'] != null) {
        String token = response['access_token'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        int userId = decodedToken['user_id'];
        String usernameFromToken = decodedToken['sub'];
        String emailFromToken = decodedToken['email'];

        final user = User(
            id: userId,
            username: usernameFromToken,
            passwordHash: "",
            email: emailFromToken);
        await _secureStorage.save(user);

        if (!GetIt.I.isRegistered<User>()) {
          GetIt.I.registerSingleton<User>(user);
        }

        if (notificationState.webSocketService.isConnected == false) {
          notificationState.webSocketService = WebSocketService();
          // Inizializza il NotificationState
          await notificationState.initialize(userId);
        }

        _showMessageDialog(context, "Login Successful ", true);
      } else {
        String errorMessage = response['message'] ?? 'Login failed';
        _showMessageDialog(context, errorMessage, false);
      }
    } catch (e) {
      _showMessageDialog(context, "Login Failed!", false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
