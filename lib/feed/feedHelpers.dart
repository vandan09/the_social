import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/services/Authentication.dart';
import 'package:the_social/utils/UploadPost.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  appBar(BuildContext context) {
    return AppBar(
      // toolbarHeight: 20,
      backgroundColor: constantColors.darkColor.withOpacity(0.4),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              Provider.of<UploadPost>(context, listen: false)
                  .selectPostImage(context);
            },
            icon: Icon(
              Icons.add,
              color: constantColors.greenColor,
            ))
      ],
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
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('post').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(),
              );
            } else {
              return loadPost(context, snapshot);
            }
          },
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.6),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18))),
      ),
    );
  }

  Widget loadPost(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
        shrinkWrap: true,
        children: snapshot.data!.docs.map((DocumentSnapshot documnetSnapshot) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    //userimage
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        radius: 20,
                        backgroundImage:
                            NetworkImage(documnetSnapshot['userimage']),
                      ),
                    ),
                    //caption username time
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                documnetSnapshot['caption'],
                                style: TextStyle(
                                    color: constantColors.greenColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                    text: documnetSnapshot['username'],
                                    style: TextStyle(
                                        color: constantColors.blueColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' , 12 hours ago',
                                        style: TextStyle(
                                          color: constantColors.lightColor
                                              .withOpacity(0.8),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //3dot
                    Provider.of<Authentication>(context, listen: false)
                                .getuserUid ==
                            documnetSnapshot['useruid']
                        ? IconButton(
                            onPressed: () {},
                            icon: Icon(
                              EvaIcons.moreVertical,
                              color: constantColors.whiteColor,
                            ))
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                  ],
                ),
                //post image
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      child: Image.network(
                        documnetSnapshot['postimage'],
                        scale: 2,
                      ),
                    ),
                  ),
                ),
                //like cmnt save
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 80,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: Icon(
                                FontAwesomeIcons.heart,
                                color: constantColors.redColor,
                                size: 22,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ]),
                    ),
                    Container(
                      height: 80,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: Icon(
                                FontAwesomeIcons.comment,
                                color: constantColors.blueColor,
                                size: 22,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ]),
                    ),
                    Container(
                      height: 80,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: Icon(
                                FontAwesomeIcons.award,
                                color: constantColors.yellowColor,
                                size: 22,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ]),
                    ),
                    // Spacer(),
                  ],
                ),
              ],
            ),
          );
        }).toList());
  }
}
