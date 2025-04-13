import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goalgenius/ads/interstitial.dart';
import 'package:goalgenius/models/tip.dart';
import 'package:goalgenius/widgets/DateScrollWidget.dart';
import 'package:goalgenius/widgets/match_card.dart';
import 'package:intl/intl.dart';

class Tips extends StatefulWidget {
  const Tips({super.key});

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
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
        stream:
            tipsRef
                .where('date', isEqualTo: firestoreDate)
                //.orderBy('time')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final tips =
              snapshot.data!.docs.map((doc) => Tip.fromFirestore(doc)).toList();

          final groupedTips = _groupTipsByType(tips);

          return groupedTips.isEmpty
              ? const Center(child: Text('No tips available for this date'))
              : ListView(
                children:
                    groupedTips.entries.map((entry) {
                      final type = entry.key;
                      final tipsOfType = entry.value;
                      const Map<String, String> typeLabels = {
                        '1X2': 'WDW (1X2)',
                        'CS': 'Goals (CS)',
                        'GG': 'BTTS (GG/NG)',
                        'OV_UN': 'TOTAL (OV/UN)',
                        'DC': 'DC 1X2',
                      };

                      final displayType = typeLabels[type] ?? type;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Text(
                                displayType,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...tipsOfType.map((tip) => MatchCard(tip: tip)),
                          ],
                        ),
                      );
                    }).toList(),
              );
        },
      ),
    );
  }

  Map<String, List<Tip>> _groupTipsByType(List<Tip> tips) {
    Map<String, List<Tip>> grouped = {};
    for (var tip in tips) {
      if (!grouped.containsKey(tip.type)) {
        grouped[tip.type] = [];
      }
      grouped[tip.type]!.add(tip);
    }
    return grouped;
  }

  Size _getAppBarSize() {
    final RenderBox? renderBox =
        _dateScrollWidgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      return Size.fromHeight(size.height);
    } else {
      return Size.fromHeight(52);
    }
  }
}
