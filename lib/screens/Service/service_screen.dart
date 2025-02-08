import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/services/settings_service.dart';
import '../Notifications/notification_state.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  
  late NotificationState notificationState;
  final SettingsService settingsService = SettingsService();

  /// Mostra il dialog con la descrizione del servizio
  void _showServiceInfo(String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Service Info',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    notificationState = Provider.of<NotificationState>(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          double textScaleFactor = width / 400; // Scala il testo in base alla larghezza
          bool isTablet = width > 600; // Controllo per tablet

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 24.0 : 12),
            child: ListView(
              children: [
                _buildLogoService(width),
                SizedBox(height: height * 0.01),
                Text(
                  'Protect and manage your connection with the following services:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: height * 0.02),
                _buildService(notificationState, width),
              ],
            ),
          );
        },
      ),
    );
  }

  Consumer<NotificationState> _buildService(NotificationState notificationState, double width) {
    return Consumer<NotificationState>(
      builder: (context, notificationState, child) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4,
          color: Colors.grey.shade100,
          child: Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              children: notificationState.services.map((service) {
                bool enabled = service['enabled'] ?? false;
                bool modifiable = service['modifiable'] ?? false;
                bool comingSoon = service['comingSoon'] ?? false;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              service['name'],
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w600,
                                color: comingSoon ? Colors.grey : Colors.blueGrey.shade900,
                              ),
                            ),
                            if (comingSoon)
                              Padding(
                                padding: EdgeInsets.only(left: width * 0.02),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: width * 0.005 ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Coming Soon',
                                    style: TextStyle(fontSize: width * 0.03, fontWeight: FontWeight.bold, color: Colors.orange),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (!comingSoon)
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _showServiceInfo(service['description']),
                              child: Image.asset(
                                'lib/assets/icons/info.png',
                                height: MediaQuery.of(context).size.width * 0.07,
                                width: MediaQuery.of(context).size.width * 0.07,
                              ),
                            ),
                            Switch(
                              value: enabled,
                              onChanged: modifiable
                                  ? (bool value) async {
                                bool success = await settingsService.toggleService(service['name'], value);
                                if (success) {
                                  notificationState.updateServiceStatus(service['name'], value);
                                }
                              }
                                  : null,
                              activeColor: Colors.blueAccent,
                              inactiveThumbColor: modifiable ? Colors.grey : Colors.grey.shade400,
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Row _buildLogoService(double width) {
    return Row(
      children: [
        Image.asset(
          'lib/assets/icons/scudo.png',
          height: width * 0.15,
          width: width * 0.25,
          fit: BoxFit.contain,
        ),
        Text(
          'Services',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: width * 0.08,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.blue.shade200,
                offset: const Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
