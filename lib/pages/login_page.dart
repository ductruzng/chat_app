import 'package:auth_firebase/services/auth/auth_service.dart';
import 'package:auth_firebase/components/my_button.dart';
import 'package:auth_firebase/components/my_textField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login(BuildContext context) async {
    //auth service
    final authService = AuthService();

    // try login
    try {
      await authService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      _passwordController.clear();
      _emailController.clear();
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
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
              'Welcome back, sign in to continue',
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
              height: 25,
            ),

            // Login
            MyButton(text: "Login", onTap: () => login(context)),

            const SizedBox(
              height: 25,
            ),

            // _signup
            _signup(context),
          ],
        ),
      ),
    );
  }

  Widget _signup(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: "New User? ",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.normal,
                  fontSize: 16),
            ),
            TextSpan(
                text: "Create Account",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                recognizer: TapGestureRecognizer()..onTap = onTap),
          ])),
    );
  }
}
