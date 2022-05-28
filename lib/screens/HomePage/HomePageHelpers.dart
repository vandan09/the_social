import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/services/Authentication.dart';
import 'package:the_social/services/FirebaseOperation.dart';

class HomePageHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bottomNavBar(
      BuildContext context, int index, PageController pagecontroller) {
    return Container(
      height: 80,
      child: BottomNavigationBar(
          currentIndex: index,
          selectedItemColor: constantColors.blueColor,
          unselectedItemColor: constantColors.whiteColor,
          // bubbleCurve: Curves.bounceIn,
          // scaleCurve: Curves.decelerate,
          elevation: 0,
          // isFloating: false,
          // scaleCurve: Curves.easeInQuad,
          // selectedColor: constantColors.blueColor,
          // unSelectedColor: constantColors.whiteColor,
          // strokeColor: constantColors.blueColor,
          // scaleFactor: 0.5,
          iconSize: 25,
          onTap: (val) {
            index = val;
            pagecontroller.jumpToPage(val);
            notifyListeners();
          },
          backgroundColor: Color(0xff040307),
          items: [
            BottomNavigationBarItem(icon: Icon(EvaIcons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(EvaIcons.messageCircle), label: 'Chat'),
            BottomNavigationBarItem(
                icon: CircleAvatar(
                  backgroundColor: constantColors.blueGreyColor,
                  radius: 20,
                  backgroundImage: NetworkImage(
                      '${Provider.of<FirebaseOperations>(context, listen: false).getinitiUserImage}'),
                ),
                label: 'Profile'),
          ]),
    );
  }
}
