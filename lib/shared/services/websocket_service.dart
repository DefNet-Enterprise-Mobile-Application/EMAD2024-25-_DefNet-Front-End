import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:http/http.dart' as http;

import 'secure_storage_service.dart';

class WebSocketService {
  
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _controller;

  String? ip_service_socket = dotenv.env['IP_RASP'];
  String? protocol_web_socket = dotenv.env['PROTOCOL_WEB_SOCKET'];
  String? port_web_socket = dotenv.env['PORT_MICROSERVICE'];

  final SecureStorageService _secureStorageService = GetIt.I<SecureStorageService>();

  bool isConnected = false;  // Variabile per tracciare lo stato della connessione

  WebSocketService() {
    _controller = StreamController<Map<String, dynamic>>.broadcast();
  }

  Stream<Map<String, dynamic>> get notificationsStream => _controller!.stream;

  /// Getter per ottenere lo stato di connessione
  bool get connectionStatus => isConnected;

  /// Avvia la connessione al WebSocket con l'ID dell'utente
  Future<void> connect(int userId) async {
    try {
      if (kDebugMode) {
        print("Sono qui!");
      }

      // Costruisci l'URL del WebSocket con l'ID utente
      String webSocketFinalUrl = "$protocol_web_socket$ip_service_socket:$port_web_socket/ws/$userId/notifications";

      if (kDebugMode) {
        print("WEB-SOCKET URL : $webSocketFinalUrl");
      }

      // Crea la connessione WebSocket
      _channel = WebSocketChannel.connect(Uri.parse(webSocketFinalUrl));

      // Ascolta i messaggi in arrivo
      _channel!.stream.listen(
        (message) {
          try {
            // Parse del messaggio JSON
            var data = jsonDecode(message);
            _controller?.add(data);
          } catch (e) {
            if (kDebugMode) {
              print("Errore durante il parsing del messaggio WebSocket: $e");
            }
          }
        },
        onError: (error) {
          if (kDebugMode) {
            print("Errore WebSocket: $error");
          }
        },
        onDone: () {
          // Connessione chiusa
          if (kDebugMode) {
            print("Connessione WebSocket chiusa.");
          }
          isConnected = false;  // Imposta la variabile di stato
        },
      );

      // Imposta la connessione come attiva
      isConnected = true;
      if (kDebugMode) {
        print("Connessione WebSocket stabilita.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Errore durante la connessione al WebSocket: $e");
      }
      isConnected = false;
    }
  }

  /// Invia un messaggio tramite il WebSocket
  void sendMessage(String message) {
    if (_channel != null && isConnected) {
      _channel!.sink.add(message);
    } else {
      if (kDebugMode) {
        print("Connessione WebSocket non disponibile.");
      }
    }
  }

  /// Libera le risorse
  void dispose() {
    _controller?.close();
    _channel?.sink.close();
    isConnected = false;  // Imposta la connessione come chiusa
  }
}
