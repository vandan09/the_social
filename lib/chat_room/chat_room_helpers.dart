import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/message/group_message.dart';
import 'package:the_social/message/group_message_helper.dart';
import 'package:the_social/screens/LandingPage/LandingServices.dart';
import 'package:the_social/services/Authentication.dart';
import 'package:the_social/services/FirebaseOperation.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomHelpers with ChangeNotifier {
  String? latestMessageTime;
  String? get getLatestMessageTime => latestMessageTime;
  String? image;
  ConstantColors constantColors = ConstantColors();
  TextEditingController chatroomnameController = TextEditingController();
  final picker = ImagePicker();
  Widget buildEditIcon() {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(1.5),
        color: constantColors.whiteColor,
        child: ClipOval(
          child: Container(
            padding: EdgeInsets.all(8),
            color: constantColors.blueGreyColor,
            child: Icon(
              Icons.edit,
              color: constantColors.greenColor,
            ),
          ),
        ),
      ),
    );
  }

  // groupDetails(BuildContext context, DocumentSnapshot documentsnapshot) {
  //   return showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           height: MediaQuery.of(context).size.height,
  //           width: MediaQuery.of(context).size.width,
  //           decoration: BoxDecoration(
  //             color: constantColors.blueGreyColor,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(12),
  //               topRight: Radius.circular(12),
  //             ),
  //           ),
  //           child: Column(children: [
  //             Padding(
  //               padding: EdgeInsets.symmetric(
  //                 horizontal: 150,
  //               ),
  //               child: Divider(
  //                 color: constantColors.whiteColor,
  //                 thickness: 4,
  //               ),
  //             ),
  //             ListView(
  //               shrinkWrap: true,
  //               children: [
  //                 ListTile(
  //                   title: Text(
  //                     documentsnapshot['username'],
  //                     style: TextStyle(
  //                         color: constantColors.whiteColor,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 16),
  //                   ),
  //                   trailing:
  //                       Provider.of<Authentication>(context, listen: false)
  //                                   .getuserUid ==
  //                               documentsnapshot['userid']
  //                           ? Text(
  //                               'Admin',
  //                               style: TextStyle(
  //                                   color: constantColors.greenColor,
  //                                   fontWeight: FontWeight.bold,
  //                                   fontSize: 12),
  //                             )
  //                           : Container(
  //                               height: 0,
  //                               width: 0,
  //                             ),
  //                 ),
  //               ],
  //             )
  //           ]),
  //         );
  //       });
  // }

  var chatRoomAvatar;
  File get getchatRoomAvatar => chatRoomAvatar;
  String? chatRoomAvatarUrl;
  String? get getchatRoomAvatarUrl => chatRoomAvatarUrl;
  // DocumentSnapshot? documentSnapshot;

  Future pickChatAvatar(
    BuildContext context,
    ImageSource source,
  ) async {
    final pickedchatRoomAvatar = await picker.pickImage(source: source);
    pickedchatRoomAvatar == null
        ? print('Select Image')
        : chatRoomAvatar = File(pickedchatRoomAvatar.path);
    print(chatRoomAvatar.path);

    chatRoomAvatar != null
        ? showChatRoomSheet(context)
        : print("Image Upload Error");
    notifyListeners();
  }

  Future<void> update(DocumentSnapshot documentSnapshot, documentSnapshot1,
      BuildContext context) async {
    Provider.of<GroupMessageHelpers>(context, listen: false).hasMemberJoined =
        true;
    notifyListeners();
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('tempMembers')
        .doc(documentSnapshot1.id)
        .update({
      'joined': true,
    }).whenComplete(() {
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(documentSnapshot.id)
          .collection('members')
          .doc(Provider.of<Authentication>(context, listen: false).getuserUid)
          .set({
        'username': documentSnapshot1['username'],
        'userimage': documentSnapshot1['userimage'],
        'useruid': documentSnapshot1['useruid'],
        'time': Timestamp.now()
      }).whenComplete(() {
        Navigator.pop(context);
      });
    });
  }

  showChatRoomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 150,
                    ),
                    child: Divider(
                      color: constantColors.whiteColor,
                      thickness: 4,
                    ),
                  ),
                  // Text(
                  //   'Select chatroom avatar',
                  //   style: TextStyle(
                  //       color: constantColors.whiteColor,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16),
                  // ),

                  // Container(
                  //   decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       border: Border.all(
                  //           color: constantColors.whiteColor)),
                  //   child: ClipOval(
                  //     child: image != null
                  //         ? Image.network(
                  //             image!,
                  //             height: 130,
                  //             width: 130,
                  //             fit: BoxFit.cover,
                  //           )
                  //         : Image.asset(
                  //             "assets/images/login.png",
                  //             height: 130,
                  //             width: 130,
                  //             fit: BoxFit.cover,
                  //           ),
                  //   ),
                  // ),
                  //edit button

                  // Positioned(
                  //   bottom: 0,
                  //   right: 4,
                  //   child: GestureDetector(
                  //       onTap: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //             return AlertDialog(
                  //               title: Center(
                  //                   child: Text(
                  //                 'Select Image source',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold),
                  //               )),
                  //               actionsPadding: EdgeInsets.all(8),
                  //               actionsAlignment:
                  //                   MainAxisAlignment.center,
                  //               actions: [
                  //                 MaterialButton(
                  //                     color:
                  //                         constantColors.blueGreyColor,
                  //                     child: Text(
                  //                       "Gallery",
                  //                       style: TextStyle(
                  //                           color: constantColors
                  //                               .whiteColor,
                  //                           fontWeight:
                  //                               FontWeight.bold),
                  //                     ),
                  //                     onPressed: () {
                  //                       pickChatAvatar(context,
                  //                               ImageSource.gallery)
                  //                           .whenComplete(() {})
                  //                           .whenComplete(() {
                  //                         // Navigator.pop(context);

                  //                         image = Provider.of<
                  //                                     FirebaseOperations>(
                  //                                 context,
                  //                                 listen: false)
                  //                             .getinitiChatroomImage;
                  //                       });
                  //                     }),
                  //                 MaterialButton(
                  //                     color:
                  //                         constantColors.blueGreyColor,
                  //                     child: Text(
                  //                       "Camera",
                  //                       style: TextStyle(
                  //                           color: constantColors
                  //                               .whiteColor,
                  //                           fontWeight:
                  //                               FontWeight.bold),
                  //                     ),
                  //                     onPressed: () {
                  //                       pickChatAvatar(context,
                  //                               ImageSource.camera)
                  //                           .whenComplete(() {
                  //                         Navigator.pop(context);
                  //                         Provider.of<FirebaseOperations>(
                  //                                 context,
                  //                                 listen: false)
                  //                             .uploadChatroomAvatar(
                  //                                 context);
                  //                       });
                  //                     }),
                  //               ],
                  //             );
                  //           },
                  //         );
                  //       },
                  //       child: buildEditIcon()),
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //textfield
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextField(
                            textCapitalization: TextCapitalization.words,
                            controller: chatroomnameController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: constantColors.whiteColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: constantColors.greenColor)),
                              hintText: 'Enter chatroom name',
                              hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        //add button
                        FloatingActionButton(
                            backgroundColor: constantColors.blueGreyColor,
                            child: Icon(
                              Icons.send,
                              color: constantColors.greenColor,
                            ),
                            onPressed: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .createChatroomCollection(
                                      context, chatroomnameController.text, {
                                'time': Timestamp.now(),
                                'roomname': chatroomnameController.text,
                                'username': Provider.of<FirebaseOperations>(
                                        context,
                                        listen: false)
                                    .getinitiUserName,
                                'useremail': Provider.of<FirebaseOperations>(
                                        context,
                                        listen: false)
                                    .getinitiUserEmail,
                                'userimage': Provider.of<FirebaseOperations>(
                                        context,
                                        listen: false)
                                    .getinitiUserImage,
                                'userid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getuserUid,
                              }).whenComplete(() {
                                chatroomnameController.clear();
                                Navigator.pop(context);
                              });
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  showChatrooms(BuildContext context) {
    return Container(
      // color: constantColors.redColor,
      child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('chatrooms').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: constantColors.blueColor,
                ),
              );
            } else {
              return ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot documnetSnapshot) {
                    return Column(
                      children: [
                        ListTile(
                            onLongPress: () {
                              Provider.of<GroupMessageHelpers>(context,
                                      listen: false)
                                  .groupDetails(context, documnetSnapshot);
                            },
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GroupMessage(documnetSnapshot)));
                            },
                            title: Text(
                              documnetSnapshot['roomname'],
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            subtitle: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('chatrooms')
                                  .doc(documnetSnapshot.id)
                                  .collection('messages')
                                  .orderBy('time', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot
                                            .data!.docs.first['username'] !=
                                        null &&
                                    snapshot.data!.docs.first['message'] !=
                                        null) {
                                  return Text(
                                    '${snapshot.data!.docs.first['username']} : ${snapshot.data!.docs.first['message']}',
                                    style: TextStyle(
                                        color: Colors.white60,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  );
                                } else if (snapshot.data!.docs.length == 0) {
                                  return const SizedBox(
                                    width: 0,
                                    height: 0,
                                  );
                                } else {
                                  return const SizedBox(
                                    width: 0,
                                    height: 0,
                                  );
                                }
                              },
                            ),
                            trailing: Container(
                              // color: constantColors.redColor,
                              // height: 20,
                              width: 100,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('chatrooms')
                                      .doc(documnetSnapshot.id)
                                      .collection('messages')
                                      .orderBy('time', descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    lastMessageTime(
                                        snapshot.data!.docs.first['time']);
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Text(
                                        getLatestMessageTime!,
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      );
                                    }
                                  }),
                            )),
                        Divider(
                          color: constantColors.whiteColor,
                        )
                      ],
                    );
                  }).toList());
            }
          }),
    );
  }

  lastMessageTime(dynamic timedata) {
    Timestamp t = timedata;
    DateTime dateTime = t.toDate();
    latestMessageTime = timeago.format(dateTime);
    notifyListeners();
  }

  showApproveSheet(BuildContext context) {
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
                color: constantColors.darkColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 150,
                    ),
                    child: Divider(
                      color: constantColors.whiteColor,
                      thickness: 4,
                    ),
                  ),
                  Container(
                    // height: 100,
                    // width: 100,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: constantColors.blueColor,
                            ),
                          );
                        } else {
                          return ListView(
                            shrinkWrap: true,
                            children: snapshot.data!.docs.map(
                              (DocumentSnapshot documnetSnapshot) {
                                return StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('chatrooms')
                                        .doc(documnetSnapshot.id)
                                        .collection('tempMembers')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: constantColors.blueColor,
                                          ),
                                        );
                                      } else {
                                        if (documnetSnapshot['userid'] !=
                                            Provider.of<Authentication>(context,
                                                    listen: false)
                                                .getuserUid) {
                                          return ListView(
                                              shrinkWrap: true,
                                              children: snapshot.data!.docs.map(
                                                  (DocumentSnapshot
                                                      documnetSnapshot1) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 0),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    color: constantColors
                                                        .blueGreyColor,
                                                    child: Row(children: [
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Text(
                                                          'Requested for group ',
                                                          style: TextStyle(
                                                              color:
                                                                  constantColors
                                                                      .whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 120,
                                                        child: Text(
                                                          '${documnetSnapshot.id}',
                                                          style: TextStyle(
                                                              color:
                                                                  constantColors
                                                                      .whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          documnetSnapshot1[
                                                                      'joined'] ==
                                                                  null
                                                              ? 'Pending'
                                                              : documnetSnapshot1[
                                                                          'joined'] ==
                                                                      false
                                                                  ? 'Declined'
                                                                  : 'Aproved',
                                                          style: TextStyle(
                                                            color:
                                                                constantColors
                                                                    .greenColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    ]),
                                                  ),
                                                );
                                              }).toList());
                                        } else {
                                          return ListView(
                                              shrinkWrap: true,
                                              children: snapshot.data!.docs.map(
                                                  (DocumentSnapshot
                                                      documnetSnapshot1) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 0),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    color: constantColors
                                                        .blueGreyColor,
                                                    child: Row(children: [
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        child: Text(
                                                          documnetSnapshot1[
                                                              'username'],
                                                          style: TextStyle(
                                                              color:
                                                                  constantColors
                                                                      .whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 100,
                                                        child: Text(
                                                          'Request for ',
                                                          style: TextStyle(
                                                              color:
                                                                  constantColors
                                                                      .whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 100,
                                                        child: Text(
                                                          '${documnetSnapshot.id}',
                                                          style: TextStyle(
                                                              color:
                                                                  constantColors
                                                                      .whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              update(
                                                                  documnetSnapshot,
                                                                  documnetSnapshot1,
                                                                  context);
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .check_box_outlined,
                                                              color:
                                                                  constantColors
                                                                      .greenColor,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              Icons
                                                                  .cancel_presentation,
                                                              color:
                                                                  constantColors
                                                                      .redColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                    ]),
                                                  ),
                                                );
                                              }).toList());
                                        }
                                      }
                                    });
                              },
                            ).toList(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
