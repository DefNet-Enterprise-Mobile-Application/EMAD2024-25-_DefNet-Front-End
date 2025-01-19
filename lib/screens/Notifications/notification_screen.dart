import 'package:defnet_front_end/screens/Home/home_screen.dart';
import 'package:defnet_front_end/screens/splash_screen.dart';
import 'package:defnet_front_end/shared/services/logout_service.dart';
import 'package:defnet_front_end/shared/services/secure_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'notification_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  final int userId;

  const NotificationsScreen({super.key, required this.userId});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  final LogoutService _logoutService = LogoutService();
  final SecureStorageService _storageService = SecureStorageService.instance;

  late NotificationState _notificationState;

  @override
  void initState(){
    super.initState();

    // Usa Provider per ottenere l'istanza di NotificationState

    _notificationState = Provider.of<NotificationState>(context, listen: false);

      _markUnreadNotificationsAsRead(); //Marca automaticamente come lette le notifiche non lette
  }

  void _markUnreadNotificationsAsRead() async {
    // Ottieni tutte le notifiche con `letto == false`
    final unreadNotifications = _notificationState.notifications
        .where((notification) => notification['letto'] == false)
        .toList();
    if (unreadNotifications.isNotEmpty) {
      for (var notification in unreadNotifications) {
        try {
          // Chiama il metodo per aggiornare lo stato della notifica nel backend
           _notificationState.markNotificationAsRead(notification['id']);
        } catch (e) {
          if (kDebugMode) {
            print(
              "Errore durante l'aggiornamento della notifica con id ${notification['id']}: $e");
          }
        }
      }
      if (kDebugMode) {
        print("Tutte le notifiche non lette sono state marcate come lette.");
      }
    } else {
      if (kDebugMode) {
        print("Nessuna notifica non letta trovata.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _notificationState = Provider.of<NotificationState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifiche',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              icon: const Icon(
                  FontAwesomeIcons.house), // Usa l'icona di FontAwesome
              onPressed: () {
                //_notificationState.markNotificationsAsRead();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }),
          IconButton(
            icon: const Icon(
                FontAwesomeIcons.signOutAlt), // Icona di logout stilizzata
            onPressed: () async {
            bool response =  await _logoutService.logout(_storageService);

            if(response){
              _notificationState
                  .disposeService(widget.userId); // Chiudi WebSocket
              _notificationState.clearNotifications(); // Resetta notifiche

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                );
            }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo e titolo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/logodiviso.png',
                    width: 100,
                    height: 60,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'DefNet',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Lista delle notifiche
            _notificationState.notifications.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Nessuna notifica disponibile",
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _notificationState.notifications.length,
                      itemBuilder: (context, index) {
                        final notification =
                            _notificationState.notifications[index];
                        return _buildNotificationCard(notification);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    // Determina il tipo di notifica, ad esempio "error", "warning", "info"
    String tipo = notification['Tipo'] ?? 'Sconosciuto';
    String descrizione = notification['Descrizione'] ?? 'Descrizione non disponibile';
    String timestamp = notification['Timestamp'] ?? DateTime.now().toIso8601String();
    bool letto = notification['letto'] ?? false;

    IconData notificationIcon;
    Color iconColor;
    Color containerColor;

    // Imposta l'icona e il colore in base al tipo di notifica
    if (tipo.toLowerCase() == 'system') {
      notificationIcon =
          FontAwesomeIcons.bell; // Icona di avviso
      iconColor = Colors.green; // Colore per le notifiche di avviso
      containerColor = Colors.green.shade100; // Colore verde per il contenitore
    } else if (tipo.toLowerCase() == 'block') {
      notificationIcon = FontAwesomeIcons.timesCircle; // Icona di errore
      iconColor = Colors.red.shade700; // Colore per le notifiche di errore
      containerColor = Colors.red.shade100; // Colore rosso per il contenitore
    } else {
      /// Info System
      notificationIcon = FontAwesomeIcons.timesCircle; // Icona di notifica generica
      iconColor = Colors.orange;
      containerColor = Colors.blue.shade100; // Colore blu per il contenitore
    }

    return GestureDetector(
       /* onTap: () {
      // Marcare la notifica come letta quando l'utente la seleziona
      int notificationId = notification['id'];
      _notificationState.markNotificationAsRead(notificationId);
      },*/
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: containerColor, // Applica il colore al contenitore
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Icona all'interno di un container
              Container(
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2), // Colore di sfondo iconico
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  notificationIcon,
                  color: iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              // Dettagli notifica
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${tipo.toUpperCase()} Message !",
                      //notification['Topic'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descrizione,
                      //notification['Message'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
