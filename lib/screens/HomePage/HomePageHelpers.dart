import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_social/constants/Constantcolors.dart';

class HomePageHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bottomNavBar(int index, PageController pagecontroller) {
    return CustomNavigationBar(
        currentIndex: index,
        // bubbleCurve: Curves.bounceIn,
        // scaleCurve: Curves.decelerate,
        selectedColor: constantColors.blueColor,
        unSelectedColor: constantColors.whiteColor,
        strokeColor: constantColors.blueColor,
        // scaleFactor: 0.5,
        iconSize: 30,
        onTap: (val) {
          index = val;
          pagecontroller.jumpToPage(val);
          notifyListeners();
        },
        backgroundColor: Color(0xff040307),
        items: [
          CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
          CustomNavigationBarItem(icon: Icon(EvaIcons.messageCircle)),
          CustomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: constantColors.blueGreyColor,
              radius: 35,
              // backgroundImage:,
            ),
          ),
        ]);
  }
}
