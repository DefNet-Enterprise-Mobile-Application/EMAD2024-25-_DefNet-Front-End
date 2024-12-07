import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class SpeedTestWidget extends StatefulWidget {
  const SpeedTestWidget({Key? key}) : super(key: key);

  @override
  _SpeedTestWidgetState createState() => _SpeedTestWidgetState();
}

class _SpeedTestWidgetState extends State<SpeedTestWidget> with SingleTickerProviderStateMixin {
  
  static const String port = '8000';
  static const String url = 'http://';
  static String? ipRasp = dotenv.env['IP_RASP'];
  static String baseUrl = '$url$ipRasp:$port/speed-test';

  double downloadSpeed = 0;
  double uploadSpeed = 0;
  int ping = 0;
  
  bool isStart = true; // Flag to indicate to start 
  
  bool isLoading = false; // Flag to indicate of loading value 

  bool isTestRunning = false;  // Flag to indicate Running of Speedtest 

  String errorMessage = '';

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
    AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchSpeedTestData() async {

    if (isTestRunning) {
      // Se il test è in corso, fermalo
      setState(() {
        
        isTestRunning = false;
        isLoading = false;

      });
      return;
    }

    setState(() {
      
      isLoading = true;
      errorMessage = '';
      isTestRunning = true; // Imposta il test come in corso

    });

    try {

      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final data = responseData['data'];
          
          setState(() {
            
            downloadSpeed = (data['download_speed'] ?? 0).toDouble();
            
            uploadSpeed = (data['upload_speed'] ?? 0).toDouble();
            
            ping = (data['latency'] ?? 0).toDouble().round(); // Converte a double e arrotonda a int
            
            isLoading = false;

            isStart = false;

          });
        } else {
          setState(() {

            errorMessage = 'Errore nei dati ricevuti dal server';
            isLoading = false;
            isStart = false;
          });
        }
      } else {
        setState(() {

          errorMessage = 'Errore del server: ${response.statusCode} - ${response.body}';
          isLoading = false;
          isStart = false;
        
        });
      }
    } catch (e) {
      setState(() {

        errorMessage = 'Errore durante la richiesta: $e';
        isLoading = false;
        isStart = false;
     
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Stack(
        children: [
          // Background animato con onda
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(_animationController.value),
                child: Container(),
              );
            },
          ),
          
          // Contenuto della schermata
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Box semi-trasparente per il testo
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3), // Colore semi-trasparente
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    
                    isStart ? 'Inizia lo SpeedTest' : errorMessage.isEmpty ? 'Test completato!' : 'Errore!',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),

                if (isLoading) 
                    _buildLoadingAnimation(),
                
                if (!isLoading && errorMessage.isEmpty) 
                    _buildResults(),
                
                if (!isLoading && errorMessage.isNotEmpty) 
                    _buildErrorMessage(),
                
                const SizedBox(height: 20),
                
                _buildTestControlButton(), // 
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade900),
      ),
    );
  }

  Widget _buildResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          InfoCard(
              title: 'Download Speed',
              value: '${downloadSpeed.toStringAsFixed(2)} MB/s'),
          InfoCard(
              title: 'Upload Speed',
              value: '${uploadSpeed.toStringAsFixed(2)} MB/s'),
          InfoCard(title: 'Ping', value: '$ping ms'),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        errorMessage,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTestControlButton() {
    
    return Center(
      child: ElevatedButton(
        onPressed: fetchSpeedTestData,
        child: Text(
          isStart ? 'Inizia il Test' : 'Riavvia Test',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),

        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          backgroundColor: Colors.blue.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoCard({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blue, // Blu
          Colors.lightBlueAccent, // Celeste
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    const waveHeight = 100.0; // Altezza dell'onda
    final waveLength = size.width; // L'onda si estende per tutta la larghezza

    // Traslazione dell'onda di 10 cm (circa 378px)
    const translateY = 60.0;

    // Partenza in alto a sinistra, spostata di 378 px in basso
    path.moveTo(0, waveHeight + translateY);

    // Disegniamo l'onda come mezza sinusoide
    for (double x = 0; x <= size.width; x++) {
      // La funzione sinusoide per creare l'onda (da sin(0) a sin(pi) che dà una curva a "S")
      final y = sin((x / waveLength * pi) + (animationValue * 2 * pi)) * waveHeight;
      path.lineTo(x, waveHeight + y + translateY);
    }

    // Abbassiamo l'onda alla fine per creare la parte inferiore della "S"
    path.lineTo(size.width, size.height - 10+ translateY); // Abbassiamo la fine
    path.lineTo(0, size.height - 10 + translateY); // Abbassiamo anche l'inizio
    path.close();

    // Disegniamo il path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Ricalcola ad ogni frame
  }
}
