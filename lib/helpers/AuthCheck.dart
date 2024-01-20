import 'package:bhromon/pages/home.dart';
import 'package:bhromon/pages/login.dart';
import 'package:bhromon/pages/main_screen.dart';
import 'package:bhromon/pages/startpages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return MainScreen();
            }
            else{
              return IntroPage();
            }
          }
        ),
    );
  }
}
