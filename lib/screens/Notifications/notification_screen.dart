import 'dart:convert';
import 'package:defnet_front_end/screens/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:defnet_front_end/shared/services/websocket_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import '../../shared/services/NotificationState.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  final WebSocketService _webSocketService = GetIt.I<WebSocketService>();

  //List<Map<String,String>> notifications = [];

  @override
  void initState() {
    super.initState();

    // Ascolta i messaggi dal WebSocket
    _webSocketService.notificationsStream.listen((message) {
      print("Messaggio ricevuto: $message");  // Log per messaggio ricevuto

        // Parsing manuale della stringa
        final topicMatch = RegExp(r'Topic:\s*(.*?),').firstMatch(message);
        final messageMatch = RegExp(r'Message:\s*(.*)').firstMatch(message);

        if (topicMatch != null && messageMatch != null) {
          _addNotification(topicMatch.group(1) ?? 'Sconosciuto', messageMatch.group(1) ?? 'Messaggio non valido');
        } else {
          print('Formato messaggio non valido: $message');
        }
    },
      onError: (error) {
        print('Errore WebSocket: $error');
      },
      onDone: () {
        print('Connessione WebSocket chiusa');
      },
    );
  }

  // Aggiungi la notifica alla lista
  void _addNotification(String topic, String message) {
    final notificationState = Provider.of<NotificationState>(context, listen: false);

    // Aggiungi la nuova notifica allo stato
    notificationState.addNotification(topic, message);

    print("Notifiche attuali: ${notificationState.notifications}"); // Aggiungi un print per vedere la lista
  }

  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<NotificationState>(context).notifications;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Row(
              //children: [
                Text(
                  'Notifiche',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                ),
                Spacer(),
                //SizedBox(width: 10), // Spazio tra il titolo e l'icona
                IconButton(
                  icon: Image.asset(
                        'lib/assets/icons/iconaCasa.png',
                        width: screenWidth * 0.15,
                        height: screenWidth * 0.15,
                        //color: Colors.white,
                  ),
                  onPressed: () {
                    // Torna alla pagina precedente
                    //Navigator.pop(context);  // Torna alla pagina precedente

                    // Logica per le notifiche
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ],
            ),
        ),
      body: notifications.isEmpty
        ? Center(child: Text("Nessuna notifica"))
        : ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final topic = notification['Topic'] ?? '';
            final message = notification['Message'] ?? '';

            // Controlla se il topic è "user/login/success"
            final isSystemMessage = topic == 'user/login/success';

            return Card(
              color: isSystemMessage
                  ? Colors.green[100] // Messaggio di sistema: colore verde
                  : Colors.white, // Altri messaggi: colore normale
              child: ListTile(
                title: Text(
                  message,
                  style: TextStyle(
                    color: isSystemMessage ? Colors.green[900] : Colors.black,
                  ),
                ),
              ),
            );
          },
      ),
    );
  }
}

