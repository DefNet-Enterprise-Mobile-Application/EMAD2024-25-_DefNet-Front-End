import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  // Variabili per gestire la visibilità delle password
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    // Recupera l'username dell'utente loggato
    String? currentUsername = LoginService.getUsername();  // Usa il tuo LoginService per ottenere l'username loggato
    if (currentUsername != null) {
      _usernameController.text = currentUsername;  // Precompila il campo con l'username dell'utente loggato
    }
  }

  // Funzione per aggiornare la password
  Future<void> _changePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;

    // Ottieni l'ID dell'utente loggato
    String? userId = LoginService.getUserId();  // Utilizza il LoginService per ottenere l'ID dell'utente
    if (userId == null) {
      // Se l'ID utente è null, non possiamo aggiornare il profilo
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User is not logged in")));
      return;
    }

    // Recupera il token dal SecureStorageService
    /*String? token = await SecureStorageService().getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User is not authenticated")),
      );
      return;
    }*/

    // Controlla che i campi non siano vuoti
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in both password fields.")),
      );
      return;
    }

    try {
      // Chiama il servizio per aggiornare la password
      bool success = await ProfileService().changePassword(
        userId: int.parse(userId),
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (success) {
        // Visualizza un messaggio di successo e torna indietro
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Profile updated successfully!"))
        );

        // Svuota i campi e aggiorna lo stato
        setState(() {
          _currentPasswordController.clear();
          _newPasswordController.clear();
        });
      } else {
        // Visualizza un messaggio di errore
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to update profile"))
        );
      }
    }catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Contenuto della pagina
          Padding(
            padding: const EdgeInsets.only(top: 40.0), // Abbassato per lasciare spazio al logo e icone
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Spazio per il contenuto principale
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0), // Spazio sotto il logo
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Modifica Profilo',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                              ),
                              enabled: false, // Rende il campo non modificabile
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _currentPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Current Password',
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: _isCurrentPasswordVisible
                                      ? SvgPicture.asset(
                                    'lib/assets/icons/eye-password-see-view.svg',
                                  )
                                      : SvgPicture.asset(
                                    'lib/assets/icons/eye-password-hide.svg',
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                                    });
                                  },
                                ),

                              ),
                              obscureText: !_isCurrentPasswordVisible,
                            ),
                            const SizedBox(height: 20),
                            // Campo per la nuova password
                            Text("New Password", style: TextStyle(fontSize: 16)),
                            TextFormField(
                              controller: _newPasswordController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: _isNewPasswordVisible
                                      ? SvgPicture.asset(
                                    'lib/assets/icons/eye-password-see-view.svg',
                                  )
                                      : SvgPicture.asset(
                                    'lib/assets/icons/eye-password-hide.svg',
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isNewPasswordVisible = !_isNewPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !_isNewPasswordVisible,
                            ),
                            const SizedBox(height: 30),
                            // Bottone per salvare le modifiche
                            ElevatedButton(
                              onPressed: _changePassword,
                              child: Text("Change Password"),
                            ),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage('lib/assets/avatar/avatar.png'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Logica per caricare un nuovo avatar
                                  },
                                  child: const Text('Cambia Avatar'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Azione per salvare le modifiche
                              },
                              child: const Text('Salva Modifiche'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Metodo per mostrare la finestra di dialogo di logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context){
      return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Bordi arrotondati
          ),
          child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.indigo[900], // Sfondo blu scuro
                borderRadius: BorderRadius.circular(20.0),
              )
          )
      );
    });
  }
}
