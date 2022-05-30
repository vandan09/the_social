import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'package:flutter/material.dart';
import 'package:the_social/constants/Constantcolors.dart';

class AtlProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  appBarAltProfile(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              EvaIcons.moreVerticalOutline,
              color: constantColors.whiteColor,
            ))
      ],
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'The ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: constantColors.whiteColor),
            children: [
              TextSpan(
                text: 'Social',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: constantColors.blueColor),
              )
            ]),
      ),
    );
  }

  Widget headerProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String useruid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.22,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              // color: constantColors.redColor,
              // height: ,
              width: MediaQuery.of(context).size.width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //image
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        radius: 40,
                        backgroundImage: NetworkImage(
                          snapshot.data!['userimage'],
                        ),
                      ),
                    ),
                    //follwers
                    Container(
                      decoration: BoxDecoration(
                          color: constantColors.darkColor,
                          borderRadius: BorderRadius.circular(15)),
                      height: 80,
                      width: 80,
                      child: Column(
                        children: [
                          Text(
                            '0',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                          Text(
                            'Followers',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    //following
                    Container(
                      decoration: BoxDecoration(
                          color: constantColors.darkColor,
                          borderRadius: BorderRadius.circular(15)),
                      height: 80,
                      width: 80,
                      child: Column(
                        children: [
                          Text(
                            '0',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                          Text(
                            'Following',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    //post
                    Container(
                      decoration: BoxDecoration(
                          color: constantColors.darkColor,
                          borderRadius: BorderRadius.circular(15)),
                      height: 80,
                      width: 80,
                      child: Column(
                        children: [
                          Text(
                            '0',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                          Text(
                            'Post',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          Container(
            // color: constantColors.yellowColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    snapshot.data!['username'],
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      Icon(
                        EvaIcons.email,
                        color: constantColors.blueColor,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        snapshot.data!['useremail'],
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Divider(
          color: constantColors.whiteColor,
        ),
      ),
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Container(
      child: Center(
        child: Text(
          'No post yet !',
          style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: constantColors.darkColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
