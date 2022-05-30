import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/Altprofile/alt_profile.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/profile/profile.dart';
import 'package:the_social/services/Authentication.dart';
import 'package:the_social/utils/PostOptions.dart';
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
            text: 'Social ',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: [
              TextSpan(
                text: 'Feed',
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
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return loadPost(context, snapshot);
            }
          },
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // decoration: BoxDecoration(
        //     color: constantColors.darkColor.withOpacity(0.6),
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(18), topRight: Radius.circular(18))),
      ),
    );
  }

  Widget loadPost(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return Padding(
      padding: EdgeInsets.only(bottom: 100.0),
      child: ListView(
          shrinkWrap: true,
          children:
              snapshot.data!.docs.map((DocumentSnapshot documnetSnapshot) {
            Provider.of<PostFunctions>(context, listen: false)
                .showIimeAgo(documnetSnapshot['time']);
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Container(
                color: constantColors.darkColor.withOpacity(0.25),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          //userimage
                          GestureDetector(
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
                              if (documnetSnapshot['useruid'] !=
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getuserUid) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AltProfile(
                                        useruid: documnetSnapshot['useruid'],
                                      ),
                                    ),
                                  ).whenComplete(() {
                                    Navigator.pop(context);
                                  });
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
                              width: 40,
                              height: 40,
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
                              imageUrl: documnetSnapshot['userimage'],
                            ),
                          ),
                          //username time
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, bottom: 20),
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
                                if (documnetSnapshot['useruid'] !=
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getuserUid) {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AltProfile(
                                          useruid: documnetSnapshot['useruid'],
                                        ),
                                      ),
                                    ).whenComplete(() {
                                      Navigator.pop(context);
                                    });
                                    ;
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
                                }
                              },
                              child: SizedBox(
                                // height: MediaQuery.of(context).size.height * 0.09,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: RichText(
                                  text: TextSpan(
                                      text: documnetSnapshot['username'],
                                      style: TextStyle(
                                          color: constantColors.blueColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              ' , ${Provider.of<PostFunctions>(context, listen: false).imageTimePosted.toString()}',
                                          style: TextStyle(
                                            color: constantColors.lightColor
                                                .withOpacity(0.8),
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ),
                          //3dot
                          SizedBox(
                            width: 40,
                          ),
                          Provider.of<Authentication>(context, listen: false)
                                      .getuserUid ==
                                  documnetSnapshot['useruid']
                              ? IconButton(
                                  onPressed: () {
                                    Provider.of<PostFunctions>(context,
                                            listen: false)
                                        .showOptions(context,
                                            documnetSnapshot['caption']);
                                  },
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
                    ),
                    //postimage
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Center(
                        child: GestureDetector(
                          onDoubleTap: (() {
                            print('added like');
                            Provider.of<PostFunctions>(context, listen: false)
                                .addLikes(
                                    context,
                                    documnetSnapshot['caption'],
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getuserUid);
                          }),
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
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 5,
                                color: constantColors.greenColor,
                                value: progress.progress,
                              ),
                            ),
                            imageUrl: documnetSnapshot['postimage'],
                          ),
                        ),
                      ),
                    ),
                    //caption
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 10, bottom: 10),
                      child: Container(
                        child: Text(
                          documnetSnapshot['caption'],
                          style: TextStyle(
                              color: constantColors.greenColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    //like cmnt save
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Container(
                              height: 30,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(documnetSnapshot['caption'])
                                      .collection('likes')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (() {
                                              print('added like');
                                              Provider.of<PostFunctions>(
                                                      context,
                                                      listen: false)
                                                  .addLikes(
                                                      context,
                                                      documnetSnapshot[
                                                          'caption'],
                                                      Provider.of<Authentication>(
                                                              context,
                                                              listen: false)
                                                          .getuserUid);
                                            }),
                                            onDoubleTap: (() {
                                              print('delete like');
                                              Provider.of<PostFunctions>(
                                                      context,
                                                      listen: false)
                                                  .deleteLikes(
                                                      context,
                                                      documnetSnapshot[
                                                          'caption'],
                                                      Provider.of<Authentication>(
                                                              context,
                                                              listen: false)
                                                          .getuserUid);
                                            }),
                                            child: Icon(
                                              snapshot.data!.docs.length >= 1
                                                  ? CupertinoIcons.heart_fill
                                                  : CupertinoIcons.heart,
                                              color: constantColors.redColor,
                                              size: 25,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Provider.of<PostFunctions>(
                                                      context,
                                                      listen: false)
                                                  .showLikes(
                                                      context,
                                                      documnetSnapshot[
                                                          'caption']);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  })),
                        ),
                        //cmnt
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .showCommentSheet(context, documnetSnapshot,
                                      documnetSnapshot['caption']);
                            },
                            child: Container(
                              height: 30,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.comment,
                                      color: constantColors.blueColor,
                                      size: 22,
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(documnetSnapshot['caption'])
                                            .collection('comments')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            );
                                          }
                                        })
                                  ]),
                            ),
                          ),
                        ),
                        //share
                        GestureDetector(
                          onTap: () {
                            Provider.of<PostFunctions>(context, listen: false)
                                .showRewards(context);
                          },
                          child: Container(
                            height: 30,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.share,
                                    color: constantColors.yellowColor,
                                    size: 22,
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
                        ),
                        // Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}
