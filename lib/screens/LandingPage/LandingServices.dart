import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/screens/HomePage/HomePage.dart';
import 'package:the_social/services/Authentication.dart';

class LandingService with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('allUsers').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return new ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot documentSnapshot) {
                return ListTile(
                  trailing: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.trashAlt,
                      color: constantColors.redColor,
                    ),
                    onPressed: () {},
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(documentSnapshot['image']),
                  ),
                  subtitle: Text(
                    documentSnapshot['useremail'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.greenColor,
                        fontSize: 12),
                  ),
                  title: Text(
                    documentSnapshot['username'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.greenColor),
                  ),
                );
              }).toList());
            }
          }),
    );
  }

  logInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                FloatingActionButton(
                    backgroundColor: constantColors.blueColor,
                    child: Icon(
                      FontAwesomeIcons.check,
                      color: constantColors.whiteColor,
                    ),
                    onPressed: () {
                      if (emailController.text.isNotEmpty) {
                        Provider.of<Authentication>(context, listen: false)
                            .logIntoAccount(
                                emailController.text, passwordController.text)
                            .whenComplete(() {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: HomePage(),
                                  type: PageTransitionType.bottomToTop));
                        });
                      } else {
                        warningText(context, 'Fill all the data');
                      }
                    })
              ]),
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: constantColors.redColor,
                  radius: 60,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter name',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FloatingActionButton(
                      backgroundColor: constantColors.redColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                      onPressed: () {
                        if (emailController.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .createAccount(
                                  emailController.text, passwordController.text)
                              .whenComplete(() {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: HomePage(),
                                    type: PageTransitionType.bottomToTop));
                          });
                        } else {
                          warningText(context, 'Fill all the data');
                        }
                      }),
                ),
              ]),
            ),
          );
        });
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(15),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Text(
              warning,
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )),
          );
        });
  }
}