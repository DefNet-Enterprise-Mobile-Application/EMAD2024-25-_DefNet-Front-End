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
    return Scaffold(
      backgroundColor: Colors.white,
        body: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;
              final isSmallScreen = screenWidth < 600;

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: screenHeight, minWidth: double.infinity),
                  child: Stack(
                    children: <Widget>[
                      EllipseUp(context),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // Impedisce alla colonna di superare lo spazio disponibile
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 180), // Spazio superiore
                            _buildHeader('Registration'),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: isSmallScreen ? 10 : 20),
                              // Adattato per schermi piccoli
                              child: Container(
                                width: isSmallScreen ? screenWidth * 0.9 : 500,
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
                                  mainAxisSize: MainAxisSize.min,
                                  // Occupa solo lo spazio necessario
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
                                          _isPasswordVisible =
                                          !_isPasswordVisible;
                                        });
                                      },
                                    ),

                                    const SizedBox(height: 16),

                                    /// Perform Registration Button
                                    _buildRegistrationButton(isSmallScreen),
                                    const SizedBox(height: 16),

                                    /// Login Button to navigation into LoginScreen
                                    _buildLoginNavigationButton()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        ),
    );
  }

  /// Costruisce il bottone per la registrazione (Sign Up).
  Widget _buildRegistrationButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity, // Imposta la larghezza del bottone a quella massima disponibile
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 14 : 16), // Variato in base alla larghezza dello schermo
          backgroundColor: Colors.blue[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('Sign Up'),
      ),
    );
  }

  /// Costruisce il bottone per navigare alla schermata di login.
  Center _buildLoginNavigationButton() {
    return Center(
      child: TextButton(
        onPressed: () {
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
    );
  }

  /// Crea l'intestazione della schermata di registrazione con il logo e il titolo.
  Widget _buildHeader(String screenPage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center, // Centra tutto
      children: <Widget>[
        const SizedBox(height: 12),
        Image.asset(
          'lib/assets/logo.png',
          width: 150,
          height: 120,
        ),
        Text(
          screenPage,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.indigo[800],
          ),
        ),
        const SizedBox(height: 1),
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
