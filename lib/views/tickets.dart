import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goalgenius/ads/interstitial.dart';
import 'package:goalgenius/models/tip.dart';
import 'package:goalgenius/widgets/DateScrollWidget.dart';
import 'package:goalgenius/widgets/ticket_card.dart';
import 'package:intl/intl.dart';

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final GlobalKey _dateScrollWidgetKey = GlobalKey();
  final CollectionReference tipsRef = FirebaseFirestore.instance.collection(
    'tips',
  );
  final InterstitialAdHelper interstitialAdHelper = InterstitialAdHelper();

  @override
  void initState() {
    super.initState();
    interstitialAdHelper.loadAd();
  }

  @override
  Widget build(BuildContext context) {
    String firestoreDate = DateFormat(
      'M/d/yyyy',
    ).format(DateTime.parse(selectedDate));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: _getAppBarSize(),
        child: AppBar(
          bottom: PreferredSize(
            preferredSize: _getAppBarSize(),
            child: DateScrollWidget(
              key: _dateScrollWidgetKey,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: tipsRef.where('date', isEqualTo: firestoreDate).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allTips =
              snapshot.data!.docs.map((doc) => Tip.fromFirestore(doc)).toList();

          final premiumTips = allTips.where((tip) => tip.premium).toList();
          final freeTips = allTips.where((tip) => !tip.premium).toList();

          // Multiply the odds for each tip in the list
          double getTotalOdds(List<Tip> tips) =>
              tips.fold(1.0, (product, tip) => product * tip.oddValue);

          int totalPremiumGames = premiumTips.length;
          double totalPremiumOdds = getTotalOdds(premiumTips);

          int totalFreeGames = freeTips.length;
          double totalFreeOdds = getTotalOdds(freeTips);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                (totalPremiumGames == 0 && totalFreeGames == 0)
                    ? const Center(
                      child: Text('No tickets available for this date'),
                    )
                    : Column(
                      children: [
                        if (totalPremiumGames > 0)
                          TicketCard(
                            isPremium: true,
                            games: totalPremiumGames,
                            odds: totalPremiumOdds,
                          ),
                        if (totalPremiumGames > 0 && totalFreeGames > 0)
                          const SizedBox(height: 16),
                        if (totalFreeGames > 0)
                          TicketCard(
                            isPremium: false,
                            games: totalFreeGames,
                            odds: totalFreeOdds,
                          ),
                      ],
                    ),
          );
        },
      ),
    );
  }

  Size _getAppBarSize() {
    final RenderBox? renderBox =
        _dateScrollWidgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      return Size.fromHeight(size.height);
    } else {
      return const Size.fromHeight(52);
    }
  }
}
