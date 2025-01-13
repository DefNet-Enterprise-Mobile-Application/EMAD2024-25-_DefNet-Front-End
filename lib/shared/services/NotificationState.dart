import 'package:defnet_front_end/shared/services/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


class NotificationState extends ChangeNotifier {
  bool _hasNewNotifications = false;
  List<Map<String, String>> _notifications = [];

  bool get hasNewNotifications => _hasNewNotifications;
  List<Map<String, String>> get notifications => _notifications;

  // Usa il WebSocketService centralizzato
  final WebSocketService _webSocketService = GetIt.I<WebSocketService>();

  NotificationState() {
    // Ascolta il flusso di notifiche non appena viene creato
    listenToWebSocket();
  }

  void updateNotifications(bool value) {
    if (_hasNewNotifications != value) { // Notifica solo se c'è un cambiamento
      print('Aggiornamento notifiche: $value'); // Aggiungi log
      _hasNewNotifications = value;
      notifyListeners();
    }
  }

  void resetNotifications() {
    if (_hasNewNotifications) { // Notifica solo se c'è un cambiamento
      _hasNewNotifications = false;
      notifyListeners();
    }
  }

  // Aggiungi una nuova notifica alla lista
  void addNotification(String topic, String message) {
    _notifications.add({'Topic': topic, 'Message': message});
    _hasNewNotifications = true;  // Segnala che ci sono nuove notifiche
    notifyListeners();  // Notifica la UI
  }

  // Ascolta le notifiche dal WebSocket
  void listenToWebSocket() {
    _webSocketService.notificationsStream.listen((message) {
      print("Notifica ricevuta nel NotificationState: $message");

      // Parsing manuale della stringa
      final topicMatch = RegExp(r'Topic:\s*(.*?),').firstMatch(message);
      final messageMatch = RegExp(r'Message:\s*(.*)').firstMatch(message);

      if (topicMatch != null && messageMatch != null) {
        // Aggiungi la notifica alla lista
        addNotification(topicMatch.group(1) ?? 'Sconosciuto', messageMatch.group(1) ?? 'Messaggio non valido');

        print("Aggiungo notifica: Topic: $topicMatch, Message: $messageMatch");

      } else {
        print('Formato messaggio non valido: $message');
      }

     // updateNotifications(true);
    });
  }
}
