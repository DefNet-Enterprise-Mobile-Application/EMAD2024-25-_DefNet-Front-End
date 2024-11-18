import 'package:flutter/material.dart';
import 'package:defnet_front_end/shared/components/navigation_menu.dart'; // Assumendo che FloatingBottomNavBar sia definito qui
import 'package:defnet_front_end/shared/components/shape_lines/ellipse_custom.dart'; // Assumendo che EllipseUp sia definito qui

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Contenuto della pagina
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SingleChildScrollView(
              child: Padding(

                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Modifica Profilo',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('lib/assets/avatar/avatar.png'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Logica per caricare un nuovo avatar
                          },
                          child: const Text('Cambia Avatar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Azione per salvare le modifiche
                      },
                      child: const Text('Salva Modifiche'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}