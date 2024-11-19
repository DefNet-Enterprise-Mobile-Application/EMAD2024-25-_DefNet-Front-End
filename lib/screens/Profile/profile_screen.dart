import 'package:flutter/material.dart';
import '../../shared/services/login_service.dart';
import '../../shared/services/profile_service.dart';  // Importa il ProfileService per aggiornare il profilo

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isEditing = false;  // Flag per sapere se l'utente sta modificando

  @override
  void initState() {
    super.initState();

    // Recupera l'username dell'utente loggato
    String? currentUsername = LoginService.getUsername();  // Usa il tuo LoginService per ottenere l'username loggato
    if (currentUsername != null) {
      _usernameController.text = currentUsername;  // Precompila il campo con l'username dell'utente loggato
    }
  }

  // Funzione per salvare le modifiche
  Future<void> _saveProfileChanges() async {
    String newUsername = _usernameController.text;
    String newPassword = _passwordController.text;

    // Ottieni l'ID dell'utente loggato
    String? userId = LoginService.getUserId();  // Utilizza il LoginService per ottenere l'ID dell'utente
    if (userId == null) {
      // Se l'ID utente è null, non possiamo aggiornare il profilo
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User is not logged in")));
      return;
    }

    // Passa null per la password se è vuota
    String? passwordToUpdate = newPassword.isEmpty ? null : newPassword;

    // Chiama il servizio per aggiornare il profilo
    bool success = await _updateProfile(int.parse(userId), newUsername, passwordToUpdate);

    if (success) {
      // Visualizza un messaggio di successo e torna indietro
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully!")));
      setState(() {
        _isEditing = false;  // Esci dalla modalità di modifica
      });
    } else {
      // Visualizza un messaggio di errore
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update profile")));
    }
  }

  Future<bool> _updateProfile(int userId, String username, String? password) async {
    // Usa il ProfileService per aggiornare il profilo
    return await ProfileService().updateProfile(
      userId,  // Passa l'ID dell'utente
      username, // Passa il nuovo username
      null,     // Current password (nel caso non serva)
      password, // Nuova password, oppure null se non modificata
    );
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
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 20),
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
