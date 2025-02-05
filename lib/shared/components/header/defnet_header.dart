import 'package:defnet_front_end/screens/Notifications/notification_screen.dart';
import 'package:defnet_front_end/screens/Notifications/notification_state.dart';
import 'package:defnet_front_end/screens/Report/report_screen.dart';
import 'package:defnet_front_end/screens/splash_screen.dart';
import 'package:defnet_front_end/shared/services/logout_service.dart';
import 'package:defnet_front_end/shared/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AppHeader extends StatefulWidget {
  final int userId;
  final double screenWidth;
  final double screenHeight;
  final String? userName;
  final Function() onLogout;

  const AppHeader({
    Key? key,
    required this.userId,
    required this.screenWidth,
    required this.screenHeight,
    required this.userName,
    required this.onLogout,
  }) : super(key: key);

  @override
  _AppHeaderState createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  late NotificationState _notificationState;

  final SecureStorageService _storageService = SecureStorageService.instance;
  final LogoutService _logoutService = LogoutService();


  @override
  Widget build(BuildContext context) {
    _notificationState = Provider.of<NotificationState>(context);
    
    
    return Positioned(
      top: 40,
      left: widget.screenWidth * 0.05,
      right: widget.screenWidth * 0.05,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'lib/assets/logodiviso.png',
            width: widget.screenWidth * 0.27,
            height: widget.screenHeight * 0.06,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.05),
            child: Row(
              children: [
                Text(
                  'DefNet',
                  style: TextStyle(
                    fontSize: widget.screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(3.0, 3.0),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                _buildNotificationButton(
                    widget.screenWidth, _notificationState),
                SizedBox(width: widget.screenWidth * 0.03),
                _buildReportIcon(widget.screenWidth),
                SizedBox(width: widget.screenWidth * 0.03),
                _buildLogoutButton(widget.screenWidth),
              ],
            ),
          ),
          if (widget.userName != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                  widget.screenWidth * 0.08, 1.0, 20.0, 0.0),
              child: Row(
                children: [
                  Text('Hello ',
                      style: TextStyle(
                          fontSize: widget.screenWidth * 0.08,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(widget.userName!,
                      style: TextStyle(
                          fontSize: widget.screenWidth * 0.08,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Pulsante Notifiche
  Consumer<NotificationState> _buildNotificationButton(
      double screenWidth, NotificationState notificationState) {
    return Consumer<NotificationState>(
      builder: (context, notificationState, child) {
        return IconButton(
          icon: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 30,
                      offset: Offset(0, 4),
                    )
                  ]),
                  child: Image.asset(
                    'lib/assets/icons/notification.png',
                    width: screenWidth * 0.10,
                    height: screenWidth * 0.10,
                    color: Colors.white,
                  )),
              if (notificationState.hasNewNotification)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
            ],
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NotificationsScreen(userId: widget.userId)));
          },
        );
      },
    );
  }

  // Pulsante Logout
  IconButton _buildLogoutButton(double screenWidth) {
    return IconButton(
      icon: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 30,
              offset: Offset(0, 4),
            )
          ]),
          child: Image.asset('lib/assets/icons/logout.png',
              width: screenWidth * 0.10,
              height: screenWidth * 0.10,
              color: Colors.white)),
      onPressed: () async {
        bool responseLogout = await _logoutService.logout(_storageService);
        if (responseLogout) {
          _notificationState.disposeService(widget.userId!);
          _showMessageDialog(context, "Logout Successful!", true);
        } else {
          _showMessageDialog(context, "Logout Error!", false);
        }
      },
    );
  }

  // Pulsante Report
  IconButton _buildReportIcon(double screenWidth) {
    return IconButton(
      icon: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 30,
              offset: Offset(0, 4),
            )
          ]),
          child: Icon(
            FontAwesomeIcons.chartColumn,
            color: Colors.white,
            size: screenWidth * 0.080,
          )),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportScreen(userId: widget.userId)));
      },
    );
  }

  // Mostra messaggio di dialogo
  void _showMessageDialog(BuildContext context, String message, bool success) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.indigo[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!success)
                  Icon(
                    FontAwesomeIcons.timesCircle,
                    color: Colors.red,
                    size: 50,
                  ),
                if (success) ...[
                  Icon(
                    FontAwesomeIcons.check,
                    color: Colors.green,
                    size: 50,
                  ),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ],
            ),
          );
        });

    // Chiudi il dialog dopo 3 secondi
    Future.delayed(const Duration(seconds: 2), () {
      // Cambiato da 1 a 3 secondi
      Navigator.of(context).pop(); // Chiude il dialog
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        ); // Torna al login// Naviga alla schermata Home se il login ha successo
      }
    });
  }
}
