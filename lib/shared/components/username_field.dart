import 'package:flutter/material.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController usernameController;

  const UsernameField({super.key, required this.usernameController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etichetta per il campo username
        const Text(
          'Username',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),

        // Campo di testo per username
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your username...',
          ),
        ),
      ],
    );
  }
}
