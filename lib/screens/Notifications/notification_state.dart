import 'package:defnet_front_end/shared/services/websocket_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NotificationState extends ChangeNotifier {
  final List<Map<String, String>> _notifications = [];

  final WebSocketService webSocketService = GetIt.I<WebSocketService>();

  bool _hasNewNotification = false;

  List<Map<String, String>> get notifications =>
      List.unmodifiable(_notifications);

  bool get hasNewNotification => _hasNewNotification;

  Future<void> initialize(int userId) async {
    // Inzializzo il Notification State
    if (kDebugMode) {
      print("Inizio la connessione al WebSocket");
    }
    await webSocketService.connect(
        userId!); // Connetti al WebSocket dopo aver caricato il nome utente
    if (kDebugMode) {
      print("Ho inizilaizzato il NotificationState");
    }
    // Ascolta i messaggi in arrivo dal WebSocket
    webSocketService.notificationsStream.listen((message) {
      if (kDebugMode) {
        print("Aggiungi la Notifica ! $message");
      }
      addNotification(message, message);
    });
  }

  void addNotification(String topic, String message) {
    _notifications.insert(0, {
      'Topic': topic,
      'Message': message,
      'Timestamp': DateTime.now().toIso8601String(),
    });
    _hasNewNotification = true; // Nuova notifica
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _hasNewNotification = false;
    notifyListeners();
  }

  void markNotificationsAsRead() {
    _hasNewNotification = false;
    notifyListeners();
  }

  void disposeService(int userId) async {
    _hasNewNotification = false;
    webSocketService.dispose();
    await webSocketService.disconnect(userId);
  }
}
