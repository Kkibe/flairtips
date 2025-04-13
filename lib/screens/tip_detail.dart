import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goalgenius/ads/banner.dart';
import 'package:goalgenius/ads/rewarded.dart';
import 'package:goalgenius/models/tip.dart';
import 'package:goalgenius/screens/navigation_util.dart';
import 'package:goalgenius/utils/user_data_service.dart';
import 'package:goalgenius/widgets/custom_appbar.dart';
import 'package:goalgenius/widgets/custom_filled_button.dart';
import 'package:goalgenius/widgets/custom_outlined_button.dart';
import 'package:goalgenius/widgets/faded_divider.dart';
import 'package:goalgenius/widgets/social_icons.dart';

class TipDetail extends StatefulWidget {
  final Tip tip;
  const TipDetail({super.key, required this.tip});

  @override
  State<TipDetail> createState() => _TipDetailState();
}

class _TipDetailState extends State<TipDetail> {
  final RewardedAdHelper rewardedAdHelper = RewardedAdHelper();
  bool canView = false;
  bool isPremium = false;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    rewardedAdHelper.loadAd();

    // Default: allow viewing if tip is finished
    canView = widget.tip.status == "finished";

    _initUser(); // async logic here
  }

  Future<void> _initUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email != null) {
      await UserDataService().fetchUserData(user.email!);

      if (!mounted) return;

      setState(() {
        // Update canView based on premium status
        canView = UserDataService().isPremium;
        isPremium = UserDataService().isPremium;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(tip: widget.tip, canView: canView),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          !isPremium
              ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child:
                    widget.tip.status == "pending"
                        ? Column(
                          spacing: 12,
                          children: [
                            CustomOutlinedButton(
                              text: "Unlock With Free Ads",
                              onPressed: () {
                                rewardedAdHelper.showAd(
                                  context: context,
                                  onRewardEarned: () {
                                    setState(() {
                                      canView = true;
                                    });
                                  },
                                );
                              },
                            ),
                            FadedDivider(
                              color: Colors.purpleAccent,
                              thickness: 1,
                              height: 1,
                              fadeWidth: 60,
                            ),
                            CustomFilledButton(
                              text: "Unlock With VIP Membership",
                              onPressed: () => {conditionalNavigation(context)},
                            ),
                          ],
                        )
                        : CustomFilledButton(
                          text: "Join VIP Membership",
                          onPressed: () {
                            conditionalNavigation(context);
                          },
                        ),
              )
              : SizedBox.shrink(),

          SocialIcons(),
          BannerAdWidget(),
        ],
      ),
    );
  }
}
