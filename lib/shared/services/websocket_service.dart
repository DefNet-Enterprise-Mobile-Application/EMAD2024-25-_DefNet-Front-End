import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:http/http.dart' as http;

import 'secure_storage_service.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  StreamController<String>? _controller;

  String? ip_service_socket = dotenv.env['IP_RASP'];
  String? protocol_web_socket = dotenv.env['PROTOCOL_WEB_SOCKET'];
  String? port_web_socket = dotenv.env['PORT_MICROSERVICE'];

  final SecureStorageService _secureStorageService = GetIt.I<SecureStorageService>();

  WebSocketService() {
    _controller = StreamController<String>.broadcast();
  }

  Stream<String> get notificationsStream => _controller!.stream;

  /// Avvia la connessione al WebSocket con l'ID dell'utente
  Future<void> connect(int userId) async {
    try {
      if (kDebugMode) {
        print("Sono qui !");
      }
      // Recupera l'ID dell'utente (se necessario anche altre informazioni utente)
      final user_id = userId;

      if (user_id == null) {
        throw Exception("User ID non valido. Non è possibile avviare la connessione WebSocket.");
      }

      // Costruisci l'URL del WebSocket con l'ID utente
      String webSocketFinalUrl = "$protocol_web_socket$ip_service_socket:$port_web_socket/ws/$user_id/alerts";

      if (kDebugMode) {
        print("WEB-SOCKET URL : $webSocketFinalUrl");
      }

      // Crea la connessione WebSocket
      _channel = WebSocketChannel.connect(Uri.parse(webSocketFinalUrl));

      // Ascolta i messaggi in arrivo
      _channel!.stream.listen(
        (message) {
          _controller?.add(message);
        },
        onError: (error) {
          if (kDebugMode) {
            print("Errore WebSocket: $error");
          }
        },
        onDone: () {
          if (kDebugMode) {
            print("Connessione WebSocket chiusa.");
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Errore durante la connessione al WebSocket: $e");
      }
    }
  }

  /// Invia un messaggio tramite il WebSocket
  void sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    } else {
      if (kDebugMode) {
        print("Connessione WebSocket non disponibile.");
      }
    }
  }

  /// Chiudi la connessione WebSocket e invia una richiesta di disconnessione al backend
  Future<void> disconnect(int userId) async {
    try {
      // Invoca il backend per disconnettere l'utente
      final response = await _sendDisconnectRequest(userId);

      if (response.statusCode == 200) {
        // Se la risposta è positiva, chiudi la connessione WebSocket
        _channel?.sink.close(status.goingAway);
        _channel = null;
        if (kDebugMode) {
          print("Connessione WebSocket chiusa correttamente.");
        }
      } else {
        if (kDebugMode) {
          print("Errore nella disconnessione lato server: ${response.body}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Errore durante la disconnessione: $e");
      }
    }
  }

  /// Invia una richiesta di disconnessione al backend
  Future<http.Response> _sendDisconnectRequest(int userId) async {
    final url = Uri.parse("http://$ip_service_socket:$port_web_socket/ws/$userId/disconnect");

    try {
      // Recupera il token JWT per l'autenticazione (se necessario)
      final token = await _secureStorageService.getToken();
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.post(url, headers: headers);

      return response;
    } catch (e) {
      throw Exception("Errore nella richiesta di disconnessione: $e");
    }
  }

  /// Libera le risorse
  void dispose() {
    _controller?.close();
    _channel?.sink.close();
  }
}
