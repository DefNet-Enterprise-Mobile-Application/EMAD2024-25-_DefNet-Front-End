import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Funzione di login simulata
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text(
                'Login',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
