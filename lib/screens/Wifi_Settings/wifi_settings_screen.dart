import 'package:defnet_front_end/shared/services/wifi_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/services/logout_service.dart';
import '../../shared/services/secure_storage_service.dart';
import '../splash_screen.dart';

class WifiSettingsScreen extends StatefulWidget {
  const WifiSettingsScreen({Key? key}) : super(key: key);

  @override
  State<WifiSettingsScreen> createState() => _WifiSettingsScreenState();
}

class _WifiSettingsScreenState extends State<WifiSettingsScreen> {

  final _wifiNameController = TextEditingController();
  final _newWifiNameController = TextEditingController();
  final _ipGatewayController = TextEditingController();
  final _wifiPasswordController = TextEditingController();

  List<String> passwordErrors = [];
  bool _isPasswordVisible = false;
  String selectedEncryption = 'WPA2'; // Valore iniziale per la crittografia
  bool _isLoading = true;
  String? _error;

  final List<String> encryptionTypes = ['WEP', 'WPA', 'WPA2', 'WPA3'];

  final WifiSettingsService _wifiService = WifiSettingsService();
  final LogoutService _logoutService = LogoutService();

  final SecureStorageService _storageService = SecureStorageService.instance;



  // Funzione che mostra un dialog personalizzato
  void _showMessageDialog(
      BuildContext context, String message, bool success, Function() onConfirm) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impedisce di chiudere il dialog cliccando fuori
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
              const SizedBox(height: 20),
              // Pulsanti per confermare o annullare
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Chiude il dialog e permette all'utente di uscire dall'app
                      Navigator.pop(context);
                      // Esegui l'azione per aggiornare le informazioni
                      onConfirm();
                    },
                    child: Text('Modifica'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);  // Chiude il dialog senza fare nulla
                    },
                    child: Text('Annulla'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }



  void _showMessageDialogUpdateSettings(BuildContext context, String message, bool success) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impedisce di chiudere il dialog cliccando fuori
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
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }


  Future<void> _loadWifiSettings() async {
    try {
      final settings = await _wifiService.getWifiSettings();
      setState(() {
        _wifiNameController.text = settings['ssid'] ?? '';
        _ipGatewayController.text = settings['lan_ip'] ?? ''; // Popola il campo del gateway
        selectedEncryption = settings['encryption'] ?? 'WPA2';
        _wifiPasswordController.text = settings['password'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _loadWifiSettings();
  }

  void _validatePassword(String password) {
    List<String> errors = [];
    final hasUppercase = RegExp(r'[A-Z]');
    final hasLowercase = RegExp(r'[a-z]');
    final hasDigits = RegExp(r'[0-9]');
    final hasSpecialChar = RegExp(r'[@$!%*?&]');
    final hasMinLength = password.length >= 8;

    if (!hasUppercase.hasMatch(password)) {
      errors.add('Password must contain at least one uppercase letter.');
    }
    if (!hasLowercase.hasMatch(password)) {
      errors.add('Password must contain at least one lowercase letter.');
    }
    if (!hasDigits.hasMatch(password)) {
      errors.add('Password must contain at least one number.');
    }
    if (!hasSpecialChar.hasMatch(password)) {
      errors.add('Password must contain at least one special character.');
    }
    if (!hasMinLength) {
      errors.add('Password must be at least 8 characters long.');
    }

    setState(() {
      passwordErrors = errors;
    });
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Chiude il dialogo
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      labelStyle: const TextStyle(color: Colors.blue),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/icons/settingswifi.png',
                    height: 60, // Ridurre l'immagine
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Settings Wi-Fi',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 30, // Ridurre la dimensione del testo
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              //const SizedBox(height: 0), // Distanza tra il titolo e la box
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                color: Colors.grey.shade100,  // Imposta il colore della card a grigio chiaro
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _wifiNameController,
                        decoration: inputDecoration.copyWith(
                          labelText: 'Current Wi-Fi Name',
                        ),
                        enabled: false, // Campo non modificabile
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _newWifiNameController,
                        decoration: inputDecoration.copyWith(
                          labelText: 'New Wi-Fi Name',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ipGatewayController,
                              decoration: inputDecoration.copyWith(
                                labelText: 'IP Gateway',
                              ),
                              enabled: false, // Campo non modificabile
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'lib/assets/icons/info.png', // Percorso della tua immagine
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                            onPressed: () {
                              _showInfoDialog(
                                'IP Gateway',
                                'The IP Gateway is the IP address of your router. This is where your network connects to the internet. You can modify it if needed.',
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedEncryption,
                              items: encryptionTypes
                                  .map((type) => DropdownMenuItem<String>(value: type, child: Text(type)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedEncryption = value!;
                                });
                              },
                              decoration: inputDecoration.copyWith(
                                labelText: 'Encryption Type',
                              ),
                              icon: Image.asset(
                                'lib/assets/icons/freccia.png', // Percorso della tua immagine per la freccia
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'lib/assets/icons/info.png', // Percorso della tua immagine
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                            onPressed: () {
                              _showInfoDialog(
                                'Encryption Type',
                                'Encryption types such as WPA2 or WPA3 ensure the security of your Wi-Fi network. Choose the one that suits your router.',
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _wifiPasswordController,
                        obscureText: !_isPasswordVisible,
                        decoration: inputDecoration.copyWith(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: _isPasswordVisible
                                ? SvgPicture.asset('lib/assets/icons/eye-password-see-view.svg')
                                : SvgPicture.asset('lib/assets/icons/eye-password-hide.svg'),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        onChanged: _validatePassword,
                      ),
                      if (passwordErrors.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: passwordErrors.map((error) {
                            return Text(
                              error,
                              style: const TextStyle(color: Colors.red, fontSize: 10),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (passwordErrors.isEmpty) {
                            print('Current Wi-Fi Name: ${_wifiNameController.text}');
                            print('New Wi-Fi Name: ${_newWifiNameController.text}');
                            print('IP Gateway: ${_ipGatewayController.text}');
                            print('Encryption: $selectedEncryption');
                            print('Password: ${_wifiPasswordController.text}');
                            Map<String, String> new_settings = {};

                            // Definire le nuove impostazioni Wi-Fi
                            if (_wifiNameController.text != _newWifiNameController.text &&
                                _newWifiNameController.text.isNotEmpty) {
                              new_settings = {
                                'ssid': _newWifiNameController.text,
                                'lan_ip': _ipGatewayController.text,
                                'password': _wifiPasswordController.text,
                                'encryption': selectedEncryption.toString()
                              };
                            } else {
                              new_settings = {
                                'ssid': _wifiNameController.text,
                                'lan_ip': _ipGatewayController.text,
                                'password': _wifiPasswordController.text,
                                'encryption': selectedEncryption.toString()
                              };
                            }

                            // Mostra il dialog di conferma per l'aggiornamento delle impostazioni Wi-Fi
                            _showMessageDialog(
                              context,
                              'Sei sicuro di voler aggiornare le impostazioni Wi-Fi?',
                              true, // Mostra il successo (puoi cambiare a false se serve un'icona d'errore)
                                  () async {

                                    /// Do Logout and delete every Info about User
                                    var responseLogout = await _logoutService.logout(_storageService);

                                    var result = await _wifiService
                                        .updateSettings(new_settings);

                                    if (result['status'] == 'pending' && responseLogout) {

                                      _showMessageDialogUpdateSettings(context, result['message'], true);
                                      /// Timer per disconnettere l'utente
                                      Future.delayed(Duration(seconds: 8), () {
                                        _logout();
                                      });

                                    } else {
                                      _showMessageDialogUpdateSettings(context, result['message'], false);
                                    }
                                  }
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.blue.shade600,
                        ),
                        child: const Text(
                          'Save Settings',
                          style: TextStyle(
                            fontSize: 15, // Ridurre la dimensione del testo
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }
}
