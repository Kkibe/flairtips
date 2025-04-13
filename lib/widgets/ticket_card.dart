import 'package:flutter/material.dart';
import 'package:goalgenius/screens/ticket_screen.dart';
import 'package:goalgenius/widgets/faded_divider.dart';

class TicketCard extends StatelessWidget {
  final bool isPremium;
  final int games;
  final double odds;

  const TicketCard({
    required this.isPremium,
    required this.games,
    required this.odds,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //final themeProvider = Provider.of<ThemeProvider>(context);
    String formattedOdds = odds.toStringAsFixed(2);
    return Card(
      margin: EdgeInsets.all(4), // Remove spacing between cards
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey, // Grey border
          width: .5, // Border width
        ),
      ),

      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.transparent, Colors.purpleAccent.withOpacity(0.2)],
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => TicketScreen(
                      isPremium: isPremium,
                      games: games,
                      odds: odds,
                    ),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // First Row (Competition and Date)
              Padding(
                padding: EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isPremium ? "👑 VIP TICKET💎" : "⚽ FREE SELECTIONS",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(
                      width: 60,
                      height: 35,
                      child: Card(
                        margin: EdgeInsets.all(4.0),
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(color: Colors.grey, width: .5),
                        ),

                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "TBD",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              FadedDivider(fadeWidth: 40),

              // Second Row (Home Team and Score)
              Padding(
                padding: EdgeInsets.all(6.0), // Adjust padding
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "📦$games matches",
                            overflow:
                                TextOverflow.ellipsis, // Prevents overflow
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "🚀$formattedOdds total odds",
                            overflow:
                                TextOverflow.ellipsis, // Prevents overflow
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.arrow_forward_ios_rounded, size: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
