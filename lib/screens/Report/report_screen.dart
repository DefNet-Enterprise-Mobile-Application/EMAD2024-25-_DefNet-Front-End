import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportScreen extends StatefulWidget {
  final int userId;
  const ReportScreen({super.key, required this.userId});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool isDailyReport = true;
  List<dynamic> notifications = [];
  Map<String, int> reportData = {'InfoSystem': 0, 'AlertSystem': 0, 'WarningSystem': 0};

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    String backendUrl = 'http://192.168.1.5:8000/report/daily';

    try {
      final response = await http.get(Uri.parse(backendUrl));

      print("Stato risposta: ${response.statusCode}");
      print("Corpo risposta: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          notifications = data['notifiche'] ?? [];
          reportData = {
            'InfoSystem': data['notifiche'].firstWhere((item) => item['tipo'] == 'InfoSystem')['count'] ?? 0,
            'AlertSystem': data['notifiche'].firstWhere((item) => item['tipo'] == 'AlertSystem')['count'] ?? 0,
            'WarningSystem': data['notifiche'].firstWhere((item) => item['tipo'] == 'WarningSystem')['count'] ?? 0,
          };
        });
      } else {
        print("Errore nella richiesta: ${response.statusCode}");
      }
    } catch (e) {
      print("Errore di connessione: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reporting',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dati di Report',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isDailyReport = !isDailyReport;
                      });
                      _fetchReports();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      isDailyReport ? 'Settimanale' : 'Giornaliero',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildGraphSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraphSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Text(
            isDailyReport ? 'Report Giornaliero' : 'Report Settimanale',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: reportData['InfoSystem']!.toDouble(),
                    color: Colors.blueAccent,
                    radius: 60,
                    titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.blueAccent),
                  ),
                  PieChartSectionData(
                    value: reportData['AlertSystem']!.toDouble(),
                    color: Colors.redAccent,
                    radius: 60,
                    titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                  PieChartSectionData(
                    value: reportData['WarningSystem']!.toDouble(),
                    color: Colors.orangeAccent,
                    radius: 60,
                    titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                  ),
                ],
                centerSpaceRadius: 40,
                sectionsSpace: 4,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        _buildLegendItem(Colors.blueAccent, 'InfoSystem', reportData['InfoSystem']!.toString()),
        _buildLegendItem(Colors.redAccent, 'AlertSystem', reportData['AlertSystem']!.toString()),
        _buildLegendItem(Colors.orangeAccent, 'WarningSystem', reportData['WarningSystem']!.toString()),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String title, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            '$title: $count',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 5,
        ),
      ],
    );
  }
}
