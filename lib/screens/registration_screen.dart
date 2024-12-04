import 'package:defnet_front_end/screens/login_screen.dart';
import 'package:defnet_front_end/shared/components/shape_lines/ellipse_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importa il pacchetto flutter_svg
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
              const SizedBox(height: 20),
              if (!success)
                Icon(
                  FontAwesomeIcons.timesCircle,
                  color: Colors.red,
                  size: 50,
                ),
              if (success) ...[
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 10),
              Text(
                message,
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

  void _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    setState(() {
      _emailErrorMessage =
      emailRegex.hasMatch(email) ? '' : 'Please enter a valid email address.';
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
      _showMessageDialog(context, 'Please fix the errors before submitting', false);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final registrationService = RegistrationService();
    bool success = await registrationService.registerUser(context, username, password, email);

    setState(() {
      _isLoading = false;
    });

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
                  const SizedBox(height: 20),
                  Image.asset(
                    'lib/assets/logo.png',
                    width: 150,
                    height: 150,
                  ),
                  Text(
                    'Registration',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[800],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                          Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.indigo[700],
                            ),
                          ),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue[800]!),
                              ),
                              hintText: 'Enter your username...',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.indigo[700],
                              ),
                          ),
                          TextField(
                              controller: _emailController,
                              onChanged: _validateEmail,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue[800]!),
                                  ),
                                  hintText: 'Enter your email...',
                              ),
                          ),
                          if (_emailErrorMessage.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              _emailErrorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.indigo[700],
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            onChanged: _validatePassword,
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
                              onPressed: _isLoading ? null : _handleRegister,
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Sign Up'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.blue[700],
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
