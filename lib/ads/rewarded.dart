import 'package:goalgenius/utils/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class RewardedAdHelper {
  RewardedAd? _rewardedAd;
  static int _retryAttempt = 0;
  bool _rewardEarned = false;

  void loadAd() {
    RewardedAd.load(
      adUnitId: rewardedId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _retryAttempt = 0;
        },
        onAdFailedToLoad: (error) {
          _retryAttempt++;
          final int delay = (2 ^ _retryAttempt).clamp(1, 64);
          Future.delayed(Duration(seconds: delay), loadAd);
        },
      ),
    );
  }

  void showAd({
    required BuildContext context,
    required VoidCallback onRewardEarned,
  }) {
    if (_rewardedAd != null) {
      _rewardEarned = false;

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadAd();

          if (_rewardEarned) {
            onRewardEarned(); // Only continue if reward was earned
          } else {
            _showMustWatchDialog(context);
          }
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadAd();
          _showErrorDialog(context);
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          _rewardEarned = true;
        },
      );

      _rewardedAd = null;
    } else {
      _showErrorDialog(context);
    }
  }

  void _showMustWatchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Watch Ad to Continue"),
            content: Text(
              "You must watch the full ad and earn the reward to proceed.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  loadAd(); // Try loading again
                },
                child: Text("Retry"),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Ad Not Available"),
            content: Text("Please try again later."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }
}
