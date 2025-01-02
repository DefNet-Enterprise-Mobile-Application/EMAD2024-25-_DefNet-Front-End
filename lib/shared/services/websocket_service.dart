import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebSocketService {
  late WebSocketChannel channel;

  static  String? port = dotenv.env['PORT_MICROSERVICE'];
  static String? IP_RASP = dotenv.env['IP_RASP'];
  static String baseUrl = 'ws://${IP_RASP!}:$port';

  // Inizializza la connessione WebSocket
  void connect() {
    try {
      channel =
          WebSocketChannel.connect(Uri.parse('$baseUrl/ws/notifications'));
      print('Connesso al WebSocket');
      print("Connessione WebSocket stabilita su $baseUrl");
    }catch(e){
      print('Errore durante la connessione al WebSocket: $e');
    }
  }

  // Ascolta i messaggi dal WebSocket
  Stream<dynamic> get messages {
    return channel.stream.map((message) {
      print('Messaggio ricevuto: $message'); // Debug
      return message;
    });
  }

  // Chiudi la connessione
  void disconnect() {
    channel.sink.close();
    print('Connessione WebSocket chiusa');
  }
}
