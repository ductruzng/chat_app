import 'package:auth_firebase/pages/home_page.dart';
import 'package:auth_firebase/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // if connection state is waiting then return CircularProgressIndicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
            // if snapshot has data then return HomePage
          } else if (snapshot.hasData) {
            return  HomePage();
            // if snapshot has error then return Text('Error')
          } else if (snapshot.hasError) {
            return const Text('Error');
            // else return LoginPage
          } else {
            return const LoginOrRegister();
          }
        },
      )
    );
  }
}
