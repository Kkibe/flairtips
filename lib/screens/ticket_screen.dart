import 'package:flutter/material.dart';
import 'package:goalgenius/ads/banner.dart';
import 'package:goalgenius/ads/rewarded.dart';
import 'package:goalgenius/screens/navigation_util.dart';
import 'package:goalgenius/widgets/custom_filled_button.dart';
import 'package:goalgenius/widgets/custom_image.dart';
import 'package:goalgenius/widgets/custom_outlined_button.dart';
import 'package:goalgenius/widgets/faded_divider.dart';
import 'package:goalgenius/widgets/social_icons.dart';

class TicketScreen extends StatefulWidget {
  final bool isPremium;
  final int games;
  final double odds;

  const TicketScreen({
    required this.isPremium,
    required this.games,
    required this.odds,
    super.key,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final RewardedAdHelper rewardedAdHelper = RewardedAdHelper();

  @override
  void initState() {
    super.initState();
    rewardedAdHelper.loadAd();
  }

  @override
  Widget build(BuildContext context) {
    String formattedOdds = widget.odds.toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text("Ticket"),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {})],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImage(
                        imageString: "assets/logo.png",
                        width: 32,
                        height: 32,
                      ),
                      FadedDivider(
                        color: Colors.grey,
                        thickness: 1,
                        height: 1,
                        fadeWidth: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.isPremium
                                    ? "👑 VIP TICKET💎"
                                    : "⚽ FREE SELECTIONS",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "📦${widget.games} matches",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "🚀${formattedOdds} total odds",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 41.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              color:
                                  Colors.red, // Set the background color to red
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ), // Set the border radius
                            ),
                            child: Center(
                              child: Text(
                                "TBD",
                                style: TextStyle(
                                  color:
                                      Colors
                                          .white, // Text color to contrast with the red background
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0, // Adjust font size if needed
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      FadedDivider(
                        color: Colors.grey,
                        thickness: 1,
                        height: 1,
                        fadeWidth: 40,
                      ),
                      widget.isPremium
                          ? CustomFilledButton(
                            text: "Unlock With VIP Membership",
                            onPressed: () => {conditionalNavigation(context)},
                          )
                          : Column(
                            children: [
                              CustomOutlinedButton(
                                text: "Unlock With Free Ads",
                                onPressed: () {
                                  rewardedAdHelper.showAd(
                                    context: context,
                                    onRewardEarned: () {
                                      // Handle the reward logic here
                                      print("Reward earned!");
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 8),
                              CustomFilledButton(
                                text: "Unlock With VIP Membership",
                                onPressed:
                                    () => {conditionalNavigation(context)},
                              ),
                            ],
                          ),

                      FadedDivider(
                        color: Colors.grey,
                        thickness: 1,
                        height: 1,
                        fadeWidth: 40,
                      ),
                      Text(
                        "Date: 09.04.2025",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SocialIcons(),
            const SizedBox(height: 12),
            Text(
              "Everyone is free to choose their match picks! To increase your odds, consider selecting a higher risk level. For the latest updates, live sessions, and expert tips, be sure to follow us on social media!",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 12),
            BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}
