import 'package:defnet_front_end/screens/Home/home_screen.dart';
import 'package:defnet_front_end/screens/Notifications/notification_state.dart';
import 'package:defnet_front_end/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa flutter_dotenv
import 'package:defnet_front_end/shared/services/secure_storage_service.dart';
import 'package:get_it/get_it.dart';

void main() async {
  await dotenv.load();

  setupDependencies();

  runApp(const MyApp());
}

void setupDependencies() {
  GetIt.I.registerSingleton<SecureStorageService>(SecureStorageService.instance);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationState(), // Fornisci NotificationState
      child: MaterialApp(
        title: 'DefNet',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
