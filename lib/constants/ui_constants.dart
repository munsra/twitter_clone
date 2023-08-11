import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../features/tweet/widgets/tweet_list.dart';
import '../theme/pallete.dart';
import 'assets_constants.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        colorFilter: const ColorFilter.mode(Pallete.blueColor, BlendMode.srcIn),
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    TweetList(),
    Text("Search Screen"),
    Text("Notification Screen")
  ];
}
