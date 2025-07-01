import 'package:flairtips/models/tip.dart';
import 'package:flairtips/utils/api_service.dart';
import 'package:flairtips/widgets/ScrollDate.dart';
import 'package:flairtips/widgets/league_card.dart';
import 'package:flairtips/widgets/match_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VipTipsScreen extends StatefulWidget {
  const VipTipsScreen({super.key});

  @override
  State<VipTipsScreen> createState() => _VipTipsScreenState();
}

class _VipTipsScreenState extends State<VipTipsScreen> {
  String selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final GlobalKey _dateScrollWidgetKey = GlobalKey();
  late Future<List<Tip>> _tipsFuture;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTips();
  }

  void _fetchTips() {
    setState(() {
      isLoading = true;
      _tipsFuture = getTips(true, selectedDate, 1);
    });

    _tipsFuture
        .then((_) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        })
        .catchError((error) async {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
            // Optionally show an error
            if (error is UnauthorizedException) {
              /*final userProvider = Provider.of<UserProvider>(
                context,
                listen: false,
              );
              await userProvider.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }*/
            } else {
              // Handle other errors if needed
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error.toString())));
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: _getAppBarSize(),
        child: AppBar(
          bottom: PreferredSize(
            preferredSize: _getAppBarSize(),
            child: ScrollDate(
              key: _dateScrollWidgetKey,
              onDateSelected: (date) {
                final parsed = DateFormat('yyyy-MM-dd').parse(date);
                setState(() {
                  selectedDate = DateFormat('dd-MM-yyyy').format(parsed);
                });
                _fetchTips();
              },
            ),
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<List<Tip>>(
                future: _tipsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }

                  final tips = snapshot.data ?? [];

                  final groupedTips = _groupTipsByLeagueName(tips);

                  return groupedTips.isEmpty
                      ? const Center(
                        child: Text('No tips available for this date'),
                      )
                      : ListView(
                        children:
                            groupedTips.entries.map((entry) {
                              final leagueName = entry.key;
                              final tipsInLeague = entry.value;
                              final logoTip = tipsInLeague.firstWhere(
                                (tip) => tip.leagueLogo.isNotEmpty,
                                orElse: () => tipsInLeague.first,
                              );
                              final countryName = logoTip.country;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 12.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: LeagueCard(
                                        countryName: countryName,
                                        leagueName: leagueName,
                                        leagueLogo: logoTip.leagueLogo,
                                      ),
                                    ),
                                    ...tipsInLeague.map(
                                      (tip) => MatchCard(tip: tip),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      );
                },
              ),
    );
  }

  Map<String, List<Tip>> _groupTipsByLeagueName(List<Tip> tips) {
    final Map<String, List<Tip>> grouped = {};
    for (var tip in tips) {
      final league = tip.leagueName;
      if (!grouped.containsKey(league)) {
        grouped[league] = [];
      }
      grouped[league]!.add(tip);
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
      return const Size.fromHeight(52);
    }
  }
}
