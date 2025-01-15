import 'package:defnet_front_end/screens/Home/home_screen.dart';
import 'package:defnet_front_end/screens/splash_screen.dart';
import 'package:defnet_front_end/shared/services/logout_service.dart';
import 'package:defnet_front_end/shared/services/secure_storage_service.dart';
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
                _notificationState.markNotificationsAsRead();
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

  Widget _buildNotificationCard(Map<String, String> notification) {
    // Determina il tipo di notifica, ad esempio "error", "warning", "info"
    String topic = notification['Topic'] ?? '';
    IconData notificationIcon;
    Color iconColor;

    // Imposta l'icona e il colore in base al tipo di notifica
    if (topic.toLowerCase() == 'warning') {
      notificationIcon =
          FontAwesomeIcons.exclamationTriangle; // Icona di avviso
      iconColor = Colors.amber.shade700; // Colore per le notifiche di avviso
    } else if (topic.toLowerCase() == 'error') {
      notificationIcon = FontAwesomeIcons.timesCircle; // Icona di errore
      iconColor = Colors.red.shade700; // Colore per le notifiche di errore
    } else {
      notificationIcon = FontAwesomeIcons.bell; // Icona di notifica generica
      iconColor = Colors.blue.shade700; // Colore standard
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    notification['Topic'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['Message'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
