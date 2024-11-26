import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_speedtest/flutter_speedtest.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SpeedTestWidget extends StatefulWidget {
  const SpeedTestWidget({Key? key}) : super(key: key);

  @override
  _SpeedTestWidgetState createState() => _SpeedTestWidgetState();
}

class _SpeedTestWidgetState extends State<SpeedTestWidget> {
  final _speedtest = FlutterSpeedtest(
    baseUrl: 'https://speedtest.globalxtreme.net:8080',
    pathDownload: '/download',
    pathUpload: '/upload',
    pathResponseTime: '/ping',
  );

  double currentSpeed = 0; // Velocità corrente in MB/s
  double downloadSpeed = 0;
  double uploadSpeed = 0;
  int ping = 0;
  int jitter = 0;
  bool isDownload = true;

  Timer? uploadTimeout;

  @override
  void initState() {
    super.initState();
    // Avvia automaticamente il test quando il widget viene creato
    startSpeedTest();
  }

  @override
  void dispose() {
    uploadTimeout?.cancel();
    super.dispose();
  }

  void startSpeedTest() {
    List<double> uploadSpeeds = []; // Per calcolare la media in caso di timeout

    _speedtest.getDataspeedtest(
      downloadOnProgress: (percent, transferRate) {
        setState(() {
          currentSpeed = transferRate / 8; // Converti Mbps in MB/s
          downloadSpeed = currentSpeed;
        });
      },
      uploadOnProgress: (percent, transferRate) {
        setState(() {
          currentSpeed = transferRate / 8; // Converti Mbps in MB/s
          uploadSpeeds.add(currentSpeed);
        });
      },
      progressResponse: (responseTime, jitterValue) {
        setState(() {
          ping = responseTime;
          jitter = jitterValue;
        });
      },
      onError: (errorMessage) {
        debugPrint('Errore: $errorMessage');
      },
      onDone: () async {
        // Passaggio all'upload dopo il download
        setState(() {
          currentSpeed = 0; // Resetta il contatore
          isDownload = false; // Passa a "upload"
        });

        await Future.delayed(const Duration(seconds: 1));

        // Timeout per l'upload
        uploadTimeout = Timer(const Duration(seconds: 20), () {
          setState(() {
            uploadSpeed = uploadSpeeds.isNotEmpty
                ? uploadSpeeds.reduce((a, b) => a + b) / uploadSpeeds.length
                : 0; // Media delle velocità o 0
            currentSpeed = 0; // Resetta il contatore
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isDownload ? 'Download Test' : 'Upload Test',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // Centralizzare il contatore
        Center(
          child: SpeedometerGauge(currentSpeed: currentSpeed),
        ),
        const SizedBox(height: 20),
        // Bottone centrato e grande
        Center(
          child: ElevatedButton(
            onPressed: startSpeedTest,
            child: const Text(
              'Inizia SpeedTest',
              style: TextStyle(fontSize: 24), // Dimensione del testo aumentata
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40), backgroundColor: Colors.teal, // Aumenta le dimensioni del bottone
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rende il bottone più arrotondato
              ), // Colore di sfondo
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Card per visualizzare i risultati
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            children: [
              InfoCard(title: 'Download Speed', value: '${downloadSpeed.toStringAsFixed(2)} MB/s'),
              InfoCard(title: 'Upload Speed', value: '${uploadSpeed.toStringAsFixed(2)} MB/s'),
              InfoCard(title: 'Ping', value: '$ping ms'),
              InfoCard(title: 'Jitter', value: '$jitter ms'),
            ],
          ),
        ),
      ],
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
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpeedometerGauge extends StatelessWidget {
  final double currentSpeed;

  const SpeedometerGauge({Key? key, required this.currentSpeed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          startAngle: 180,
          endAngle: 0,
          showTicks: false,
          showLabels: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.2,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: currentSpeed.clamp(0, 100),
              color: Colors.teal,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
              enableAnimation: true,
              animationType: AnimationType.ease,
            ),
            NeedlePointer(
              value: currentSpeed.clamp(0, 100),
              needleColor: Colors.orange, // Nuovo colore per la lancetta
              needleLength: 0.8,
              lengthUnit: GaugeSizeUnit.factor,
              needleEndWidth: 6, // Larghezza maggiore della lancetta
              enableAnimation: true,
              animationType: AnimationType.easeOutBack,
              animationDuration: 500,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                '${currentSpeed.toStringAsFixed(1)} MB/s',
                style: const TextStyle(
                  fontSize: 22, // Aumentato per rendere il testo più visibile
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              positionFactor: 0.15, // Maggiore distanza dalla lancetta
              angle: 90,
            ),
          ],
        ),
      ],
    );
  }
}
