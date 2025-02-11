// Principal Component
import 'package:defnet_front_end/screens/Profile/profile_screen.dart';
import 'package:defnet_front_end/screens/Service/service_screen.dart';
import 'package:defnet_front_end/screens/Wifi_Settings/wifi_settings_screen.dart';
import 'package:defnet_front_end/screens/Home/dash_board.dart';
import 'package:defnet_front_end/screens/Notifications/notification_screen.dart';
import 'package:defnet_front_end/screens/Notifications/notification_state.dart';
import '../splash_screen.dart';
import 'package:defnet_front_end/screens/Report/report_screen.dart';
import 'wifi_qr_screen.dart'; // Importa la schermata per visualizzare il QR code

// Shared Component
import 'package:defnet_front_end/shared/components/shape_lines/ellipse_custom.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:defnet_front_end/shared/services/logout_service.dart';
import 'package:defnet_front_end/shared/services/websocket_service.dart';
import 'package:defnet_front_end/shared/services/secure_storage_service.dart';

// Legacy Library Component
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Indice corrente della pagina visualizzata
  int? _previousIndex; // Variabile per memorizzare la pagina precedente

  String?_userName; // Variabile che conterrà il nome utente (inizialmente null)
  final SecureStorageService _storageService = SecureStorageService.instance;
  final LogoutService _logoutService = LogoutService();
  int? userId;

  late NotificationState _notificationState;

  List<int> _navigationStack = []; // Stack per tenere traccia delle pagine visitate

  final List<Widget> _pages = [
    DashboardScreen(),
    WifiSettingsScreen(),
    ServiceScreen(),
    ProfileScreen(),
  ];

  Future<void> _checkLoginStatus() async {
    final secureStorageService = SecureStorageService.instance;
    final token = await secureStorageService.getToken();

    if (token == null) {
      _userName = "Guest";
    } else {
      await _loadUserName();
    }
  }

  // Mostra un dialog quando l'utente preme il tasto indietro
  Future<bool> _onWillPop(BuildContext context) async {
    if (_currentIndex == 0) {
      // Se sei sulla Dashboard, mostra il messaggio
      bool shouldLogout = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Vuoi uscire?'),
              content: const Text('Sei sicuro di voler uscire dall\'app?'),
              actions: [
                // Pulsante "No"
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(false), // Chiude il dialog
                  child: const Text('No'),
                ),
                // Pulsante "Sì"
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(true), // Conferma uscita
                  child: const Text('Sì'),
                ),
              ],
            ),
          ) ??
          false; // Se il dialog viene chiuso senza selezione

      if (shouldLogout) {
        // Effettua il logout
        bool responseLogout = await _logoutService.logout(_storageService);
        if (responseLogout) {
          _notificationState.disposeService(userId!);
          _showMessageDialog(context, "Logout Successful!", true);
        } else {
          _showMessageDialog(context, "Logout Error!", false);
        }
        return true; // Consente la chiusura della pagina
      }
      return false; // Impedisce la chiusura della pagina
    }

    // Se non siamo sulla Dashboard, torniamo alla pagina precedente
    if (_navigationStack.isNotEmpty) {
      print("Sono Qui devo togliere un elemento dallo stack !");
      setState(() {
        _currentIndex =
            _navigationStack.removeLast(); // Torna alla pagina precedente
      });
      return false; // Blocca l'uscita dall'app
    }
    return true; // Permette l'uscita se non ci sono pagine precedenti
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Controlla se l'utente è loggato
  }

  Future<void> _loadUserName() async {
    try {
      final user = await _storageService.get();
      if (user != null) {
        setState(() {
          _userName = user.username;
          if (kDebugMode) {
            print("User ID: ${user.id}");
          }
          userId = user.id;
        });
      } else {
        if (kDebugMode) {
          print("User or username not found in storage.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading username: $e");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    _notificationState = Provider.of<NotificationState>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () => _onWillPop(context), // Gestione del tasto "Indietro"
      child: Scaffold(
        body: OrientationBuilder(
            builder: (context, orientation) {
              return Stack(
                children: [
                  CustomScrollView(
                    //CustomScrollView(
                    //physics: BouncingScrollPhysics(), // Scroll fluido
                    slivers: [

                      /// **SliverAppBar scrollabile**
                      SliverAppBar(
                        backgroundColor: Colors.transparent,
                        expandedHeight: screenHeight * 0.20,
                        //backgroundColor: const Color.fromARGB(0, 235, 227, 227),
                        elevation: 0,
                        //expandedHeight: screenHeight * 0.30, // Altezza espansa
                        floating: true, // Scompare quando si scrolla
                        snap: false, // Riapparizione immediata quando si scrolla verso l'alto
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            children: [

                              /// Onda superiore
                              EllipseUp(context),

                              /// Header con logo e pulsanti
                              //_buildHeader(),

                              SingleChildScrollView(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(height: 40),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Image.asset(
                                              'lib/assets/logodiviso.png',
                                              width: screenWidth * 0.27,
                                              height: screenHeight * 0.06,
                                            ),
                                            const SizedBox(height: 0),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.05,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'DefNet',
                                                    style: TextStyle(
                                                      fontSize: screenWidth *
                                                          0.05,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      color: Colors.white,
                                                      shadows: [
                                                        Shadow(
                                                          blurRadius: 5.0,
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          offset: Offset(3.0,
                                                              3.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  _buildNotificationButton(
                                                      screenWidth,
                                                      _notificationState),
                                                  SizedBox(width: screenWidth *
                                                      0.03),
                                                  _buildReportIcon(screenWidth),
                                                  SizedBox(width: screenWidth *
                                                      0.03),
                                                  _buildLogoutButton(
                                                      screenWidth),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        pinned: true,
                      ),

                      /// **Contenuto principale scrollabile**
                      SliverFillRemaining(
                        //hasScrollBody: true, // Abilita lo scroll
                        //child: Padding(
                          //padding: EdgeInsets.symmetric(
                              //horizontal: screenWidth * 0.0,
                              //vertical: screenHeight * 0),
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * 0.09),
                            child: IndexedStack(
                              index: _currentIndex,
                              children: _pages,
                            ),
                          ),
                        //),
                      ),
                    ],
                  ),
                ],
              );
            },
        ),

        /// Bottom Navigation Bar
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Colors.blue.shade900,
          buttonBackgroundColor: Colors.blueAccent.shade100,
          height: screenHeight * 0.08,
          animationDuration: const Duration(milliseconds: 300),
          index: _currentIndex,
          onTap: (index) {
            setState(() {
              if (index == 0) {
                // Se l'utente torna alla Dashboard, resetta lo stack
                _navigationStack.clear();
              } else {
                // Altrimenti, aggiungi l'indice corrente allo stack
                _navigationStack.add(_currentIndex);
              }
              _currentIndex = index;
            });
          },
          items: [
            Image.asset(
              'lib/assets/icons/home.png',
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              color: Colors.white,
            ),
            Image.asset(
              'lib/assets/icons/wifi.png',
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              color: Colors.white,
            ),
            Image.asset(
              'lib/assets/icons/service.png',
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              color: Colors.white,
            ),
            Image.asset(
              'lib/assets/icons/profile.png',
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // (Mantieni la funzione _buildQRCodeButton se in futuro serve)
  IconButton _buildQRCodeButton(double screenWidth) {
    return IconButton(
      icon: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 45,
              offset: Offset(0, 4),
            )
          ]),
          child: Icon(
            FontAwesomeIcons.qrcode,
            color: Colors.white,
            size: screenWidth * 0.080,
          )),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WifiQRScreen()));
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
              blurRadius: 45,
              offset: Offset(0, 2),
            )
          ]),
          child: Image.asset(
              'lib/assets/icons/logout.png',
              width: screenWidth * 0.10,
              height: screenWidth * 0.10,
              color: Colors.white)),
      onPressed: () async {
        bool responseLogout = await _logoutService.logout(_storageService);
        if (responseLogout) {

          _notificationState.disposeService(userId!);
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
              blurRadius: 45,
              offset: Offset(0, 2),
            )
          ]),
          child: Icon(
            FontAwesomeIcons.chartColumn,
            color: Colors.white,
            size: screenWidth * 0.080,
          )),
      onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ReportScreen(userId: userId!))
        );
      },
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
                      blurRadius: 45,
                      offset: Offset(0, 2),
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
            print("KATIA, ${userId}");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NotificationsScreen(userId: userId!)));
          },
        );
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
