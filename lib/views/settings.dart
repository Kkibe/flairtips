import 'package:flairtips/utils/api_service.dart';
import 'package:flairtips/utils/user_provider.dart';
import 'package:flairtips/widgets/faded_divider.dart';
import 'package:flutter/material.dart';
import 'package:flairtips/utils/constants.dart';
import 'package:flairtips/utils/url_manager.dart';
import 'package:flairtips/widgets/social_icons.dart';
import 'package:flairtips/utils/theme_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notificationsEnabled = false;
  String? globalPackageName;

  @override
  void initState() async {
    super.initState();
    _loadPreferences();
    final info = await PackageInfo.fromPlatform();
    globalPackageName = info.packageName;
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  Future<void> _setNotificationPreference(bool value) async {
    if (_notificationsEnabled == value) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = value;
    });
    await prefs.setBool('notificationsEnabled', value);
    String message = value ? 'Notifications Enabled' : 'Notifications Disabled';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final user = userProvider.user;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.all(4.0),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                color: Colors.grey, // Grey border
                width: .5, // Border width
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              title: Text(
                'Notifications',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              trailing: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Switch(
                  key: ValueKey<bool>(_notificationsEnabled),
                  value: _notificationsEnabled,
                  onChanged: (value) => _setNotificationPreference(value),
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(4.0),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                color: Colors.grey, // Grey border
                width: .5, // Border width
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              title: Text(
                'Dark Mode',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              trailing: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Switch(
                  key: ValueKey(themeProvider.isDarkMode),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value ? 'Dark Mode Enabled' : 'Light Mode Enabled',
                        ),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SettingsItem(
            title: 'Privacy Policy',
            url: privacyUrl,
            icon: Icon(Icons.privacy_tip),
          ),
          SettingsItem(
            title: 'Rate Us',
            url:
                'https://play.google.com/store/apps/details?id=$globalPackageName',
            icon: Icon(Icons.stars_rounded),
          ),
          SizedBox(height: 4),
          Column(
            children: [
              SizedBox(height: 8),
              FadedDivider(
                color: Colors.grey,
                thickness: 1,
                height: 1,
                fadeWidth: 40,
              ),
              SizedBox(height: 8),
              Card(
                margin: EdgeInsets.all(4.0),
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                    color: Colors.grey, // Grey border
                    width: .5, // Border width
                  ),
                ),
                child: InkWell(
                  onTap:
                      () => {
                        user != null
                            ? userProvider.logout()
                            : Navigator.pushNamed(context, "/login"),
                      },
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    title: Text(
                      user != null ? "Log Out" : "Sign In",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        user != null
                            ? Icons.logout_rounded
                            : Icons.login_rounded,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
          Text(
            "FAQs",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                final faq = faqs[index];
                return CustomFAQ(
                  question: faq['question']!,
                  answer: faq['answer']!,
                );
              },
            ),
          ),
          SocialIcons(),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String url;
  final Icon icon;
  const SettingsItem({
    super.key,
    required this.title,
    required this.url,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.0),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey, // Grey border
          width: .5, // Border width
        ),
      ),
      child: InkWell(
        onTap: () {
          openLink(url);
        },
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          title: Row(
            children: [
              icon,
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          trailing: Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.arrow_forward_ios_rounded, size: 28),
          ),
        ),
      ),
    );
  }
}

class CustomFAQ extends StatefulWidget {
  final String question;
  final String answer;

  const CustomFAQ({super.key, required this.question, required this.answer});

  @override
  CustomFAQState createState() => CustomFAQState();
}

class CustomFAQState extends State<CustomFAQ> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.0),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey, // Grey border
          width: .5, // Border width
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() => isExpanded = !isExpanded);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(widget.question),
              trailing: Icon(
                isExpanded
                    ? Icons.add_box_rounded
                    : Icons.indeterminate_check_box_rounded,
              ),
              onTap: () => setState(() => isExpanded = !isExpanded),
            ),
            AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Text(widget.answer, textAlign: TextAlign.start),
              ),
              crossFadeState:
                  isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}
