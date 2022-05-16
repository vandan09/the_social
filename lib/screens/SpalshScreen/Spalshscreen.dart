import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/screens/LandingPage/Landingpage.dart';

class Spalshscreen extends StatefulWidget {
  const Spalshscreen({Key? key}) : super(key: key);

  @override
  State<Spalshscreen> createState() => _SpalshscreenState();
}

class _SpalshscreenState extends State<Spalshscreen> {
  ConstantColors constantColors = ConstantColors();
  @override
  void initState() {
    // TODO: implement initState
    Timer(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        PageTransition(
            child: Landingpage(), type: PageTransitionType.leftToRight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
              text: 'the',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
              children: <TextSpan>[
                TextSpan(
                  text: 'Social',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 34),
                )
              ]),
        ),
      ),
    );
  }
}
