import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  bool isTesting = false;
  final speedTest = FlutterInternetSpeedTest();
  double internetSpeed = 0.0;
  Future<void> _chekinternetspeed() async {
    setState(() {
      isTesting = true;
    });
    await speedTest.startTesting(
      onCompleted: (TestResult download, TestResult upload) {
        print("Test Completed:" + download.transferRate.toString());
        setState(() {
          internetSpeed = download.transferRate;
        });
      },
      onProgress: (double percent, TestResult data) {
        print("Test in progress:" + data.transferRate.toString());
        setState(() {
          internetSpeed = data.transferRate;
        });
      },
    );
    setState(() {
      isTesting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SfRadialGauge(axes: <RadialAxis>[
              RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
                GaugeRange(startValue: 0, endValue: 50, color: Colors.green),
                GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
                GaugeRange(startValue: 100, endValue: 150, color: Colors.red)
              ], pointers: <GaugePointer>[
                NeedlePointer(value: internetSpeed)
              ], annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(internetSpeed.toString() + "Mb",
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    angle: 90,
                    positionFactor: 0.5)
              ])
            ]),
            ElevatedButton(
                onPressed: isTesting ? null : _chekinternetspeed,
                child: Text(isTesting ? "Testing..." : "check speed"))
          ],
        ),
      ),
    );
  }
}