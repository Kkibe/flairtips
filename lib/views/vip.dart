import 'package:flutter/material.dart';
import 'package:goalgenius/screens/navigation_util.dart';
import 'package:goalgenius/widgets/custom_filled_button.dart';
import 'package:goalgenius/widgets/social_icons.dart';

class Item {
  final String title;
  final String description;
  final IconData icon;

  Item({required this.title, required this.description, required this.icon});
}

class Vip extends StatefulWidget {
  const Vip({super.key});

  @override
  State<Vip> createState() => _VipState();
}

class _VipState extends State<Vip> {
  final List<Item> items = [
    Item(
      title: "Exclusive Access To Premium Tips",
      description: "Get expert tips for higher chances of winning.",
      icon: Icons.ac_unit_rounded,
    ),
    Item(
      title: "Higher Accuracy and Success Rates",
      description: "Enjoy more precise predictions and better outcomes.",
      icon: Icons.arrow_outward_rounded,
    ),
    Item(
      title: "Increased Odds and Value Bets",
      description: "Access enhanced odds and exclusive high-value bets.",
      icon: Icons.data_exploration_outlined,
    ),
    Item(
      title: "Ads-Free Experience",
      description: "Enjoy seamless, ad-free tips for uninterrupted focus.",
      icon: Icons.ads_click_outlined,
    ),
    Item(
      title: "Priority Customer Support",
      description: "Receive fast, dedicated support for all your needs.",
      icon: Icons.diamond_rounded,
    ),
    Item(
      title: "Special Notification Alerts",
      description: "Get timely alerts for exclusive tips and offers.",
      icon: Icons.map,
    ),
  ];

  PageController _pageController = PageController();
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorScheme.of(context).primary,
              borderRadius: BorderRadius.circular(100),
            ),

            padding: EdgeInsets.all(4),
            child: Icon(Icons.workspace_premium_rounded, size: 24),
          ),
          SizedBox(height: 4),
          Text(
            "Join the VIP Community",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "Enjoy the exclusive benefits!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController, // Attach controller
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey, // Grey border color
                      width: .5, // Border width
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, size: 40),
                      SizedBox(height: 10),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        item.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              items.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage.round() == index ? 12 : 8,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      _currentPage.round() == index
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          CustomFilledButton(
            text: "Upgrade To VIP",
            onPressed: () => {conditionalNavigation(context)},
          ),
          SizedBox(height: 12),
          SocialIcons(),
        ],
      ),
    );
  }
}
