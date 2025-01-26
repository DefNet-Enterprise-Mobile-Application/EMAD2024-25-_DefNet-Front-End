import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reporting',
          style: TextStyle(
            fontWeight: FontWeight.bold,  // Impostiamo il grassetto
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titolo della schermata
            const Text(
              'Dati di Report',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Esempio di grafico o statistica
            _buildGraphSection(),

            const SizedBox(height: 20),

            // Altre informazioni o dettagli sul report
            _buildReportInfo(),
          ],
        ),
      ),
    );
  }

  // Sezione del grafico (qui si può aggiungere un grafico o una statistica)
  Widget _buildGraphSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Performance Grafico',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Icon(
            FontAwesomeIcons.chartLine, // Un'icona di grafico
            size: 50,
            color: Colors.blue.shade900,
          ),
          const SizedBox(height: 10),
          const Text(
            'Visualizza i tuoi dati statistici',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Sezione con altre informazioni (ad esempio statistiche, numeri, tabelle, ecc.)
  Widget _buildReportInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistiche Generali',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.users,
                size: 20,
                color: Colors.green,
              ),
              const SizedBox(width: 10),
              const Text(
                'Utenti attivi: 120',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.wifi,
                size: 20,
                color: Colors.green,
              ),
              const SizedBox(width: 10),
              const Text(
                'Connessioni stabili: 95%',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
