import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:defnet_front_end/screens/Profile/profile_screen.dart';
import 'package:defnet_front_end/screens/Service/service_screen.dart';
import 'package:defnet_front_end/screens/Wifi_Settings/wifi_settings_screen.dart';
import 'package:defnet_front_end/screens/Home/dash_board.dart';
import 'package:defnet_front_end/shared/services/logout_service.dart';
import 'package:flutter/foundation.dart';
// Aggiungi il file NavigationMenu
import 'package:defnet_front_end/screens/Notifications/notification_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../shared/components/shape_lines/ellipse_custom.dart';
import '../Notifications/notification_state.dart';
import '../../shared/services/websocket_service.dart';
import '../splash_screen.dart'; // Update the Ellipse widget as needed
import 'package:defnet_front_end/shared/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
// Importa NotificationState

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0; // Indice corrente della pagina visualizzata
  int? _previousIndex; // Variabile per memorizzare la pagina precedente

  String?
      _userName; // Variabile che conterrà il nome utente (inizialmente null)
  final SecureStorageService _storageService = SecureStorageService.instance;
  final LogoutService _logoutService = LogoutService();
  int? userId;


  late NotificationState _notificationState;


  final List<Widget> _pages = [
    DashboardScreen(),
    WifiSettingsScreen(),
    ServiceScreen(),
    ProfileScreen(),
  ];

  Future<void> _checkLoginStatus() async {
    final secureStorageService =
        SecureStorageService.instance; // Usa il tuo SecureStorageService
    final token = await secureStorageService
        .getToken(); // Supponiamo che esista un metodo getToken()

    if (token == null) {
      // Se il token non esiste, significa che l'utente non è loggato
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SplashScreen()), // Torna alla SplashScreen o LoginScreen
      );
    } else {
      // Se il token esiste, carica il nome utente
      await _loadUserName();
    }
  }

  @override
  void initState() {
    super.initState();


    _checkLoginStatus(); // Controlla// se l'utente è loggato
  }

  // Funzione per caricare il nome dell'utente da SecureStorageService
  Future<void> _loadUserName() async {
    try {
      final user =
          await _storageService.get(); // Ottieni i dati dell'utente salvati
      if (user != null) {
        setState(() {
          _userName = user.username; // Aggiorna il nome dell'utente nella UI
          if (kDebugMode) {
            print("User ID: ${user.id}");
          } // Puoi loggare l'id per verificare che venga caricato

          /// Inserire l'ID dell'utente
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
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    _notificationState = Provider.of<NotificationState>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Contenuto dinamico con scrolling
          CustomScrollView(
            slivers: [
              // SliverAppBar per l'ellisse con logo sovrapposto
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: screenHeight *
                    0.27, // Aumenta l'altezza dell'ellisse per lasciare spazio
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
                                      padding: const EdgeInsets.fromLTRB(52.0, 0.0, 20.0, 3.0), // Aggiunge un po' di spazio
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
                                          IconButton(
                                            icon: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.3), // Colore dell'ombra
                                                    spreadRadius: 1, // Distanza dell'ombra
                                                    blurRadius: 30, // Sfocatura dell'ombra
                                                    offset: Offset(0, 4), // Spostamento dell'ombra
                                                  ),
                                                ],
                                              ),
                                              child: Image.asset(
                                                'lib/assets/icons/notification.png',
                                                width: screenWidth * 0.10,
                                                height: screenWidth * 0.10,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              // Logica per le notifiche
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => NotificationScreen()),
                                              );
                                            },
                                          ),
                                          SizedBox(width: screenWidth * 0.03),
                                          IconButton(
                                            icon: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.3), // Colore dell'ombra
                                                    spreadRadius: 1, // Distanza dell'ombra
                                                    blurRadius: 30, // Sfocatura dell'ombra
                                                    offset: Offset(0, 4), // Spostamento dell'ombra
                                                  ),
                                                ],
                                              ),
                                              child: Image.asset(
                                                'lib/assets/icons/logout.png',
                                                width: screenWidth * 0.10,
                                                height: screenWidth * 0.10,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () async {
                                              bool responseLogout = await _logoutService.logout(_storageService);

                                              if (responseLogout) {
                                                _showMessageDialog(context, "Logout Successful!", true);
                                              } else {
                                                _showMessageDialog(context, "Logout Error!", false);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Mostra il nome dell'utente dopo il caricamento
                                    if (_userName != null && _currentIndex == 0)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(30.0, 1.0, 20.0, 0.0),
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
                pinned: true, // Mantieni visibile l'ellisse anche dopo lo scroll
                          
                /*child: SizedBox(
                        width: double.infinity,
                        child: Column(children: <Widget>[
                          const SizedBox(height: 40),
                          // Immagine del logo
                          Align(
                            alignment: Alignment
                                .topLeft, // Allineamento a sinistra e in alto
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Immagine del logo
                                Image.asset(
                                  'lib/assets/logodiviso.png',
                                  width: 170,
                                  height: 60,
                                ),
                                const SizedBox(
                                  height: 0,
                                ), // Spazio tra il logo e il testo

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(45.0, 0.0,
                                      20.0, 3.0), // Aggiunge un po' di spazio
                                  child: Row(
                                    children: [
                                      Text(
                                        'DefNet',
                                        style: TextStyle(
                                          fontSize: 20, // Dimensione testo
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Colors.white, // Colore del testo
                                          shadows: [
                                            Shadow(
                                              blurRadius: 5.0,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              offset: Offset(3.0, 3.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),

                                      /// Notification Button
                                      /// Consumer Notification
                                      _buildNotificationButton(
                                          screenWidth, _notificationState),

                                      SizedBox(width: screenWidth * 0.03),

                                      /// Logout Button
                                      _buildLogoutButton(screenWidth),
                                    ],
                                  ),
                                ),
                                // Mostra il nome dell'utente dopo il caricamento, o un caricamento se non è ancora stato caricato
                                if (_userName != null &&
                                    _currentIndex ==
                                        0) // Verifica se l'username è caricato
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30.0, 25.0, 20.0, 0.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Ciao ', // Testo fisso "Ciao"
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          _userName!,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ]),
                      ))
                    ],
                  ),
                ),

                pinned:
                    true, // Mantieni visibile l'ellisse anche dopo lo scroll
 // Section - pub/sub-login-umberto */
              ),
              // Contenuto dinamico in base alla pagina selezionata
              SliverFillRemaining(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0), // Aggiungi un po' di spazio ai bordi
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

      // Barra di navigazione curva
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.blue.shade900,
        buttonBackgroundColor: Colors.blueAccent.shade100,
        height:
            screenHeight * 0.08, // Altezza della barra di navigazione adattiva
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
            width: screenWidth * 0.08, // Dimensione adattiva delle icone
            height: screenWidth * 0.08, // Dimensione adattiva delle icone
            color: Colors.white,
          ),
          Image.asset(
            'lib/assets/icons/wifi.png',
            width: screenWidth * 0.08, // Dimensione adattiva delle icone
            height: screenWidth * 0.08, // Dimensione adattiva delle icone
            color: Colors.white,
          ),
          Image.asset(
            'lib/assets/icons/service.png',
            width: screenWidth * 0.08, // Dimensione adattiva delle icone
            height: screenWidth * 0.08, // Dimensione adattiva delle icone
            color: Colors.white,
          ),
          Image.asset(
            'lib/assets/icons/profile.png',
            width: screenWidth * 0.08, // Dimensione adattiva delle icone
            height: screenWidth * 0.08, // Dimensione adattiva delle icone
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  // Funzione che mostra un dialog personalizzato
  void _showMessageDialog(BuildContext context, String message, bool success) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impedisce di chiudere il dialog cliccando fuori
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[700], // Sfondo blu
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Bordi arrotondati
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
                const SizedBox(height: 10),
              ],
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      },
    );

    // Chiudi il dialog dopo 3 secondi
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Chiude il dialog
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        ); // Naviga alla schermata Home se il login ha successo
      }
    });
  }


  IconButton _buildLogoutButton(screenWidth) {
    return IconButton(
      icon: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Colore dell'ombra
              spreadRadius: 1, // Distanza dell'ombra
              blurRadius: 30, // Sfocatura dell'ombra
              offset: Offset(0, 4), // Spostamento dell'ombra
            ),
          ],
        ),
        child: Image.asset(
          'lib/assets/icons/logout.png',
          width: screenWidth * 0.10,
          height: screenWidth * 0.10,
          color: Colors.white,
        ),
      ),
      onPressed: () async {
        bool responseLogout =
            await _logoutService.logout(_storageService);
        

        if (responseLogout) {
          _notificationState.disposeService(userId!);
          _showMessageDialog(context, "Logout Successful!", true);
        } else {
          _showMessageDialog(context, "Logout Error!", false);
        }
      },
    );
  }






  /// Metodo _buildNotificationButton
  ///
  /// Questo metodo costruisce un widget che rappresenta un pulsante di notifica
  /// con un'icona personalizzata. È incluso un pallino rosso per indicare la presenza
  /// di nuove notifiche non lette. Il pulsante utilizza un `Consumer` per ascoltare
  /// i cambiamenti nello stato delle notifiche attraverso il modello `NotificationState`.
  ///
  /// ### Parametri:
  /// - **screenWidth** (`double`): La larghezza dello schermo. Serve per scalare
  ///   dinamicamente le dimensioni dell'icona di notifica.
  /// - **notificationState** (`NotificationState`): Lo stato attuale delle notifiche.
  ///   Gestisce la logica per determinare se ci sono nuove notifiche e aggiorna l'interfaccia.
  ///
  /// ### Funzionalità:
  /// - L'icona di notifica è rappresentata da un'immagine personalizzata (`notification.png`).
  /// - Se ci sono nuove notifiche, viene mostrato un piccolo cerchio rosso in alto a destra dell'icona.
  /// - Quando l'utente preme il pulsante:
  ///   1. Il pallino rosso viene rimosso (chiamando il metodo `markNotificationsAsRead()`
  ///      di `NotificationState`).
  ///   2. L'utente viene reindirizzato alla schermata delle notifiche (`/notifications`),
  ///      passando come argomento il parametro `userId`.
  ///
  ///
  /// ### Logica interna:
  /// - La logica di rendering dell'icona e del pallino rosso è gestita utilizzando un widget `Stack`.
  /// - Un `BoxShadow` è applicato all'immagine per migliorare l'estetica.
  /// - La posizione del pallino rosso è gestita utilizzando un widget `Positioned`.
  ///
  /// ### Vantaggi:
  /// - La gestione dello stato è reattiva grazie al `Consumer` di Provider.
  /// - Il design è flessibile e si adatta dinamicamente alla larghezza dello schermo.
  /// - Facilmente estendibile per supportare altre funzionalità, come notifiche sonore o animazioni.
  ///
  /// ### Limitazioni:
  /// - Richiede un'implementazione corretta di `NotificationState` per funzionare.
  /// - L'immagine dell'icona deve essere presente nella directory specificata (`lib/assets/icons/`).
  ///
  /// ### Dipendenze:
  /// - Provider per la gestione dello stato.
  /// - Risorsa immagine in `lib/assets/icons/notification.png`.
  ///
  /// ### Modifica necessaria in `NotificationState`:
  /// Il metodo `markNotificationsAsRead` dovrebbe essere implementato nella classe `NotificationState`:
  Consumer<NotificationState> _buildNotificationButton(
      screenWidth, notificationState) {
    return // Aggiungi il Consumer per gestire le notifiche
        Consumer<NotificationState>(
      builder: (context, notificationState, child) {
        return IconButton(
          icon: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.3), // Colore dell'ombra
                        spreadRadius: 1, // Distanza dell'ombra
                        blurRadius: 30, // Sfocatura dell'ombra
                        offset: Offset(0, 4), // Spostamento dell'ombra
                      ),
                    ],
                  ),
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
                ),
            ],
          ),
          onPressed: () {
            //notificationState
                //.markNotificationsAsRead(); // Resetta il pallino rosso
            Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotificationsScreen(userId: userId!,)),
        );
          },
        );
      },
    );
  }
}
