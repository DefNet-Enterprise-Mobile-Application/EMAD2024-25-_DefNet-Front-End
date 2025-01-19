import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart'; // Importa image_picker
import 'dart:io'; // Per gestire i file immagine
import '../../shared/services/login_service.dart';
import '../../shared/services/profile_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _usernameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  String _currentPasswordErrorMessage = '';
  String _newPasswordErrorMessage = '';

  File? _imageFile; // Variabile per immagine dell'avatar

  @override
  void initState() {
    super.initState();
    String? currentUsername = LoginService.getUsername();
    if (currentUsername != null) {
      _usernameController.text = currentUsername;
    }
  }

  void _validatePassword(String password, bool isNewPassword) {
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
      if (isNewPassword) {
        _newPasswordErrorMessage = errorMessage;
      } else {
        _currentPasswordErrorMessage = errorMessage;
      }
    });
  }

  Future<void> _changePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String? userId = LoginService.getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User is not logged in")));
      return;
    }
    // Controlla che i campi non siano vuoti
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in both password fields.")),
      );
      return;
    }

    try {
      bool success = await ProfileService().changePassword(
        userId: int.parse(userId),
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully!")));
        setState(() {
          _currentPasswordController.clear();
          _newPasswordController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update profile")));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${error.toString()}")));
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery); // Galleria

    if (image != null) {
      setState(() {
        _imageFile = File(image.path); // Aggiorna l'immagine dell'avatar
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            child: Column(
              children: [
                // Titolo della schermata con immagine a sinistra
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // L'immagine a sinistra (sostituito con Image.asset)
                    Image.asset(
                      'lib/assets/icons/edit.png', // Sostituisci con il percorso corretto dell'immagine
                      width: 40, // Imposta la larghezza dell'immagine
                      height: 60, // Imposta l'altezza dell'immagine
                    ),
                    const SizedBox(width: 10), // Spazio tra l'immagine e il testo
                    // Il testo
                    Text(
                      'Edit profile',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 30, // Font ridotto
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.blue.shade300.withOpacity(0.6),
                            offset: const Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Spazio ridotto

                // Il container per i form
                Container(
                  width: 300, // Ridotto per rendere i form più piccoli
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50, // Colore di sfondo grigio chiaro
                    borderRadius: BorderRadius.circular(16), // Angoli arrotondati per la box
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Padding ridotto
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40, // Avatar più piccolo
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!) // Usa l'immagine selezionata
                                : AssetImage('lib/assets/avatar/avatar.png') as ImageProvider,
                          ),
                          Positioned(
                            top: 40,
                            left: 40,  // Distanza dalla destra
                            child: GestureDetector(
                              onTap: _pickImage, // Attiva il metodo per scegliere l'immagine
                              child: Image.asset(
                                'lib/assets/icons/foto.png', // Sostituisci con il percorso corretto dell'immagine
                                width: 50, // Imposta la larghezza dell'immagine
                                height: 50, // Imposta l'altezza dell'immagine
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16), // Spazio ridotto

                      // Container per il username con box bianco
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8), // Bordo più stretto
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade800,
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10), // Ridotto padding
                          ),
                          enabled: false,
                        ),
                      ),
                      const SizedBox(height: 16), // Spazio ridotto

                      // Container per la password attuale
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8), // Bordo più stretto
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade800,
                              blurRadius: 8,
                              //spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _currentPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Current Password',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(10), // Ridotto padding
                            suffixIcon: IconButton(
                              icon: _isCurrentPasswordVisible
                                  ? SvgPicture.asset('lib/assets/icons/eye-password-see-view.svg')
                                  : SvgPicture.asset('lib/assets/icons/eye-password-hide.svg'),
                              onPressed: () {
                                setState(() {
                                  _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isCurrentPasswordVisible,
                          onChanged: (value) {
                            _validatePassword(value, false);
                          },
                        ),
                      ),
                      if (_currentPasswordErrorMessage.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          _currentPasswordErrorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Container per la nuova password
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8), // Bordo più stretto
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade800,
                              blurRadius: 8,
                              //spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _newPasswordController,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(10), // Ridotto padding
                            suffixIcon: IconButton(
                              icon: _isNewPasswordVisible
                                  ? SvgPicture.asset('lib/assets/icons/eye-password-see-view.svg')
                                  : SvgPicture.asset('lib/assets/icons/eye-password-hide.svg'),
                              onPressed: () {
                                setState(() {
                                  _isNewPasswordVisible = !_isNewPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isNewPasswordVisible,
                          onChanged: (value) {
                            _validatePassword(value, true);
                          },
                        ),
                      ),
                      if (_newPasswordErrorMessage.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          _newPasswordErrorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Bottone "Save Settings" con stile applicato
                      ElevatedButton(
                        onPressed: _changePassword,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.blue.shade600, // Colore di sfondo
                        ),
                        child: const Text(
                          'Save Settings',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
