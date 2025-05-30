import 'package:flairtips/utils/user_provider.dart';
import 'package:flairtips/views/vip_tips.dart';
import 'package:flairtips/widgets/custom_filled_button.dart';
import 'package:flairtips/widgets/custom_outlined_button.dart';
import 'package:flairtips/widgets/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      title: "Priority Customer Support",
      description: "Receive fast, dedicated support for all your needs.",
      icon: Icons.diamond_rounded,
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
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final user = userProvider.user;
    final isUserPremium = user?.isPremium ?? false;
    return isUserPremium
        ? VipTips()
        : Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
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
              SizedBox(height: 12),

              user != null
                  ? Column(
                    children: [
                      PlanCard(charge: 50.00, billing: "Daily", planId: 1),
                      SizedBox(height: 4),
                      PlanCard(charge: 300.00, billing: "Weekly", planId: 2),
                      SizedBox(height: 4),
                      PlanCard(charge: 1000.00, billing: "Monthly", planId: 3),
                    ],
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomFilledButton(
                        text: "Sign In",
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                      ),
                      SizedBox(height: 16),
                      CustomOutlinedButton(
                        text: 'Create account',
                        onPressed: () {
                          Navigator.pushNamed(context, "/register");
                        },
                      ),
                    ],
                  ),
            ],
          ),
        );
  }
}
