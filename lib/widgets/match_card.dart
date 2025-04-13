import 'package:flutter/material.dart';
import 'package:goalgenius/models/tip.dart';
import 'package:goalgenius/screens/tip_detail.dart';
import 'package:goalgenius/utils/theme_provider.dart';
import 'package:goalgenius/widgets/faded_divider.dart';
import 'package:provider/provider.dart';

class MatchCard extends StatelessWidget {
  final Tip tip;

  const MatchCard({required this.tip, super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      margin: EdgeInsets.all(4), // Remove spacing between cards
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: getGradientColors(tip.won, themeProvider.isDarkMode),
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TipDetail(tip: tip)),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 6.0), // Adjust padding
                child: Row(
                  children: [
                    // Leading: Time Card
                    Container(
                      constraints: const BoxConstraints(minHeight: 60),
                      // Ensure a reasonable height
                      alignment:
                          Alignment.center, // Center time text vertically
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ), // Adjust padding
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: getTimeGradientColors(tip.won),
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(
                            4,
                          ), // Adjust the radius as needed
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tip.time,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 10.0,
                            ),
                          ),
                          Text(
                            "@${tip.odd}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                              color: ColorScheme.of(context).primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8), // Spacing

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*CustomImage(
                              imageString:
                                  "https://cdn.pixabay.com/photo/2013/07/13/10/51/football-157930_1280.png",
                              height: 12,
                              width: 12,
                            ),*/
                              Flexible(
                                child: Text(
                                  tip.home,
                                  overflow:
                                      TextOverflow
                                          .ellipsis, // Prevents overflow
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              tip.status == "finished"
                                  ? Text(
                                    tip.results.split("-").first,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                  : SizedBox.shrink(),
                            ],
                          ),
                          SizedBox(height: 4),
                          FadedDivider(fadeWidth: 60),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*CustomImage(
                              imageString:
                                  "https://cdn.pixabay.com/photo/2013/07/13/10/51/football-157930_1280.png",
                              height: 12,
                              width: 12,
                            ),*/
                              Flexible(
                                child: Text(
                                  tip.away,
                                  overflow:
                                      TextOverflow
                                          .ellipsis, // Prevents overflow
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              tip.status == "finished"
                                  ? Text(
                                    tip.results.split("-").last,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 12),
                    SizedBox(
                      width: tip.status == "finished" ? 80 : 100,
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
                                tip.status == "finished"
                                    ? tip.pick
                                    : "VIEW TIP",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 4),

                              tip.status == "finished"
                                  ? getTipStatusIcon(tip.won)
                                  : Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 12,
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

Widget getTipStatusIcon(String status) {
  if (status == "won") {
    return Icon(Icons.check_circle_outline, size: 12, color: Colors.green);
  } else if (status == "lost") {
    return Icon(Icons.cancel_outlined, size: 12, color: Colors.red);
  } else if (status == "pending") {
    return Icon(Icons.access_time_outlined, size: 12, color: Colors.orange);
  } else {
    return SizedBox.shrink(); // default fallback
  }
}

List<Color> getGradientColors(String wonStatus, bool isDarkMode) {
  switch (wonStatus) {
    case "won":
      return [
        Colors.green.withOpacity(0.2),
        isDarkMode ? Colors.transparent : Colors.white.withOpacity(0.2),
        Colors.purpleAccent.withOpacity(0.2),
      ];
    case "lost":
      return [
        Colors.red.withOpacity(0.2),
        isDarkMode ? Colors.transparent : Colors.white.withOpacity(0.2),
        Colors.purpleAccent.withOpacity(0.2),
      ];
    case "pending":
    default:
      return [
        Colors.blueAccent.withOpacity(0.2),
        isDarkMode ? Colors.transparent : Colors.white.withOpacity(0.2),
        Colors.purpleAccent.withOpacity(0.2),
      ];
  }
}

List<Color> getTimeGradientColors(String wonStatus) {
  switch (wonStatus) {
    case "won":
      return [
        Colors.green.withOpacity(0.2),
        //Colors.transparent,
        Colors.greenAccent.withOpacity(0.2),
      ];
    case "lost":
      return [
        Colors.red.withOpacity(0.2),
        //Colors.transparent,
        Colors.greenAccent.withOpacity(0.2),
      ];
    case "pending":
    default:
      return [
        Colors.blueAccent.withOpacity(0.2),
        //Colors.transparent,
        Colors.greenAccent.withOpacity(0.2),
      ];
  }
}
