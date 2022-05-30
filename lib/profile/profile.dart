import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/profile/profileHelpers.dart';
import 'package:the_social/screens/LandingPage/Landingpage.dart';
import 'package:the_social/services/Authentication.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.settings,
            color: constantColors.lightBlueColor,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ProfileHelpers>(context, listen: false)
                    .logoutAlertBox(context);
              },
              icon: Icon(
                Icons.logout_outlined,
                color: constantColors.greenColor,
              ))
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
              text: 'My ',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              children: [
                TextSpan(
                  text: 'Profile',
                  style: TextStyle(
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 2,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(Provider.of<Authentication>(context).getuserUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // ignore: unnecessary_new
                return new Column(
                  children: [
                    Provider.of<ProfileHelpers>(context, listen: false)
                        .headerProfiel(context, snapshot.data!),
                    Provider.of<ProfileHelpers>(context, listen: false)
                        .divider(),
                    Provider.of<ProfileHelpers>(context, listen: false)
                        .middelProfile(context, snapshot),
                    Provider.of<ProfileHelpers>(context, listen: false)
                        .footerProfile(context, snapshot),
                  ],
                );
              }
            },
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: constantColors.blueGreyColor.withOpacity(0.60)),
        ),
      ),
    );
  }
}
