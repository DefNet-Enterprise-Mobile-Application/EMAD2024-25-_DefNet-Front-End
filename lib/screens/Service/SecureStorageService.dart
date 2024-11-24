import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../Models/User.dart';


class SecureStorageService{

  SecureStorageService._internal();

  static final SecureStorageService instance = SecureStorageService._internal();

  factory SecureStorageService()  {
    //final instance = SecureStorageService._internal();
    return instance;
  }

  final FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    /*iOptions: IOSOptions(
        accessibility: KeychainAccessibility.when_passcode_set_this_device_only
    )*/

  );


  /// save - Metodo che salva tutte le informazioni dello User all'interno della Sessione
  /// Salvataggio in base a <key-value>
  Future<void> save(User user) async {

    try {
      await storage.write(key: 'id', value: user.id.toString() ?? "");
      await storage.write(key: 'username', value: user.username);
      await storage.write(key: 'passwordHash', value: user.passwordHash);
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

  /// Get - metodo per ottenere tutti i dati dello Studente
  Future<User?> get() async {
    try {
      final id = await storage.read(key: 'id');
      //final id = int.tryParse(id ?? '') ?? 0; // Assegna 0 in caso di errore.
      final username = await storage.read(key: 'username');
      final passwordHash = await storage.read(key: 'passwordHash');

      /// Check Params - verifica se sono nulli
      if ( id !=null && username != null && passwordHash != null) {
        return User.buildUser(id,username, passwordHash);
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
      await storage.delete(key: 'id');
      await storage.delete(key: 'username');
      await storage.delete(key: 'passwordHash');
      await storage.delete(key: 'access_token');
      await storage.delete(key: 'token_type');
      return true;
    } catch (e) {
      // Handle errors appropriately (e.g., logging, user feedback)
      print('Error deleting user data: $e');
      return false;
    }
  }



  /// checkParams - Semplice controllo dei parametri per vedere che nessuno di loro è nullo
  bool _checkParams(String username,String passwordHash){
    if ( username != null && passwordHash!=null ){
      return true;
    }
    return false;
  }


}