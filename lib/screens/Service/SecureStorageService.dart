import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../Models/User.dart';


class SecureStorageService{

  static const String port = '8000';
  static const String url = 'http://';
  static String? IP_RASP = dotenv.env['IP_RASP'];
  static String baseUrl = url + IP_RASP! + ':' + port + '/logout';

  SecureStorageService._internal();

  static final SecureStorageService instance = SecureStorageService._internal();

  factory SecureStorageService()  {
    return instance;
  }

  final FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );


  /// save - Metodo che salva tutte le informazioni dello User all'interno della Sessione
  /// Salvataggio in base a <key-value>
  Future<void> save(User user) async {

    try {
      await storage.write(key: 'id', value: user.id.toString() ?? "");
      await storage.write(key: 'username', value: user.username);
      await storage.write(key: 'passwordHash', value: user.passwordHash);
      await storage.write(key: 'email', value: user.email);
    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print('Error saving user data: $e');
    }
  }

  /// saveToken - Salva il token di accesso
  Future<void> saveToken(String token) async {
    try {
      await storage.write(key: 'access_token', value: token);
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  /// saveTokenType - Salva il tipo di token (Bearer)
  Future<void> saveTokenType(String tokenType) async {
    try {
      await storage.write(key: 'token_type', value: tokenType);
    } catch (e) {
      print('Error saving token type: $e');
    }
  }

  /// Get - metodo per ottenere tutti i dati dell'utente
  Future<User?> get() async {
    try {
      final id = await storage.read(key: 'id');
      final username = await storage.read(key: 'username');
      final passwordHash = await storage.read(key: 'passwordHash');
      final email = await storage.read(key: 'email');

      /// Check Params - verifica se sono nulli
      if ( id !=null && username != null && passwordHash != null && email != null) {
        return User.buildUser(id,username, passwordHash, email);
      } else {
        return null;
      }

    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print("Errror: "+e.toString());
      return null;
    }
  }

  /// getToken - Ottieni il token di accesso
  Future<String?> getToken() async {
    try {
      return await storage.read(key: 'access_token');
    } catch (e) {
      print("Error fetching token: $e");
      return null;
    }
  }

  /// getTokenType - Ottieni il tipo di token
  Future<String?> getTokenType() async {
    try {
      return await storage.read(key: 'token_type');
    } catch (e) {
      print("Error fetching token type: $e");
      return null;
    }
  }

  // *Delete User data:*
  Future<bool> delete() async {
    try {
      // Ottieni il token di accesso salvato nello storage locale
      String? token = await storage.read(key: 'access_token');

      // Verifica che il token esista
      if (token == null) {
        print('No token found, skipping logout process.');
        return false;
      }

      // Invia la richiesta POST al backend per il logout, passando il token nell'header Authorization
      final response = await http.post(
        Uri.parse('$baseUrl'), // Sostituisci con l'URL del tuo backend
        headers: {
          'Authorization': 'Bearer $token',  // Passa il token nell'header Authorization
        },
      );

      if (response.statusCode == 200) {
        print('Logged out successfully');

        // Cancella tutti i dati dallo storage locale
        await Future.wait([
        storage.delete(key: 'id'),
        storage.delete(key: 'username'),
        storage.delete(key: 'passwordHash'),
        storage.delete(key: 'access_token'),
        storage.delete(key: 'token_type'),
        storage.delete(key: 'email'),
        ]);

        // Resetta il servizio registrato in GetIt
        final secureStorageService = GetIt.I<SecureStorageService>();
        await secureStorageService.delete();  // Rimuove i dati memorizzati in memoria sicura
        GetIt.I.unregister<User>();  // Rimuove l'utente da GetIt

        return true;

      }else{
        print('Failed to log out: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print('Error deleting user data: $e');
      return false;
    }
  }



  /// checkParams - Semplice controllo dei parametri per vedere che nessuno di loro è nullo
  bool _checkParams(String username,String passwordHash, String email){
    if ( username != null && passwordHash != null && email != null ){
      return true;
    }
    return false;
  }


}