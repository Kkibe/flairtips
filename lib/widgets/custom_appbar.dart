import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:goalgenius/models/tip.dart';
import 'package:goalgenius/utils/colors.dart';
import 'package:goalgenius/widgets/custom_image.dart';

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
      title: Column(
        children: [
          Text(
            tip.date,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            tip.time,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.0), // Adjust spacing as needed
          child: Text(
            tip.odd,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.0,
              color: greenColor,
            ),
          ),
        ),
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
                        imageString:
                            "https://cdn.pixabay.com/photo/2013/07/13/10/51/football-157930_1280.png",
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        tip.results != "" ? tip.results : "?-?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Pick:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                !canView
                                    ? ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                        sigmaX: 5,
                                        sigmaY: 5,
                                      ),
                                      child: Text(
                                        tip.pick,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                    : Text(
                                      tip.pick,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                              ],
                            ) /*Stack(
                              children: [
                                Text(
                                  tip.pick,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                Positioned.fill(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 7,
                                      sigmaY: 7,
                                    ),
                                    child: Container(color: Colors.transparent),
                                  ),
                                ),
                              ],
                            ),*/,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 4.0),
                  Column(
                    children: [
                      CustomImage(
                        imageString:
                            "https://cdn.pixabay.com/photo/2013/07/13/10/51/football-157930_1280.png",
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
