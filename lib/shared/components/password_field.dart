import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final ValueChanged<String> onPasswordChanged;
  final String errorMessage;
  final VoidCallback onTogglePasswordVisibility;

  const PasswordField({
    super.key,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onPasswordChanged,
    required this.errorMessage,
    required this.onTogglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etichetta per il campo password
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),

        // Campo password
        TextField(
          controller: passwordController,
          obscureText: !isPasswordVisible,
          onChanged: onPasswordChanged,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            hintText: 'Enter your password...',
            suffixIcon: IconButton(
              icon: isPasswordVisible
                  ? SvgPicture.asset('lib/assets/icons/eye-password-see-view.svg')
                  : SvgPicture.asset('lib/assets/icons/eye-password-hide.svg'),
              onPressed: onTogglePasswordVisibility,
            ),
          ),
        ),

        // Messaggio di errore, se presente
        if (errorMessage.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            errorMessage,
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
