import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista di notifiche con priorità 'high', 'medium', 'low'
    List<Map<String, String>> notifications = [
      {'message': 'Connection problem', 'priority': 'high'},
      {'message': 'Update available', 'priority': 'medium'},
      {'message': 'General notice', 'priority': 'low'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.indigo,
        elevation: 4,
      ),
      body: Stack(
        children: [
          // Fondo con onde personalizzate
          Positioned.fill(
            child: CustomPaint(
              painter: WavePainter(),
              child: Container(),
            ),
          ),
          // Corpo della pagina con notizie
          Container(
            color: Colors.white, // Sfondo bianco
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  var notification = notifications[index];
                  Color priorityColor;
                  String priorityText;
                  IconData priorityIcon;

                  // Determina il colore e il testo in base alla priorità
                  switch (notification['priority']) {
                    case 'high':
                      priorityColor = Colors.red;
                      priorityText = 'High';
                      priorityIcon = Icons.dangerous;
                      break;
                    case 'medium':
                      priorityColor = Colors.yellow[700]!;
                      priorityText = 'Medium';
                      priorityIcon = Icons.priority_high;
                      break;
                    case 'low':
                      priorityColor = Colors.green;
                      priorityText = 'Low';
                      priorityIcon = Icons.check_circle_outline;
                      break;
                    default:
                      priorityColor = Colors.black;
                      priorityText = 'Non specificato';
                      priorityIcon = Icons.info_outline;
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Bordi più arrotondati
                    ),
                    elevation: 6, // Ombra per maggiore profondità
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      leading: CircleAvatar(
                        backgroundColor: priorityColor,
                        radius: 25,
                        child: Icon(
                          priorityIcon,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        notification['message'] ?? 'No message',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'Priority: $priorityText',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String value) {
                          // Azioni da eseguire in base alla selezione
                          print('Selected: $value');
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'Mark as Read',
                              child: Row(
                                children: const [
                                  Icon(Icons.check_circle, size: 18),
                                  SizedBox(width: 8),
                                  Text('Mark as Read'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Delete',
                              child: Row(
                                children: const [
                                  Icon(Icons.delete, size: 18),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Share',
                              child: Row(
                                children: const [
                                  Icon(Icons.share, size: 18),
                                  SizedBox(width: 8),
                                  Text('Share'),
                                ],
                              ),
                            ),
                          ];
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.grey[600],
                          size: 22,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter per creare l'effetto onde
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.indigo.shade100.withOpacity(0.4) // Colore delle onde
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.lineTo(0, size.height - 40); // Punto iniziale della onda

    // Creiamo un effetto onde tramite curve
    path.quadraticBezierTo(
        size.width * 0.25, size.height - 100, size.width * 0.5, size.height - 50);
    path.quadraticBezierTo(
        size.width * 0.75, size.height, size.width, size.height - 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
