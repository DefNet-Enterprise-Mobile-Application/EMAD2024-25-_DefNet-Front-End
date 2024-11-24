import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:defnet_front_end/screens/Profile/profile_screen.dart';
import 'package:defnet_front_end/screens/Service/service_screen.dart';
import 'package:defnet_front_end/screens/Wifi_Settings/wifi_settings_screen.dart';
import 'package:defnet_front_end/screens/Home/dash_board.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:defnet_front_end/shared/components/navigation_menu.dart'; // Aggiungi il file NavigationMenu
import 'package:defnet_front_end/screens/Notifications/notification_screen.dart'; // Aggiorna l'importazione
import '../../shared/components/shape_lines/ellipse_custom.dart';
import '../splash_screen.dart'; // Update the Ellipse widget as needed
import '../Service/SecureStorageService.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Indice corrente della pagina visualizzata

  String? _userName; // Variabile che conterrà il nome utente (inizialmente null)
  final SecureStorageService _storageService = SecureStorageService.instance;

  final List<Widget> _pages = [
    DashboardScreen(),
    WifiSettingsScreen(),
    ServiceScreen(),
    ProfileScreen(),
  ];

  Future<void> _checkLoginStatus() async {
    final secureStorageService = SecureStorageService.instance; // Usa il tuo SecureStorageService
    final token = await secureStorageService.getToken(); // Supponiamo che esista un metodo getToken()

    if (token == null) {
      // Se il token non esiste, significa che l'utente non è loggato
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()), // Torna alla SplashScreen o LoginScreen
      );
    } else {
      // Se il token esiste, carica il nome utente
      _loadUserName();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Controlla se l'utente è loggato
  }



  // Funzione per caricare il nome dell'utente da SecureStorageService
  Future<void> _loadUserName() async {
    try{
      final user = await _storageService.get(); // Ottieni i dati dell'utente salvati
      if (user != null) {
        setState(() {
          _userName = user.username; // Aggiorna il nome dell'utente nella UI
          print("User ID: ${user.id}"); // Puoi loggare l'id per verificare che venga caricato
        });
      } else {
        print("User or username not found in storage.");
      }
    } catch (e) {
      print("Error loading username: $e");
    }

  }

  @override
  Widget build(BuildContext context) {
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
                expandedHeight: screenHeight * 0.2, // Altezza dell'ellisse in base all'altezza dello schermo
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
                                      const SizedBox(height: 0,), // Spazio tra il logo e il testo

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(45.0,0.0,20.0,3.0), // Aggiunge un po' di spazio
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
                                                )
                                              ),
                                              onPressed: () {
                                                // Logica per le notifiche
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
                                                // Rimuove il nome utente dal Secure Storage
                                                await _storageService.delete(); // Elimina i dati dell'utente

                                                // Logica per il logout
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => SplashScreen()),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Mostra il nome dell'utente dopo il caricamento, o un caricamento se non è ancora stato caricato
                                      if (_userName != null) // Verifica se l'username è caricato
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(30.0, 25.0, 20.0, 0.0),
                                        child: Row(
                                          children: [
                                            Text(
                                            'Ciao ',  // Testo fisso "Ciao"
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
                            ]
                          ),
                        )
                      )
                    ],
                  ),
                ),

                pinned: true, // Mantieni visibile l'ellisse anche dopo lo scroll
              ),
              // Contenuto dinamico in base alla pagina selezionata
              SliverFillRemaining(
                child: IndexedStack(
                  index: _currentIndex,
                  children: _pages,
                ),
              ),
            ],
          ),
        ],
      ),

      // Barra di navigazione curva
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.blueAccent,
        buttonBackgroundColor: Colors.blueAccent.shade100,
        height: screenHeight * 0.08, // Altezza della barra di navigazione adattiva
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

  // Metodo per mostrare la finestra di dialogo
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Bordi arrotondati
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.indigo[900], // Sfondo blu scuro
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are you sure you want to leave?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Sfondo bianco
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        "NO",
                        style: TextStyle(
                          color: Colors.indigo, // Testo blu scuro
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Chiude il dialog
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Sfondo bianco
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        "YES",
                        style: TextStyle(
                          color: Colors.indigo, // Testo blu scuro
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Chiude il dialog
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SplashScreen()),
                        ); // Naviga alla pagina iniziale
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
