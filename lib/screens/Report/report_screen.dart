import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'; // Per formattare la data
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
  bool _isLoading = false;
  List<dynamic> notifications = [];
  Map<String, int> reportData = {'system': 0, 'alert': 0, 'block': 0};

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoading = true; // Inizia il caricamento
    });

    // Generazione della data nel formato richiesto (YYYY-MM-DD)
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Se è settimanale, calcoliamo la data di 7 giorni fa
    String sevenDaysAgo = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 7)));

    String backendUrl = isDailyReport
        ? 'http://10.71.71.1:8000/report/daily?date=$today'
        : 'http://10.71.71.1:8000/report/weekly?start_date=$sevenDaysAgo&end_date=$today';

    try {
      final response = await http.get(Uri.parse(backendUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['notifiche'] is List) {
          List<dynamic> notifiche = data['notifiche'];

          setState(() {
            notifications = notifiche;

            // Estrazione dei conteggi in modo sicuro
            reportData = {
              'system': notifiche.firstWhere(
                (item) => item['tipo'] == 'system',
                orElse: () => {'count': 0},
              )['count'],
              'alert': notifiche.firstWhere(
                (item) => item['tipo'] == 'alert',
                orElse: () => {'count': 0},
              )['count'],
              'block': notifiche.firstWhere(
                (item) => item['tipo'] == 'block',
                orElse: () => {'count': 0},
              )['count'],
            };
          });
        } else {
          print("Formato JSON non valido");
        }
      } else {
        print(
            "Errore nella richiesta: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Errore di connessione: $e");
    }

    setState(() {
      _isLoading = false; // Termina il caricamento
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reporting",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.house, // Usa l'icona di FontAwesome
            color: Colors.white,
          ),
          onPressed: () {
            // Torna alla pagina precedente senza creare una nuova istanza
            Navigator.pop(context);
          },
        ),
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
                    onPressed: () async {
                      setState(() {
                        isDailyReport = !isDailyReport;
                      });
                      await _fetchReports();
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

              // Mostra il caricamento durante la richiesta dei dati
              _isLoading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.blue,
                            strokeWidth: 5.0,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Caricamento dei report...",
                            style: TextStyle(
                                fontSize: 18, color: Colors.blue.shade700),
                          ),
                        ],
                      ),
                    )
                  : _buildGraphSection(), // Mostra il grafico solo se i dati sono caricati
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
                    value: reportData['system']!.toDouble(),
                    color: Colors.greenAccent,
                    radius: 60,
                    titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  PieChartSectionData(
                    value: reportData['alert']!.toDouble(),
                    color: Colors.orangeAccent,
                    radius: 60,
                    titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent),
                  ),
                  PieChartSectionData(
                    value: reportData['block']!.toDouble(),
                    color: Colors.redAccent,
                    radius: 60,
                    titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent),
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
        _buildLegendItem(
            Colors.blueAccent, 'system', reportData['system']!.toString()),
        _buildLegendItem(
            Colors.redAccent, 'alert', reportData['alert']!.toString()),
        _buildLegendItem(
            Colors.orangeAccent, 'block', reportData['block']!.toString()),
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
