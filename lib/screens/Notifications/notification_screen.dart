import 'package:defnet_front_end/screens/Home/home_screen.dart';
import 'package:defnet_front_end/screens/splash_screen.dart';
import 'package:defnet_front_end/shared/services/logout_service.dart';
import 'package:defnet_front_end/shared/services/secure_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'notification_state.dart';

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
  void initState() {
    super.initState();
    _notificationState = Provider.of<NotificationState>(context, listen: false);
    _markUnreadNotificationsAsRead();
  }

  void _markUnreadNotificationsAsRead() async {
    final unreadNotifications = _notificationState.notifications
        .where((notification) => notification['letto'] == false)
        .toList();
    if (unreadNotifications.isNotEmpty) {
      for (var notification in unreadNotifications) {
        try {
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
          'Notifications',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Moderato
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/backgrounds/notification_header_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(
                FontAwesomeIcons.houseUser,
                size: 30, // Moderato
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.signOutAlt,
              size: 30, // Moderato
            ),
            onPressed: () async {
              bool response = await _logoutService.logout(_storageService);

              if (response) {
                _notificationState.disposeService(widget.userId);
                _notificationState.clearNotifications();

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
            const SizedBox(height: 25), // Moderato
            // Logo e titolo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25), // Moderato
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/logodiviso.png',
                    width: 110,  // Moderato
                    height: 70,  // Moderato
                  ),
                  const SizedBox(width: 12),  // Moderato
                  Text(
                    'DefNet',
                    style: TextStyle(
                      fontSize: 30, // Moderato
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),  // Moderato
            // Lista delle notifiche
            _notificationState.notifications.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(25.0), // Moderato
                child: Text(
                  "Nessuna notifica disponibile",
                  style: TextStyle(
                    fontSize: 20,  // Moderato
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15), // Moderato
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
    String tipo = notification['Tipo'] ?? 'Sconosciuto';
    String descrizione = notification['Descrizione'] ?? 'Descrizione non disponibile';
    String timestamp = notification['Timestamp'] ?? DateTime.now().toIso8601String();
    bool letto = notification['letto'] ?? false;

    IconData notificationIcon;
    Color iconColor;
    Color containerColor;

    if (tipo.toLowerCase() == 'system') {
      notificationIcon = FontAwesomeIcons.bell;
      iconColor = Colors.green;
      containerColor = Colors.green.shade100;
    } else if (tipo.toLowerCase() == 'block') {
      notificationIcon = FontAwesomeIcons.timesCircle;
      iconColor = Colors.red.shade700;
      containerColor = Colors.red.shade100;
    } else {
      notificationIcon = FontAwesomeIcons.timesCircle;
      iconColor = Colors.orange;
      containerColor = Colors.blue.shade100;
    }

    return GestureDetector(
      child: Card(
        elevation: 5,  // Moderato
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 15), // Moderato
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), // Moderato
        color: containerColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),  // Moderato
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),  // Moderato
                child: Icon(
                  notificationIcon,
                  color: iconColor,
                  size: 35,  // Moderato
                ),
              ),
              const SizedBox(width: 18),  // Moderato
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${tipo.toUpperCase()} Message !",
                      style: const TextStyle(
                        fontSize: 18,  // Moderato
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),  // Moderato
                    Text(
                      descrizione,
                      style: const TextStyle(
                        fontSize: 16,  // Moderato
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),  // Moderato
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: 14,  // Moderato
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
