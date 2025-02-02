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

  String? _userName; // Variabile che conterrà il nome utente (inizialmente null)
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
      bool shouldLogout =  await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Vuoi uscire?'),
          content: const Text('Sei sicuro di voler uscire dall\'app?'),
          actions: [
            // Pulsante "No"
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Chiude il dialog
              child: const Text('No'),
            ),
            // Pulsante "Sì"
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Conferma uscita
              child: const Text('Sì'),
            ),
          ],
        ),
      ) ?? false; // Se il dialog viene chiuso senza selezione

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
      setState(() {
        _currentIndex = _navigationStack.removeLast(); // Torna alla pagina precedente
      });
      return false; // Blocca l'uscita dall'app
    }
    return true; // Permette l'uscita se non ci sono pagine precedenti
  }

  @override
  void initState() {
    super.initState();
    // Blocca la rotazione solo in modalità verticale
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/

    _checkLoginStatus(); // Controlla// se l'utente è loggato
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
  
  
  
  // Modifiche Pub-Sub/Login Umberto
  
  @override
  Widget build(BuildContext context) {
    _notificationState = Provider.of<NotificationState>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    expandedHeight: screenHeight * 0.27,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          EllipseUp(),
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
                                              horizontal: screenWidth * 0.05),
                                          child: Row(
                                            children: [
                                              Text(
                                                'DefNet',
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 5.0,
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      offset: Offset(3.0, 3.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              _buildNotificationButton(
                                                  screenWidth,
                                                  _notificationState),
                                              SizedBox(
                                                  width: screenWidth * 0.03),
                                              _buildQRCodeButton(screenWidth),
                                              // Pulsante QR Code aggiunto qui
                                              SizedBox(
                                                  width: screenWidth * 0.03),
                                              _buildReportIcon(screenWidth),
                                              SizedBox(
                                                  width: screenWidth * 0.03),
                                              _buildLogoutButton(screenWidth),
                                            ],
                                          ),
                                        ),
                                        if (_userName != null &&
                                            _currentIndex == 0)
                                          Padding(
                                            padding:
                                            EdgeInsets.fromLTRB(
                                                screenWidth * 0.08, 1.0, 20.0,
                                                0.0),
                                            child: Row(
                                              children: [
                                                Text('Hello ',
                                                    style:
                                                    TextStyle(
                                                        fontSize: screenWidth *
                                                            0.08, color:
                                                    Colors.white, fontWeight:
                                                    FontWeight.bold)),
                                                Text(_userName!, style:
                                                TextStyle(fontSize:
                                                screenWidth * 0.08, color:
                                                Colors.white, fontWeight:
                                                FontWeight.bold)),
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
                  SliverFillRemaining(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02),
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: IndexedStack(
                            index: _currentIndex, children: _pages),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.blue.shade900,
        buttonBackgroundColor: Colors.blueAccent.shade100,
        height: screenHeight * 0.08,
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          Image.asset('lib/assets/icons/home.png', width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              color: Colors.white),
          Image.asset('lib/assets/icons/wifi.png', width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              color: Colors.white),
          Image.asset('lib/assets/icons/service.png', width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              color: Colors.white),
          Image.asset('lib/assets/icons/profile.png', width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              color: Colors.white),
        ],
        ),
    );
  }
  
  
  
  // Modifiche relative al branch GestioneStato - /// TODO: da rivedere 
  //@override
  Widget build2(BuildContext context) {
    _notificationState = Provider.of<NotificationState>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: () => _onWillPop(context),  // Gestione del tasto "Indietro"
        child:  Scaffold(
          body: Stack(
            children: [
              // Contenuto dinamico con scrolling
              CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: [
                  // SliverAppBar per l'ellisse con logo sovrapposto
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    expandedHeight: screenHeight * 0.27, // Aumenta l'altezza dell'ellisse per lasciare spazio
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          // Onda (ellisse)
                          EllipseUp(),
                          // Contenuto della pagina
                          SingleChildScrollView(
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 40),
                                  // Immagine del logo
                                  Align(
                                    alignment: Alignment.topLeft, // Allineamento a sinistra e in alto
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Immagine del logo
                                        Image.asset(
                                          'lib/assets/logodiviso.png',
                                          width: 170,
                                          height: 60,
                                        ),
                                        const SizedBox(height: 0), // Spazio tra il logo e il testo
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              52.0,
                                              0.0,
                                              20.0,
                                              3.0), // Aggiunge un po' di spazio
                                          child: Row(
                                            children: [
                                              Text(
                                                'DefNet',
                                                style: TextStyle(
                                                  fontSize: 20, // Dimensione testo
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white, // Colore del testo
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 5.0,
                                                      color: Colors.black.withOpacity(0.5),
                                                      offset: Offset(3.0, 3.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),

                                              /// Notification Button
                                              /// Consumer Notification
                                              _buildNotificationButton(screenWidth, _notificationState),
                                              SizedBox(width: screenWidth * 0.03),
                                              _buildLogoutButton(screenWidth)
                                            ],
                                          ),
                                        ),
                                        // Mostra il nome dell'utente dopo il caricamento
                                        if (_userName != null && _currentIndex == 0)
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                30.0, 1.0, 20.0, 0.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Hello ',
                                                  style: TextStyle(
                                                    fontSize: 40, // Aumentata la dimensione del testo
                                                    color: Colors.white, // Cambiato il colore in nero
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [
                                                      Shadow(
                                                        blurRadius: 5.0,
                                                        color: Colors.black.withOpacity(0.5),
                                                        offset: Offset(3.0, 3.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  _userName!,
                                                  style: TextStyle(
                                                    fontSize: 30, // Aumentata la dimensione del testo
                                                    color: Colors.white, // Cambiato il colore in nero
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [
                                                      Shadow(
                                                        blurRadius: 5.0,
                                                        color: Colors.black.withOpacity(0.5),
                                                        offset: Offset(3.0, 3.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                              ),
                                              const Spacer(),
                                              _buildNotificationButton(
                                                  screenWidth, _notificationState),
                                              SizedBox(width: screenWidth * 0.03),
                                              _buildReportIcon(screenWidth),
                                              SizedBox(width: screenWidth * 0.03),
                                              _buildLogoutButton(screenWidth),
                                            ],
                                          ),
                                  )
                                      ],
                                    ),
                                  ),
                          )
                                ],
                              ),
                            ),
                          pinned: true,
                          ),
                  SliverFillRemaining(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0), // Aggiungi un po' di spazio ai bordi
                      child: Container(
                        padding: const EdgeInsets.all(20.0), // Padding interno per separare il contenuto dal bordo
                        child: IndexedStack(
                          index: _currentIndex,
                          children: _pages,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.blue.shade900,
        buttonBackgroundColor: Colors.blueAccent.shade100,
        height: screenHeight * 0.08,
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
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
        ]
        )
        ),
    );
                  
  }

