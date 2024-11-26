import 'package:flutter/material.dart';
import 'package:flutter_speedtest/flutter_speedtest.dart';

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

  double _progressDownload = 0;
  double _progressUpload = 0;

  int _ping = 0;
  int _jitter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Download: $_progressDownload'),
        Text('Upload: $_progressUpload'),
        Text('Ping: $_ping'),
        Text('Jitter: $_jitter'),
        ElevatedButton(
          onPressed: () {
            _speedtest.getDataspeedtest(
              downloadOnProgress: ((percent, transferRate) {
                setState(() {
                  _progressDownload = transferRate;
                });
              }),
              uploadOnProgress: ((percent, transferRate) {
                setState(() {
                  _progressUpload = transferRate;
                });
              }),
              progressResponse: ((responseTime, jitter) {
                setState(() {
                  _ping = responseTime;
                  _jitter = jitter;
                });
              }),
              onError: ((errorMessage) {
                // Gestisci errori qui, se necessario
              }),
              onDone: () => debugPrint('done'),
            );
          },
          child: const Text('Test Download'),
        ),
      ],
    );
  }
}