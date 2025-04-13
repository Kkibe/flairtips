import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goalgenius/firebase_options.dart';
import 'package:goalgenius/screens/bottom_nav.dart';
import 'package:goalgenius/screens/onboarding_screen.dart';
import 'package:goalgenius/screens/payment_page.dart';
import 'package:goalgenius/screens/sign_in_screen.dart';
import 'package:goalgenius/screens/sign_up_screen.dart';
import 'package:goalgenius/utils/colors.dart';
import 'package:goalgenius/utils/constants.dart';
import 'package:goalgenius/utils/theme_provider.dart';
import 'package:goalgenius/utils/user_data_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String taskKey = "fetch_shared_prefs_task";
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool isServiceRunning = false; // Flag to track if the service is running

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null && currentUser.email != null) {
    final email = currentUser.email!;

    // Check if subscription expired and downgrade
    await UserDataService().validateAndExpireSubscription(email);

    // Fetch latest user data
    await UserDataService().fetchUserData(email);

    // Only initialize ads for non-premium users
    if (!UserDataService().isPremium) {
      await MobileAds.instance.initialize();
    }
  } else {
    // User is not logged in — optionally show ads
    await MobileAds.instance.initialize();
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: AppInitializer(),
    ),
  );

  // Enable verbose logging for debugging (remove in production)
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // Initialize with your OneSignal App ID
  OneSignal.initialize(oneSignalAppID);
  // Use this method to prompt for push notifications.
  // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission.
  OneSignal.Notifications.requestPermission(false);
}

class MyApp extends StatefulWidget {
  final bool isFirstLaunch;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key, required this.isFirstLaunch});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goal Genius',
      themeMode:
          Provider.of<ThemeProvider>(context).isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
      navigatorKey: MyApp.navigatorKey,
      // 👇 Apply SafeArea globally using the builder
      builder: (context, child) {
        return SafeArea(child: child ?? const SizedBox.shrink());
      },
      // Light Theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: lightColorScheme.surface,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightColorScheme.primary,
            foregroundColor: lightColorScheme.surface,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(double.infinity, 48),
            //textStyle: TextStyle(color: lightColorScheme.surface, fontSize: 16),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: lightColorScheme.primary,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(double.infinity, 48),
            side: BorderSide(color: lightColorScheme.primary),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: lightColorScheme.onSurface,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: lightColorScheme.onSurface),
          filled: true,
          fillColor: lightColorScheme.onSecondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: lightColorScheme.surface),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: lightColorScheme.onSurface),
          ),
        ),

        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: lightColorScheme.onSurface,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: lightColorScheme.onSurface,
          ),
          titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: lightColorScheme.onSurface,
          ),
          bodyLarge: TextStyle(fontSize: 18, color: lightColorScheme.onSurface),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: lightColorScheme.onSurface,
          ),
          bodySmall: TextStyle(fontSize: 14, color: lightColorScheme.onSurface),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.surface,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: lightColorScheme.onSurface,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: lightColorScheme.onSurface, size: 24),
        ),

        cardTheme: CardTheme(
          color: lightColorScheme.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          shadowColor: lightColorScheme.onSecondary,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: lightColorScheme.surface,
          selectedItemColor: lightColorScheme.primary,
          unselectedItemColor: lightColorScheme.onSurface,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkColorScheme.surface,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkColorScheme.primary,
            foregroundColor: lightColorScheme.surface,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(double.infinity, 48),
            textStyle: TextStyle(color: darkColorScheme.surface, fontSize: 16),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: darkColorScheme.primary,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(double.infinity, 48),
            side: BorderSide(color: darkColorScheme.primary),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: darkColorScheme.onSurface,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: darkColorScheme.onSurface),
          filled: true,
          fillColor: darkColorScheme.onSecondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: darkColorScheme.surface),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: darkColorScheme.onSurface),
          ),
        ),

        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: darkColorScheme.onSurface,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: darkColorScheme.onSurface,
          ),
          titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: darkColorScheme.onSurface,
          ),
          bodyLarge: TextStyle(fontSize: 18, color: darkColorScheme.onSurface),
          bodyMedium: TextStyle(fontSize: 16, color: darkColorScheme.onSurface),
          bodySmall: TextStyle(fontSize: 14, color: darkColorScheme.onSurface),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.surface,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: darkColorScheme.onSurface,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: darkColorScheme.onSurface),
        ),

        cardTheme: CardTheme(
          color: darkColorScheme.onSecondary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          shadowColor: darkColorScheme.onSecondary,
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: darkColorScheme.surface,
          selectedItemColor: darkColorScheme.primary,
          unselectedItemColor: darkColorScheme.onSurface,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
        ),

        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.white, // Background color of the sheet
          elevation: 8.0, // Shadow effect
          modalBackgroundColor:
              Colors.grey[200], // Background color for modal bottom sheets
          modalElevation: 10.0, // Elevation for modal sheets
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ), // Rounded corners
          ),
          clipBehavior: Clip.antiAlias, // Ensures smooth clipping
          shadowColor: Colors.black54, // Shadow color
        ),

        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),

      initialRoute:
          widget.isFirstLaunch ? '/main' : '/main', // Dynamic initial route

      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/':
            page = OnboardingScreen();
            break;
          case '/login':
            page = SignInScreen();
            break;
          case '/register':
            page = SignUpScreen();
            break;
          case '/main':
            page = BottomNavScreen();
            break;
          case '/plans':
            page = PaymentPage();
            break;
          default:
            page = OnboardingScreen();
        }

        return MaterialPageRoute(builder: (context) => page);
      },
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  Future<bool> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstLaunch = prefs.getBool('firstLaunch') ?? true;
    if (firstLaunch) {
      await prefs.setBool('firstLaunch', false);
    }
    return firstLaunch;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkFirstLaunch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return MyApp(isFirstLaunch: snapshot.data!);
      },
    );
  }
}
