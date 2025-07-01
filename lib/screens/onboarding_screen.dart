import 'package:flairtips/utils/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flairtips/widgets/filled_button.dart';
import 'package:flairtips/widgets/outlined_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  void _checkUserLoggedIn() async {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final user = userProvider.user;
    if (user != null) Navigator.pushReplacementNamed(context, "/main");
  }

  @override
  Widget build(BuildContext context) {
    _setNotificationPreference();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 10.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/main");
              },
              child: Text(
                'Skip',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(flex: 2),
            Column(
              spacing: 16,
              children: const [
                Text(
                  'Welcome to flairtips',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                //SizedBox(height: 8),
                Text(
                  'Your gateway to live sports, real-time updates, and unforgettable moments. \nLet’s get started',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Spacer(flex: 2),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppFilledButton(
                  text: "Sign In",
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                ),
                SizedBox(height: 16),
                AppOutlinedButton(
                  text: 'Create account',
                  onPressed: () {
                    Navigator.pushNamed(context, "/register");
                  },
                ),
              ],
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

Future<void> _setNotificationPreference() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('notificationsEnabled', true);
}
