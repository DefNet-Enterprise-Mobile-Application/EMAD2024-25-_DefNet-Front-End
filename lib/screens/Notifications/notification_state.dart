import 'dart:convert';
import 'package:defnet_front_end/shared/services/settings_service.dart';
import 'package:defnet_front_end/shared/services/websocket_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../shared/services/configuration_service.dart';
import '../../shared/services/secure_storage_service.dart';

class NotificationState extends ChangeNotifier {

  final SettingsService settingsService = SettingsService();
  /// Lista delle notifiche
  final List<Map<String, dynamic>> _notifications = [];


  /// Services of Router
  /// E' possibile gestire lo stato di questi servizi mediante questi oggetti
  /// Questi verranno modificati a seconda del cambiamento di stato a tutti i partecipanti che sono all'interno
  /// della nostra applicazione mediante un messaggio di broadcasting
  final List<Map<String, dynamic>> _services = [
    {
      'name': 'AD Block',
      'enabled': true,
      'modifiable': false,
      'description': 'Blocks annoying ads on websites, improving the browsing experience and security.'
    },
    {
      'name': 'IDS and IPS',
      'enabled': false,
      'modifiable': true,
      'description': 'Intrusion Detection and Prevention System (IDS/IPS) detects and prevents potential security threats.'
    },
    {
      'name': 'Parental Control',
      'enabled': false,
      'modifiable': true,
      'description': 'Allows parents to monitor and control children\'s internet usage for safety.'
    },
    {
      'name': 'VPN Protection',
      'enabled': false,
      'modifiable': false,
      'comingSoon': true,
      'description': 'VPN will be available soon. It will secure your internet connection by encrypting your data.'
    },
  ];

  List<Map<String, dynamic>> get services => List.unmodifiable(_services);

  final ConfigurationService _configurationService = ConfigurationService();

  WebSocketService webSocketService = WebSocketService();

  bool _hasNewNotification = false;

  List<Map<String, dynamic>> get notifications { return List.unmodifiable(_notifications); }

  /// Funzione per aggiornare lo stato di un servizio
  void updateServiceStatus(String serviceName, bool newStatus) {
    final service = _services.firstWhere(
          (service) => service['name'] == serviceName,
    );

    service['enabled'] = newStatus;
    notifyListeners();  // Notifica la UI per aggiornare
  }


  Future<void> _fetchStatusService() async {
    final serviceState = await settingsService.fetchServicesStatus();

    for (var entry in serviceState.entries) {
      final serviceName = entry.key; // Nome del servizio
      final newServiceStatus = entry.value; // Stato del servizio (true/false)
      // Aggiorna lo stato del servizio
      updateServiceStatus(serviceName, newServiceStatus);
    }
  }

  bool get hasNewNotification => _hasNewNotification;

  Future<void> initialize(int userId) async {
    // Inzializzo il Notification State
    if (kDebugMode) {
      print("Inizio la connessione al WebSocket");
    }
    await webSocketService.connect(userId); // Connetti al WebSocket dopo aver caricato il nome utente

    //await _fetchStatusService();
    /// Ascolta i messaggi in arrivo dal WebSocket
    webSocketService.notificationsStream.listen((message) {

      if (kDebugMode) {
        print("Aggiungi la Notifica ! $message");
      }
      // Gestisci il messaggio JSON
      String tipo = message['tipo'] ?? 'Sconosciuto';
      String descrizione = message['descrizione'] ?? 'Descrizione non disponibile';
      String timestamp = message['timestamp'] ?? DateTime.now().toIso8601String();
      bool letto = message['stato'] ?? false;
      int user_Id = message['user_id']; // Assumi che l'ID utente sia incluso nel messaggio
      int id = message['id'];

      /// Modifica lo Stato dei Servizi
      if(tipo == "serviceStatusChange"){
        final serviceName = message['serviceName'];
        final newStatus = message['newStatus'];
        updateServiceStatus(serviceName, newStatus);
      }

      // Verifica che il messaggio appartenga all'utente corretto
      if (user_Id == userId) { // Confronta con l'ID utente locale
        /// Aggiunge la notifica alla lista delle Notifiche
        addNotification(id, tipo, descrizione, timestamp, letto, user_Id);
      } else {
        if (kDebugMode) {
          print("Notifica scartata: non corrisponde all'utente corrente");
        }
      }


    });
  }

  void addNotification(int id, String tipo, String descrizione, String timestamp, bool letto, int userId) {
    _notifications.insert(0, {
      'id':id,
      'user_id': userId, // Salva anche l'ID utente
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

  /// Funzione per marcare una notifica come letta
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

  /// Funzione per inviare la modifica al backend
  /// Aggiorna lo stato della notifica da "non letta" a "letta"
  Future<void> _updateNotificationStatusInBackend(int notificationId, bool status) async {

    String? url = _configurationService.getBasicUrlHttp();

    String? ip = _configurationService.getIpRaspberryPi();

    String? port = _configurationService.getPortMicroservice();

    String baseUrl = "$url$ip:$port/notification_alert";

    /// Recupera il token dall'archiviazione sicura
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

  /// Gestisce lo stato delle notifiche
  /// Viene chiuso il websocket con l'ID dell'Utente
  void disposeService(int userId) async {
    _hasNewNotification = false;
    webSocketService.dispose();
  }


}
