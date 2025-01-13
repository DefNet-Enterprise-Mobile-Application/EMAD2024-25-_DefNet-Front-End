import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class WebSocketService {
  bool hasNewNotifications = false;// Variabile per gestire lo stato delle notifiche

  static final String? port = dotenv.env['PORT_MICROSERVICE'];
  static final String? IP_RASP = dotenv.env['IP_RASP'];
  static final String baseUrl = 'ws://${IP_RASP!}:$port';

  WebSocketChannel? _channel; // Aggiunta la variabile per il WebSocketChannel

  StreamController<String> _notificationController = StreamController<String>.broadcast();

  // ValueNotifier per aggiornare lo stato delle notifiche
  ValueNotifier<bool> notificationNotifier = ValueNotifier(false);

  Stream<String> get notificationsStream => _notificationController.stream;

  WebSocketService();

  // Inizializza la connessione WebSocket
  void connect() {

      // Evita di creare un nuovo StreamController se già esiste
      if (_channel != null) {
        print('WebSocket già connesso, nessuna nuova connessione');
        return;
      }

      try{
      _channel =
          WebSocketChannel.connect(Uri.parse('$baseUrl/ws/notifications'));
      print('Connesso al WebSocket');

      _channel!.stream.listen((message) {
        print('Messaggio ricevuto: $message'); // Debug
        if (!_notificationController.isClosed) {
          _notificationController.add(message); // Invia il messaggio al controller
        }
        // Aggiorna lo stato delle notifiche
        hasNewNotifications = true;
        notificationNotifier.value = true; // Notifica il cambiamento
      },
        onDone: () {
            print('Connessione WebSocket chiusa, tentativo di riconnessione...');
            // Tentativo di riconnessione
            connect();
          },
        onError: (error) {
          print('Errore nella connessione WebSocket: $error');
          // Tentativo di riconnessione in caso di errore
          connect();
        },
      );
    }catch(e){
      print('Errore durante la connessione al WebSocket: $e');
    }
  }

  // Chiudi la connessione
  void disconnect() {
    _notificationController.close();
    _channel?.sink.close(); // Chiudi il canale WebSocket
    _channel = null; // Nullifica il canale per evitare riconnessioni multiple
    print('Connessione WebSocket chiusa');
  }

  // Resetta lo stato delle notifiche
  void resetNotifications() {
    hasNewNotifications = false;
    notificationNotifier.value = false; // Resetta il ValueNotifier
  }
}
