import 'dart:convert';
import 'package:defnet_front_end/shared/services/websocket_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../shared/services/configuration_service.dart';
import '../../shared/services/secure_storage_service.dart';

class NotificationState extends ChangeNotifier {

  final List<Map<String, dynamic>> _notifications = [];

  final ConfigurationService _configurationService = ConfigurationService();

  WebSocketService webSocketService = WebSocketService();

  bool _hasNewNotification = false;

  List<Map<String, dynamic>> get notifications {
    return List.unmodifiable(_notifications);
  }

  bool get hasNewNotification => _hasNewNotification;

  Future<void> initialize(int userId) async {
    // Inzializzo il Notification State
    if (kDebugMode) {
      print("Inizio la connessione al WebSocket");
    }
    await webSocketService.connect(userId); // Connetti al WebSocket dopo aver caricato il nome utente
    if (kDebugMode) {
      print("Ho inizilaizzato il NotificationState");
    }
    // Ascolta i messaggi in arrivo dal WebSocket
    webSocketService.notificationsStream.listen((message) {
      if (kDebugMode) {
        print("Aggiungi la Notifica ! $message");
      }
      // Gestisci il messaggio JSON
      String tipo = message['tipo'] ?? 'Sconosciuto';
      String descrizione = message['descrizione'] ?? 'Descrizione non disponibile';
      String timestamp = message['timestamp'] ?? DateTime.now().toIso8601String();
      bool letto = message['stato'] ?? false;
      int id = message['id'];

      addNotification(id, tipo, descrizione, timestamp, letto);
    });
  }

  void addNotification(int id, String tipo, String descrizione, String timestamp, bool letto) {
    _notifications.insert(0, {
      'id':id,
      'Tipo': tipo,
      'Descrizione': descrizione,
      'Timestamp': timestamp, //da controllare
      'letto': letto,  // Stato iniziale: non letta
    });
    _hasNewNotification = true; // Nuova notifica
    print("Lista notifiche dopo l'aggiunta: $_notifications");
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _hasNewNotification = false;
    notifyListeners();
  }

  // Funzione per marcare una notifica come letta
  void markNotificationAsRead(int notificationId) async {
    // Trova la notifica corrispondente e aggiorna lo stato 'letto' a true
    var notification = _notifications.firstWhere(
          (n) => n['id'] == notificationId,
      orElse: () => {},
    );

    if (notification != null) {
      notification['letto'] = true; // Marca come letta

      // Aggiorna lo stato della UI
      // Posticipa la chiamata a notifyListeners per evitare il conflitto durante il build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _hasNewNotification = false;
        notifyListeners();
      });

      // Ora invia la richiesta al backend per aggiornare lo stato della notifica
      await _updateNotificationStatusInBackend(notificationId, true);
    }
  }

  // Funzione per inviare la modifica al backend
  Future<void> _updateNotificationStatusInBackend(int notificationId, bool status) async {
    String? url = _configurationService.getBasicUrlHttp();

    String? ip = _configurationService.getIpRaspberryPi();

    String? port = _configurationService.getPortMicroservice();

    String baseUrl = "$url$ip:$port/notification_alert";

    // Recupera il token dall'archiviazione sicura
    final token = await SecureStorageService().getToken();

    try {
      final response = await http.put(
      Uri.parse('$baseUrl/$notificationId/update-notification'),
        body: json.encode({'stato': status}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Aggiungi il token se necessario
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Notifica aggiornata con successo!');
        }
      } else {
        if (kDebugMode) {
          print('Errore nell\'aggiornamento della notifica');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Errore nella richiesta API: $e');
      }
    }
  }

  void disposeService(int userId) async {
    _hasNewNotification = false;
    webSocketService.dispose();
  }
}
