import 'package:defnet_front_end/screens/Home/home_screen.dart';
import 'package:defnet_front_end/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../shared/components/shape_lines/ellipse_custom.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: EllipseUp(rotateImage: false,), // Widget personalizzato per l'onda superiore
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: EllipseDown(), // Widget personalizzato per l'onda inferiore
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20), // Spazio tra l'onda superiore e il logo
                  Image.asset(
                    'lib/assets/logo.png', // Sostituisci con il percorso del tuo logo
                    width: 150,
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Inserisci il tuo username...',
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Inserisci la tua password...',
                            ),
                          ),
                          SizedBox(height: 16),
                          // Button SignIn
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Press Button to reach the home_page
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                );
                              },
                              child: Text('Sign In'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child:

                            TextButton(
                              onPressed: () {
                                // Go to Registration Page
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                                );
                              },
                              child: Text(
                                'Per registrarti clicca qui!',
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
