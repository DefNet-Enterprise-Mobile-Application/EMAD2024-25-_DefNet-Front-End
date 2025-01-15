import 'package:defnet_front_end/screens/login_screen.dart';
import 'package:defnet_front_end/shared/components/email_field.dart';
import 'package:defnet_front_end/shared/components/password_field.dart';
import 'package:defnet_front_end/shared/components/shape_lines/ellipse_custom.dart';
import 'package:defnet_front_end/shared/components/username_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../shared/services/registration_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String _passwordErrorMessage = '';
  String _emailErrorMessage = '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: screenHeight,
          child: Stack(
            children: <Widget>[
              EllipseUp(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 130),
                  _buildHeader('Registration'),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /// Username Field - Insert text into textField
                          UsernameField(
                              usernameController: _usernameController),

                          const SizedBox(height: 16),

                          /// Email Field - Insert Email into TextField
                          EmailField(
                            emailController: _emailController,
                            emailErrorMessage: _emailErrorMessage,
                            onChanged: _validateEmail,
                          ),
                          const SizedBox(height: 16),

                          /// Password Field - Insert Password into TextField and validate that
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

                          /// Perform Registration Button
                          _buildRegistrationButton(),
                          const SizedBox(height: 16),

                          /// Login Button to navigation into LoginScreen
                          _buildLoginNavigationButton()
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

  /// Costruisce il bottone per la registrazione (Sign Up).
  ///
  /// Questo metodo crea un bottone di tipo `ElevatedButton`, che se premuto
  /// esegue la funzione `_handleRegister`. Se il flag `_isLoading` è attivo,
  /// il bottone mostrerà un indicatore di caricamento (un `CircularProgressIndicator`),
  /// altrimenti mostrerà il testo "Sign Up". Il bottone ha uno stile personalizzato
  /// con un bordo arrotondato e uno sfondo blu.
  ///
  /// - Restituisce un `Container` che contiene l'`ElevatedButton` per la registrazione.
  Container _buildRegistrationButton() {
    return Container(
      width: double
          .infinity, // Imposta la larghezza del bottone a quella massima disponibile
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : _handleRegister, // Mostra il testo "Sign Up" se il flag è falso
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              vertical: 16), // Padding verticale del bottone
          backgroundColor:
              Colors.blue[700], // Colore di sfondo blu per il bottone
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8), // Bordo arrotondato per il bottone
          ),
        ), // Disabilita il bottone se il flag `_isLoading` è vero
        child: _isLoading
            ? const CircularProgressIndicator() // Mostra l'indicatore di caricamento se `_isLoading` è vero
            : const Text('Sign Up'),
      ),
    );
  }

  /// Costruisce il bottone per navigare alla schermata di login.
  ///
  /// Questo metodo crea un `TextButton` che, quando premuto, naviga alla schermata di login.
  /// Utilizza la funzione `Navigator.pushReplacement` per sostituire la schermata corrente con
  /// la `LoginScreen`. Il bottone contiene il testo "To log in click here!" con uno stile
  /// personalizzato per il colore e la dimensione del testo.
  ///
  /// - Restituisce un `Center` che contiene il `TextButton` per la navigazione.
  Center _buildLoginNavigationButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginScreen()), // Naviga alla schermata di login
          );
        },
        child: const Text(
          'To log in click here!', // Testo che indica la possibilità di navigare alla schermata di login
          style: TextStyle(
            color: Colors.blue, // Colore del testo del bottone
            fontSize: 16, // Dimensione del font
          ),
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

        // Testo "Registration"
        const SizedBox(height: 5), // Aggiunge spazio tra l'immagine e il testo
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

  void _showMessageDialog(BuildContext context, String message, bool success) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

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

  void _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    setState(() {
      _emailErrorMessage = emailRegex.hasMatch(email)
          ? ''
          : 'Please enter a valid email address.';
    });
  }

  Future<void> _handleRegister() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String email = _emailController.text;

    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      _showMessageDialog(context, 'Please fill in all fields', false);
      return;
    }

    if (_emailErrorMessage.isNotEmpty || _passwordErrorMessage.isNotEmpty) {
      _showMessageDialog(
          context, 'Please fix the errors before submitting', false);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final registrationService = RegistrationService();
    bool success = await registrationService.registerUser(
        context, username, password, email);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      _showMessageDialog(context, 'Registration successful', true);
    } else {
      _showMessageDialog(
          context, 'Registration failed. Please try again.', false);
    }
  }
}
