import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_social/Altprofile/alt_profile.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/profile/profile.dart';
import 'package:the_social/services/Authentication.dart';
import 'package:the_social/services/FirebaseOperation.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController commentController = TextEditingController();
  TextEditingController updateCaption = TextEditingController();

  String? imageTimePosted;
  String? get getImageTimePosted => imageTimePosted;

  showIimeAgo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    notifyListeners();
  }

  toast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        backgroundColor: constantColors.whiteColor,
        textColor: constantColors.darkColor);
  }

  showOptions(BuildContext context, postId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        MaterialButton(
                          // color: constantColors.blueColor,
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Center(
                                        child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 300,
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Add new caption',
                                              hintStyle: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            controller: updateCaption,
                                          ),
                                        ),
                                        FloatingActionButton(
                                            backgroundColor:
                                                constantColors.blueColor,
                                            child: Icon(
                                              FontAwesomeIcons.fileUpload,
                                              color: constantColors.whiteColor,
                                            ),
                                            onPressed: () {
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .updateCaption(postId, {
                                                'caption': updateCaption.text,
                                              });
                                            }),
                                      ],
                                    )),
                                  );
                                });
                          },
                          child: Text(
                            'Edit Post',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // delete
                        MaterialButton(
                          // color: constantColors.blueColor,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Delete this post?',
                                      style: TextStyle(
                                        color: constantColors.darkColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    actions: [
                                      MaterialButton(
                                        // color: constantColors.blueColor,
                                        onPressed: () {
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .deleteUserData(postId, 'post')
                                              .whenComplete(() {
                                            toast('Post deleted');
                                          }).whenComplete(() {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: constantColors.blueColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      MaterialButton(
                                        // color: constantColors.blueColor,
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                            color: constantColors.darkColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                            // Navigator.pop(context);
                          },
                          child: Text(
                            'Delete Post',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future addLikes(BuildContext context, String postId, subPostId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subPostId)
        .set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitiUserName,
      'userid': Provider.of<Authentication>(context, listen: false).getuserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitiUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitiUserEmail,
      'time': Timestamp.now(),
    });
  }

  Future deleteLikes(BuildContext context, String postId, subPostId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subPostId)
        .delete();
  }

  Future<bool> checkLikes(
      BuildContext context, String postId, subPostId) async {
    var boolsnapshot = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get(subPostId);

    if (boolsnapshot.toString().length == 0) {
      notifyListeners();
      print(boolsnapshot.toString().length);
      return false;
    } else {
      notifyListeners();
      print(boolsnapshot.toString().length);

      return true;
    }
  }

  Future addComment(BuildContext context, String postId, comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitiUserName,
      'userid': Provider.of<Authentication>(context, listen: false).getuserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitiUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitiUserEmail,
      'time': Timestamp.now(),
    });
  }

  showCommentSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  //divider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  //head comment
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Center(
                        child: Text(
                          'Comments',
                          style: TextStyle(
                              color: constantColors.blueColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  //main comment
                  Container(
                    height: MediaQuery.of(context).size.height * 0.52,
                    // color: constantColors.blueColor,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(docId)
                          .collection('comments')
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      //image

                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      constantColors
                                                          .transperant,
                                                  actions: [
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: constantColors
                                                          .blueColor,
                                                    ))
                                                  ],
                                                );
                                              });
                                          if (documentSnapshot['userid'] !=
                                              Provider.of<Authentication>(
                                                      context,
                                                      listen: false)
                                                  .getuserUid) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AltProfile(
                                                  useruid: documentSnapshot[
                                                      'userid'],
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
                                          }
                                        },
                                        child: CachedNetworkImage(
                                          width: 40,
                                          height: 40,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 80.0,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 5,
                                              color: constantColors.greenColor,
                                              value: progress.progress,
                                            ),
                                          ),
                                          imageUrl:
                                              documentSnapshot['userimage'],
                                        ),
                                      ),
                                      //name

                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      constantColors
                                                          .transperant,
                                                  actions: [
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: constantColors
                                                          .blueColor,
                                                    ))
                                                  ],
                                                );
                                              });
                                          if (documentSnapshot['userid'] !=
                                              Provider.of<Authentication>(
                                                      context,
                                                      listen: false)
                                                  .getuserUid) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AltProfile(
                                                  useruid: documentSnapshot[
                                                      'userid'],
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
                                          }
                                        },
                                        child: Text(
                                          documentSnapshot['username'],
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                      //3 button
                                      Container(
                                        child: Row(children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              FontAwesomeIcons.arrowUp,
                                              color: constantColors.blueColor,
                                            ),
                                          ),
                                          Text(
                                            '0',
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ]),
                                      ),

                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          FontAwesomeIcons.reply,
                                          color: constantColors.yellowColor,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          FontAwesomeIcons.trash,
                                          color: constantColors.redColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  //comment
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: constantColors.blueColor,
                                            size: 12,
                                          ),
                                        ),
                                        Container(
                                          // height:
                                          //     MediaQuery.of(context).size.height *
                                          //         0.2,
                                          // width:
                                          //     MediaQuery.of(context).size.width *
                                          //         0.2,
                                          child: Text(
                                            documentSnapshot['comment'],
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: constantColors.whiteColor
                                        .withOpacity(0.2),
                                  ),
                                ],
                              ),
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width,
                            );
                          }).toList());
                        }
                      },
                    ),
                  ),
                  // textfield

                  Expanded(
                    child: Container(
                      color: constantColors.darkColor.withOpacity(0.1),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 30,
                              child: TextField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: commentController,
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintText: 'Add comment...',
                                  hintStyle: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            FloatingActionButton(
                              backgroundColor: constantColors.greenColor,
                              onPressed: () {
                                print('add comment');
                                addComment(context, snapshot['caption'],
                                        commentController.text)
                                    .whenComplete(
                                        () => commentController.clear());
                                notifyListeners();
                              },
                              child: Icon(
                                Icons.comment,
                                color: constantColors.whiteColor,
                              ),
                            )
                          ]),
                      // width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showLikes(BuildContext context, String PostId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                //divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                //head
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: Text(
                        'Likes',
                        style: TextStyle(
                            color: constantColors.blueColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(PostId)
                          .collection('likes')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return ListTile(
                                // image
                                leading: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                constantColors.transperant,
                                            actions: [
                                              Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                            image: imageProvider,
                                            fit: BoxFit.cover),
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
                                //name
                                title: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                constantColors.transperant,
                                            actions: [
                                              Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                      ;
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
                                  child: Text(
                                    documentSnapshot['username'],
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),

                                trailing: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getuserUid ==
                                        documentSnapshot['userid']
                                    ? Container(
                                        height: 0,
                                        width: 0,
                                      )
                                    : MaterialButton(
                                        child: Text(
                                          'Follow',
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        onPressed: () {},
                                        color: constantColors.blueColor,
                                      ),
                              );
                            }).toList(),
                          );
                        }
                      }),
                ),
              ],
            ),
          );
        });
  }

  showRewards(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                //divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                //head
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: Text(
                        'Rewards',
                        style: TextStyle(
                            color: constantColors.blueColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('awards')
                        .snapshots(),
                    builder: (context, snapsot) {
                      if (snapsot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapsot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return Container(
                              height: 50,
                              width: 50,
                              child: Image.network(documentSnapshot['image']),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
