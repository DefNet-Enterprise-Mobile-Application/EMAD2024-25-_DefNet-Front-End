import 'package:defnet_front_end/screens/login_screen.dart';
import 'package:defnet_front_end/shared/components/shape_lines/ellipse_custom.dart';
import 'package:flutter/material.dart';
import 'package:defnet_front_end/shared/services/registration_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  // Controller - text controller
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // RegistrationService - service as register
  final RegistrationService registrationService = RegistrationService();

  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      body: SingleChildScrollView(

        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              // Wave Up
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: EllipseUp(rotateImage: false,), // Widget personalizzato per l'onda superiore
              ),
              // Wave Down
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: EllipseDown(), // Widget personalizzato per l'onda inferiore
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20), // Spazio tra l'onda superiore e il logo
                  // Logo Image
                  Image.asset(
                    'lib/assets/logo.png', // Sostituisci con il percorso del tuo logo
                    width: 150,
                    height: 150,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          TextField(
                            controller : _usernameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Inserisci il tuo username...',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Inserisci la tua password...',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                // Registration Service
                                await registrationService.registerUser(
                                  context,
                                    _usernameController.text,
                                    _passwordController.text
                                );
                                // Press Sign Up to reach the Home Page Dashboard
                                //Navigator.pushReplacement(
                                  //context,
                                 // MaterialPageRoute(builder: (context) =>  HomeScreen()),
                               // );

                              },
                              child: const Text('Sign Up'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                // Go to Registration Screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              },
                              child: const Text(
                                'Per loggarti clicca qui!',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
