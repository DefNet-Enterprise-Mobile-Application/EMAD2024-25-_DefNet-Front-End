import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;
  final String emailErrorMessage;
  final ValueChanged<String> onChanged;

  const EmailField({
    super.key,
    required this.emailController,
    required this.emailErrorMessage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etichetta per il campo email
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 16,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 8),

        // Campo di testo per email
        TextField(
          controller: emailController,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[800]!),
            ),
            hintText: 'Enter your email...',
          ),
        ),

        // Mostra il messaggio di errore se presente
        if (emailErrorMessage.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            emailErrorMessage,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
