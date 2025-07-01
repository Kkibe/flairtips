import 'package:flutter/material.dart';
import 'package:flairtips/models/tip.dart';
import 'package:flairtips/widgets/custom_appbar.dart';
import 'package:flairtips/widgets/faded_divider.dart';
import 'package:flairtips/widgets/social_icons.dart';

class TipDetail extends StatefulWidget {
  final Tip tip;
  const TipDetail({super.key, required this.tip});

  @override
  State<TipDetail> createState() => _TipDetailState();
}

class _TipDetailState extends State<TipDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(tip: widget.tip),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 12),
                FadedDivider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 1,
                  fadeWidth: 40,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    widget.tip.bestTip != ""
                        ? Expanded(
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  "Best Tip",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 6),
                              Card(
                                margin: EdgeInsets.all(4.0),
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: BorderSide(
                                    color: Colors.grey,
                                    width: .5,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  child: Center(
                                    child: Text(
                                      widget.tip.bestTip,
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
                        )
                        : SizedBox.shrink(),
                    Expanded(
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "Tip",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Center(
                            child: Card(
                              margin: EdgeInsets.all(4.0),
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: BorderSide(color: Colors.grey, width: .5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Center(
                                  child: Text(
                                    widget.tip.tip,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                FadedDivider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 1,
                  fadeWidth: 40,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Center(child: Text("1")),
                          SizedBox(height: 6),
                          Center(
                            child: Card(
                              margin: EdgeInsets.all(4.0),
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: BorderSide(color: Colors.grey, width: .5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Center(
                                  child: Text(
                                    widget.tip.homeOdd,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Center(child: Text("x")),
                          SizedBox(height: 6),
                          Center(
                            child: Card(
                              margin: EdgeInsets.all(4.0),
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: BorderSide(color: Colors.grey, width: .5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Center(
                                  child: Text(
                                    widget.tip.drawOdd,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Center(child: Text("2")),
                          SizedBox(height: 6),
                          Center(
                            child: Card(
                              margin: EdgeInsets.all(4.0),
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: BorderSide(color: Colors.grey, width: .5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Center(
                                  child: Text(
                                    widget.tip.awayOdd,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                FadedDivider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 1,
                  fadeWidth: 40,
                ),
                SizedBox(height: 12),
                widget.tip.premium
                    ? Text(
                      "👑 Premium Tip",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : SizedBox.shrink(),
                SizedBox(height: 4),
              ],
            ),
          ),
          SocialIcons(),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
