import 'dart:convert';

import 'package:defnet_front_end/screens/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:defnet_front_end/shared/services/websocket_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/io.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final WebSocketService _webSocketService = WebSocketService();
  List<Map<String,String>> notifications = [];

  @override
  void initState() {
    super.initState();
    _webSocketService.connect();

    // Ascolta i messaggi dal WebSocket
    _webSocketService.messages.listen((message) {
      try {
        final decodedMessage = jsonDecode(message); // Tenta di decodificare il messaggio

          // Controlla se il messaggio è una stringa o un JSON strutturato
          if (decodedMessage is Map<String, dynamic> &&
              decodedMessage.containsKey('Topic') &&
              decodedMessage.containsKey('Message')) {

            setState(() {
              notifications.add({
                'Topic': decodedMessage['Topic'],
                'Message': decodedMessage['Message'],
              }); // Usa una chiave 'message' del JSON
            });
          }
      } catch (e) {
        // Parsing manuale della stringa
        final topicMatch = RegExp(r'Topic:\s*(.*?),').firstMatch(message);
        final messageMatch = RegExp(r'Message:\s*(.*)').firstMatch(message);

        if (topicMatch != null && messageMatch != null) {
          setState(() {
            notifications.add({
              'Topic': topicMatch.group(1) ?? 'Sconosciuto',
              'Message': messageMatch.group(1) ?? 'Messaggio non valido',
            });
          });
        } else {
          print('Formato messaggio non valido: $message');
        }
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



  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Notifiche',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10), // Spazio tra il titolo e l'icona
                IconButton(
                  icon: Container(
                      child: Image.asset(
                        'lib/assets/icons/iconaCasa.png',
                        width: screenWidth * 0.15,
                        height: screenWidth * 0.15,
                        //color: Colors.white,
                      )
                  ),
                  onPressed: () {
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
                //subtitle: Text(
                  //'Topic: $topic',
                  //style: TextStyle(
                    //fontSize: 12,
                    //color: Colors.grey[700],
                  //),
                //),
              ),
            );
          },
      ),
    );
  }
}

