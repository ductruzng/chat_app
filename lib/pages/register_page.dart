import 'package:auth_firebase/services/auth/auth_service.dart';
import 'package:auth_firebase/components/my_button.dart';
import 'package:auth_firebase/components/my_textField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  void _register(BuildContext context) async {
    //auth service
    final authService = AuthService();

    // try register
    if (_confirmPwController.text == _passwordController.text) {
      try {
        await authService.registerWithEmailAndPassword(
            _emailController.text, _passwordController.text);

        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                title: Text('Account created successfully!')));
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(title: Text(e.toString())));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              const AlertDialog(title: Text('Password does not match')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat,
            size: 50,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "Let's create an account!",
            style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.w600,
                fontSize: 20),
          ),
          const SizedBox(
            height: 50,
          ),
          MyTextfield(
              hintText: 'Email',
              controller: _emailController,
              obscureText: false),
          const SizedBox(
            height: 10,
          ),
          MyTextfield(
              hintText: 'Password',
              controller: _passwordController,
              obscureText: true),
          const SizedBox(
            height: 10,
          ),

          MyTextfield(
              hintText: 'Confirm password',
              controller: _confirmPwController,
              obscureText: true),
          const SizedBox(
            height: 25,
          ),

          // Login
          MyButton(text: "Register", onTap: () => _register(context)),

          const SizedBox(
            height: 25,
          ),
          _login(context)
        ],
      ),
    );
  }

  Widget _login(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: "Already an account? ",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.normal,
                  fontSize: 16),
            ),
            TextSpan(
                text: "Login now",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                recognizer: TapGestureRecognizer()..onTap = onTap),
          ])),
    );
  }
}
