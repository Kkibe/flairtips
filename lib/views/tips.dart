import 'package:flairtips/models/tip.dart';
import 'package:flairtips/utils/api_service.dart';
import 'package:flairtips/widgets/ScrollDate.dart';
import 'package:flairtips/widgets/league_card.dart';
import 'package:flairtips/widgets/match_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tips extends StatefulWidget {
  const Tips({super.key});

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  String selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _ScrollDateKey = GlobalKey();

  final List<Tip> _tips = [];
  bool _isFetchingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTips();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !_isFetchingMore &&
          _hasMore) {
        _loadMoreTips();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchTips({bool reset = true}) {
    if (reset) {
      _tips.clear();
      _currentPage = 1;
      _hasMore = true;
      isLoading = true;
    }

    getTips(false, selectedDate, _currentPage)
        .then((newTips) {
          setState(() {
            isLoading = false;
            _tips.addAll(newTips);
            _hasMore = newTips.isNotEmpty;
            _isFetchingMore = false;
          });
        })
        .catchError((error) {
          setState(() {
            isLoading = false;
            _isFetchingMore = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        });
  }

  void _loadMoreTips() {
    if (_isFetchingMore || !_hasMore) return;

    setState(() => _isFetchingMore = true);
    _currentPage++;
    _fetchTips(reset: false);
  }

  @override
  Widget build(BuildContext context) {
    final uniqueTips =
        _tips.toSet().toList(); // quick Dart deduplication by object
    final groupedTips = _groupTipsByLeagueName(_deduplicateTips(uniqueTips));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: _getAppBarSize(),
        child: AppBar(
          bottom: PreferredSize(
            preferredSize: _getAppBarSize(),
            child: ScrollDate(
              key: _ScrollDateKey,
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
              : groupedTips.isEmpty
              ? const Center(child: Text('No tips available for this date'))
              : ListView(
                controller: _scrollController,
                children: [
                  ...groupedTips.entries.map((entry) {
                    final leagueName = entry.key;
                    final tipsInLeague = entry.value;
                    final logoTip = tipsInLeague.firstWhere(
                      (tip) => tip.leagueLogo.isNotEmpty,
                      orElse: () => tipsInLeague.first,
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LeagueCard(
                            countryName: logoTip.country,
                            leagueName: leagueName,
                            leagueLogo: logoTip.leagueLogo,
                          ),
                          ...tipsInLeague.map((tip) => MatchCard(tip: tip)),
                        ],
                      ),
                    );
                  }),
                  if (_isFetchingMore)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
    );
  }

  // Update this method if needed
  Map<String, List<Tip>> _groupTipsByLeagueName(List<Tip> tips) {
    final Map<String, List<Tip>> grouped = {};
    for (var tip in tips) {
      grouped.putIfAbsent(tip.leagueName, () => []).add(tip);
    }
    return grouped;
  }

  List<Tip> _deduplicateTips(List<Tip> tips) {
    final seenGameIds = <String>{};
    final uniqueTips = <Tip>[];

    for (final tip in tips) {
      if (!seenGameIds.contains(tip.id)) {
        seenGameIds.add(tip.id);
        uniqueTips.add(tip);
      }
    }

    return uniqueTips;
  }

  Size _getAppBarSize() {
    final RenderBox? renderBox =
        _ScrollDateKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size ?? const Size.fromHeight(52);
  }
}