// Pulsante QR Code
  IconButton _buildQRCodeButton(double screenWidth) {
    return IconButton(
      icon: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 30,
              offset: Offset(0, 4),)
          ]),
          child: Icon(FontAwesomeIcons.qrcode, color: Colors.white,
            size: screenWidth * 0.080,)
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            WifiQRScreen())); // Naviga alla schermata del QR code Wi-Fi
      },
    );
  }

// Pulsante Logout
  IconButton _buildLogoutButton(double screenWidth) {
    return IconButton(
      icon: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 30,
              offset: Offset(0, 4),)
          ]),
          child: Image.asset(
              'lib/assets/icons/logout.png', width: screenWidth * 0.10,
              height: screenWidth * 0.10,
              color: Colors.white)
      ),
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
            BoxShadow(color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 30,
              offset: Offset(0, 4),)
          ]),
          child: Icon(FontAwesomeIcons.chartColumn, color: Colors.white,
            size: screenWidth * 0.080,)
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ReportScreen()));
      },
    );
  }

// Pulsante Notifiche
  Consumer<NotificationState> _buildNotificationButton(double screenWidth,
      NotificationState notificationState) {
    return Consumer<NotificationState>(
      builder: (context, notificationState, child) {
        return IconButton(
          icon:
          Stack(children: [
            Container(decoration:
            BoxDecoration(boxShadow: [
              BoxShadow(color:
              Colors.black.withOpacity(0.3), spreadRadius:
              1, blurRadius:
              30, offset:
              Offset(0, 4),)
            ]),
                child:
                Image.asset('lib/assets/icons/notification.png', width:
                screenWidth * 0.10, height:
                screenWidth * 0.10, color:
                Colors.white,)
            ),

            if(notificationState.hasNewNotification)
              Positioned(top:
              0, right:
              0,
                child:
                Container(width:
                12, height:
                12, decoration:
                BoxDecoration(color:
                Colors.red, shape:
                BoxShape.circle,),),)
          ]),
          onPressed:
              () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) =>
                    NotificationsScreen(userId: userId!)));
          },
        );
      },
    );
  }

// Mostra messaggio di dialogo
  void _showMessageDialog(BuildContext context, String message, bool success) {
    showDialog(context:
    context, barrierDismissible: false, builder: (context) {
      return AlertDialog(backgroundColor:
      Colors.indigo[700], shape:
      RoundedRectangleBorder(borderRadius:
      BorderRadius.circular(15),), content:
      Column(mainAxisSize:
      MainAxisSize.min, children: [
        if(!success)
          Icon(FontAwesomeIcons.timesCircle, color:
          Colors.red, size:
          50,),
        if(success)...[
          Icon(FontAwesomeIcons.check, color:
          Colors.green, size:
          50,),
          Text(message, textAlign:
          TextAlign.center, style:
          TextStyle(color:
          Colors.white, fontSize:
          MediaQuery
              .of(context)
              .size
              .width * 0.05, fontWeight:
          FontWeight.bold,),)
        ],
      ],));
    });
  }
}