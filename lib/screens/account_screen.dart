import 'package:flutter/material.dart';
import 'package:mental_math_trainer_app/firebase/firebase_auth_services.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Future<bool> signOut = FirebaseAuthService().signOutFromGoogle();
              print(signOut);
            },
            child: const Text('Sign Out'),
          ),
        ),
      ]),
    );
  }
}
