import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:the_social/Altprofile/alt_profile.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/profile/profile.dart';
import 'package:the_social/services/Authentication.dart';
import 'package:the_social/services/FirebaseOperation.dart';

class AtlProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Future<String> getId(DocumentReference doc_ref) async {
    DocumentSnapshot docSnap = await doc_ref.get();
    var doc_id2 = docSnap.reference.id;
    return doc_id2;
  }

  bool follow = false;

  toast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        backgroundColor: constantColors.whiteColor,
        textColor: constantColors.darkColor);
  }

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
      height: MediaQuery.of(context).size.height * 0.31,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //image
                    GestureDetector(
                      onTap: () {},
                      child: CachedNetworkImage(
                        width: 100,
                        height: 80,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 100.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        progressIndicatorBuilder: (context, url, progress) =>
                            Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            color: constantColors.greenColor,
                            value: progress.progress,
                          ),
                        ),
                        imageUrl: snapshot.data!['userimage'],
                      ),
                    ),
                    //follwers
                    GestureDetector(
                      onTap: (() {
                        checkFollowerSheet(context, snapshot);
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                            color: constantColors.darkColor,
                            borderRadius: BorderRadius.circular(15)),
                        height: 80,
                        width: 80,
                        child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(snapshot.data!['userid'])
                                  .collection('followers')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28),
                                  );
                                }
                              },
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
                    ),
                    //following
                    GestureDetector(
                      onTap: () {
                        checkFollowingSheet(context, snapshot);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: constantColors.darkColor,
                            borderRadius: BorderRadius.circular(15)),
                        height: 80,
                        width: 80,
                        child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(snapshot.data!['userid'])
                                  .collection('following')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28),
                                  );
                                }
                              },
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
          // username email
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
          // follow following button
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width,
              // color: constantColors.redColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40,
                    width: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: constantColors.whiteColor)),
                    child: MaterialButton(
                      onPressed: () {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .followUser(
                                useruid,
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getuserUid,
                                {
                                  'username': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getinitiUserName,
                                  'useruid': Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getuserUid,
                                  'useremail': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getinitiUserEmail,
                                  'userimage': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getinitiUserImage,
                                  'time': Timestamp.now(),
                                },
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getuserUid as String,
                                useruid,
                                {
                                  'username': snapshot.data!['username'],
                                  'useruid': snapshot.data!['userid'],
                                  'useremail': snapshot.data!['useremail'],
                                  'userimage': snapshot.data!['userimage'],
                                  'time': Timestamp.now(),
                                })
                            .whenComplete(
                          () {
                            toast('Followed ${snapshot.data!['username']}');
                          },
                        );
                      },
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(
                              snapshot.data!['userid'],
                            )
                            .collection('following')
                            .doc(
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getuserUid,
                            )
                            .snapshots(),
                        builder: (context, snapshot1) {
                          DocumentReference doc_ref = FirebaseFirestore.instance
                              .collection('users')
                              .doc(snapshot.data!['userid'])
                              .collection('following')
                              .doc();

                          Future<String> id = getId(doc_ref);
                          print(id);

                          return Text(
                              id ==
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getuserUid
                                  ? 'Following'
                                  : 'Follow',
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ));
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: constantColors.whiteColor)),
                    child: MaterialButton(
                      onPressed: () {},
                      child: Text(
                        'Message',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Divider(
          color: constantColors.whiteColor,
        ),
      ),
    );
  }

  Widget middelProfile(BuildContext context, dynamic snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 5),
          child: Container(
            child: Text(
              'Recently Added',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor.withOpacity(0.4),
              // borderRadius: BorderRadius.circular(15),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!['userid'])
                  .collection('following')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot documentSnapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Padding(
                          padding:
                              EdgeInsets.only(left: 20, top: 15, bottom: 15),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          constantColors.transperant,
                                      actions: [
                                        Center(
                                            child: CircularProgressIndicator(
                                          color: constantColors.blueColor,
                                        ))
                                      ],
                                    );
                                  });
                              if (documentSnapshot['userid'] !=
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getuserUid) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AltProfile(
                                      useruid: documentSnapshot['userid'],
                                    ),
                                  ),
                                ).whenComplete(() {
                                  Navigator.pop(context);
                                });
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Profile(),
                                  ),
                                ).whenComplete(() {
                                  Navigator.pop(context);
                                });
                                ;
                              }
                            },
                            child: CachedNetworkImage(
                              width: 50,
                              height: 50,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 5,
                                  color: constantColors.greenColor,
                                  value: progress.progress,
                                ),
                              ),
                              imageUrl: documentSnapshot['userimage'],
                            ),
                          ),
                        );
                      }
                    }).toList(),
                  );
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(snapshot.data!['userid'])
            .collection('posts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        child: CachedNetworkImage(
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: MediaQuery.of(context).size.width,
                          imageBuilder: (context, imageProvider) => Container(
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 5,
                              color: constantColors.greenColor,
                              value: progress.progress,
                            ),
                          ),
                          imageUrl: documentSnapshot['postimage'],
                        ),
                      ),
                    ),
                  );
                }).toList());
          }
        },
      ),
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: constantColors.darkColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  checkFollowingSheet(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: constantColors.blueGreyColor),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!['userid'])
                    .collection('following')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListTile(
                            leading: CachedNetworkImage(
                              width: 40,
                              height: 40,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 5,
                                  color: constantColors.greenColor,
                                  value: progress.progress,
                                ),
                              ),
                              imageUrl: documentSnapshot['userimage'],
                            ),
                            title: Text(
                              documentSnapshot['username'],
                              style: TextStyle(
                                  fontSize: 18,
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          );
        });
  }

  checkFollowerSheet(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: constantColors.blueGreyColor),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!['userid'])
                    .collection('followers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListTile(
                            leading: CachedNetworkImage(
                              width: 40,
                              height: 40,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 5,
                                  color: constantColors.greenColor,
                                  value: progress.progress,
                                ),
                              ),
                              imageUrl: documentSnapshot['userimage'],
                            ),
                            title: Text(
                              documentSnapshot['username'],
                              style: TextStyle(
                                  fontSize: 18,
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          );
        });
  }
}
