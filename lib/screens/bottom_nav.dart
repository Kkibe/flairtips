import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goalgenius/ads/app_open.dart';
import 'package:goalgenius/ads/banner.dart';
import 'package:goalgenius/views/help.dart';
import 'package:goalgenius/views/settings.dart';
import 'package:goalgenius/views/tickets.dart';
import 'package:goalgenius/views/tips.dart';
import 'package:goalgenius/views/vip.dart';
import 'package:goalgenius/widgets/custom_image.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  BottomNavScreenState createState() => BottomNavScreenState();
}

class BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [Tips(), Tickets(), Vip(), Help(), Settings()];
    AppOpenAdManager.loadAd();
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents the default pop behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool exitApp = await showExitConfirmationDialog(context);
          if (exitApp) {
            if (Platform.isAndroid) {
              SystemNavigator.pop(); // Exit on Android
            } else if (Platform.isIOS) {
              exit(0); // Force exit on iOS (Not recommended)
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: CustomImage(
            imageString: "assets/logo.png",
            width: 20,
            height: 20,
          ),
          title: Text(returnTitle(_selectedIndex)),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          ],
        ),
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
                child: child,
              ),
            );
          },
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BannerAdWidget(),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Stack(
                children: [
                  // Shadow behind the nav bar
                  Container(
                    height:
                        60, // adjust based on your BottomNavigationBar height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: ColorScheme.of(
                            context,
                          ).primary.withOpacity(0.5),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: ColorScheme.of(context).surface,
                      elevation: 0,
                      currentIndex: _selectedIndex,
                      onTap: _onItemTapped,
                      selectedFontSize: 12,
                      unselectedFontSize: 11,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.tips_and_updates_outlined, size: 24),
                          activeIcon: Icon(
                            Icons.tips_and_updates_rounded,
                            size: 26,
                          ),
                          label: 'Tips',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.book_outlined, size: 24),
                          activeIcon: Icon(Icons.book_rounded, size: 26),
                          label: 'Tickets',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.workspace_premium_outlined,
                            size: 24,
                          ),
                          activeIcon: Icon(
                            Icons.workspace_premium_rounded,
                            size: 26,
                          ),
                          label: 'VIP',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.help_outline, size: 24),
                          activeIcon: Icon(Icons.help, size: 26),
                          label: 'Help',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.settings_outlined, size: 24),
                          activeIcon: Icon(Icons.settings, size: 26),
                          label: 'Settings',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String returnTitle(int index) {
  String title;

  switch (index) {
    case 1:
      title = "Tickets";
      break;
    case 2:
      title = "VIP";
      break;
    case 3:
      title = "Help";
      break;
    case 4:
      title = "Settings";
      break;
    default:
      title = "Tips";
  }

  return title;
}

/// Function to show exit confirmation dialog
Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return await showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: Text("Exit App"),
              content: Text("Are you sure you want to exit?"),
              actions: [
                TextButton(
                  onPressed:
                      () => {
                        Navigator.of(context).pop(false),
                        AppOpenAdManager.showAdIfAvailable(),
                      },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Exit"),
                ),
              ],
            ),
      ) ??
      false;
}
