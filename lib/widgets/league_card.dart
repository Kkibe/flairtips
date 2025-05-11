import 'package:flairtips/widgets/custom_image.dart';
import 'package:flutter/material.dart';

class LeagueCard extends StatelessWidget {
  final String countryName;
  //final String countryLogo;
  final String leagueName;
  final String leagueLogo;

  LeagueCard({
    required this.countryName,
    //required this.countryLogo,
    required this.leagueName,
    required this.leagueLogo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeagueDetailsScreen(league: league),
          ),
        );*/
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero, // Ensure no extra padding
        dense: true, // Reduces height by tightening spacing
        visualDensity: VisualDensity(
          vertical: -4,
        ), // Further compress vertical space
        /*leading: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.14),
          child: CustomImage(
            imageString: countryLogo,
            width: 16,
            height: 16,
            isCover: true,
          ),
        ),*/
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImage(
              imageString: leagueLogo,
              width: 16,
              height: 16,
              isCover: true,
            ),
            const SizedBox(width: 4),
            Text(
              countryName,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                leagueName,
                overflow: TextOverflow.ellipsis, // Prevents overflow
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
              ),
            ),
          ],
        ),
        //trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
