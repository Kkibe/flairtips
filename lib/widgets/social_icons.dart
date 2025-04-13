import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goalgenius/utils/constants.dart';
import 'package:goalgenius/utils/url_manager.dart';

import '../utils/colors.dart';

class SocialIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          SizedBox(height: 8),
          Text("Get in touch"),
          SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SocialItem(
                title: 'Facebook',
                url: facebookUrl,
                icon: Icon(FontAwesomeIcons.facebook),
              ),

              SocialItem(
                title: 'Telegram,',
                url: telegramUrl,
                icon: Icon(FontAwesomeIcons.telegram),
              ),

              SocialItem(
                title: 'Whatsapp',
                url: whatsappUrl,
                icon: Icon(FontAwesomeIcons.whatsapp),
              ),

              SocialItem(
                title: 'X',
                url: xtwitterUrl,
                icon: Icon(FontAwesomeIcons.xTwitter),
              ),

              SocialItem(
                title: 'Instagram',
                url: instagramUrl,
                icon: Icon(FontAwesomeIcons.instagram),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SocialItem extends StatelessWidget {
  final String title;
  final String url;
  final Icon icon;
  const SocialItem({
    super.key,
    required this.title,
    required this.url,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        openLink(url);
      },
      child: Container(
        //width: 16,
        //height: 16,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: white6Percent,
          borderRadius: BorderRadius.circular(100),
        ),

        padding: EdgeInsets.all(4),
        child: icon,
      ),
    );
  }
}
