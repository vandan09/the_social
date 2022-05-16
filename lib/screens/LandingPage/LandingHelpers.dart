import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/screens/HomePage/HomePage.dart';
import 'package:the_social/services/Authentication.dart';

class LandingHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/login.png'))),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
        top: 450,
        left: 10,
        child: Container(
          constraints: BoxConstraints(maxWidth: 170),
          child: RichText(
            text: TextSpan(
                text: 'Are You',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
                children: <TextSpan>[
                  TextSpan(
                    text: ' Social',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 34),
                  ),
                  TextSpan(
                    text: ' ?',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 34),
                  )
                ]),
          ),
        ));
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
        top: 630,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Container(
                  child: Icon(
                    EvaIcons.emailOutline,
                    color: constantColors.yellowColor,
                  ),
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: constantColors.yellowColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('Sign in With Google');
                  Provider.of<Authentication>(context, listen: false)
                      .signInWithGoogle()
                      .whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: HomePage(),
                            type: PageTransitionType.leftToRight));
                  });
                },
                child: Container(
                  child: Icon(
                    EvaIcons.google,
                    color: constantColors.redColor,
                  ),
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: constantColors.redColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  child: Icon(
                    EvaIcons.facebook,
                    color: constantColors.blueColor,
                  ),
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: constantColors.blueColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
        top: 740,
        left: 20,
        right: 20,
        child: Container(
          child: Column(
            children: [
              Text(
                "By continuing you agree theSocial's Terms of",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Text(
                "Services & Privacy Policy",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ));
  }
}