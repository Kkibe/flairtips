import 'package:flutter/material.dart';
import 'package:flairtips/models/tip.dart';
import 'package:flairtips/widgets/custom_image.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Tip tip;
  final bool canView;
  @override
  final Size preferredSize;

  const CustomAppBar({required this.tip, required this.canView, super.key})
    : preferredSize = const Size.fromHeight(120.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "${tip.date} at ${tip.time}",
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      actions: [
        !tip.isPlayed
            ? Container(
              width: 41.0,
              height: 20.0,
              margin: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.red, // Set the background color to red
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
            )
            : SizedBox.shrink(),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CustomImage(
                        imageString: tip.homeImage ?? "",
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(height: 4),
                      Text(
                        tip.home,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 4.0),
                  Column(
                    children: [
                      Text(
                        tip.isScoreUpdated
                            ? "${tip.homeScore} - ${tip.awayScore}"
                            : "?-?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 100,
                        height: 35,
                        child: Card(
                          margin: EdgeInsets.all(4.0),
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(color: Colors.grey, width: .5),
                          ),
                          child: Center(
                            child: Text(
                              tip.confidence,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 4.0),
                  Column(
                    children: [
                      CustomImage(
                        imageString: tip.awayImage ?? "",
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(height: 4),
                      Text(
                        tip.away,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
