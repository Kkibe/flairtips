import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goalgenius/screens/sign_in_screen.dart';

void conditionalNavigation(BuildContext context) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    Navigator.pushNamed(context, "/plans");
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen(toPlans: true)),
    );
  }
}
