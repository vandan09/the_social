import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/screens/HomePage/HomePage.dart';
import 'package:the_social/services/Authentication.dart';
import 'package:the_social/services/FirebaseOperation.dart';

class GroupMessageHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  bool hasMemberJoined = false;
  bool get getMemberJoined => hasMemberJoined;
  groupDetails(BuildContext context, DocumentSnapshot documentsnapshot) {
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
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 150,
                ),
                child: Divider(
                  color: constantColors.whiteColor,
                  thickness: 4,
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                      title: Text(
                        documentsnapshot['username'],
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      trailing: Text(
                        'Admin',
                        style: TextStyle(
                            color: constantColors.greenColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Divider(
                      color: constantColors.whiteColor,
                      // thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: SingleChildScrollView(
                      // height: MediaQuery.of(context).size.height ,
                      // width: MediaQuery.of(context).size.width,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chatrooms')
                              .doc(documentsnapshot.id)
                              .collection('members')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ListView(
                                shrinkWrap: true,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot documentSnapshot1) {
                                  return GestureDetector(
                                    child: Text(
                                      documentSnapshot1['username'] ==
                                              documentsnapshot['username']
                                          ? ' '
                                          : documentSnapshot1['username'],
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          }),
                    ),
                  )
                ],
              )
            ]),
          );
        });
  }

  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitiUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitiUserImage,
      'useruid': Provider.of<Authentication>(context, listen: false).getuserUid,
    }).whenComplete(() => messageController.clear());
  }

  showEditSheet(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.delete,
                      color: constantColors.redColor,
                    ),
                  ),
                  Text(
                    "Delete",
                    style: TextStyle(
                      color: constantColors.redColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  showMessage(BuildContext context, DocumentSnapshot documentsnapshot,
      String adminUserUid) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(documentsnapshot.id)
            .collection('messages')
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
                // reverse: true,
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 35.0),
                          child: GestureDetector(
                            onLongPress: () {
                              Provider.of<Authentication>(context,
                                              listen: false)
                                          .getuserUid ==
                                      documentSnapshot['useruid']
                                  ? showEditSheet(context)
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    );
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.07,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getuserUid ==
                                        documentSnapshot['useruid']
                                    ? constantColors.blueGreyColor
                                        .withOpacity(0.8)
                                    : constantColors.blueGreyColor,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        documentSnapshot['username'],
                                        style: TextStyle(
                                            color: constantColors.greenColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot['message'],
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        top: 4,
                        left: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: constantColors.darkColor,
                          backgroundImage: NetworkImage(
                            documentSnapshot['userimage'],
                          ),
                        )),
                  ],
                ),
              );
            }).toList());
          }
        });
  }

  Future checkIfJoined(BuildContext context, String chatRoomName,
      String chatRoomAdminUid) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getuserUid)
        .get()
        .then((value) {
      hasMemberJoined = false;
      print('Intial state $hasMemberJoined');
      if (value.data()!['joined'] != null) {
        hasMemberJoined = value.data()!['joined'];
        print('final state $hasMemberJoined');
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getuserUid ==
          chatRoomAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  askToJoin(BuildContext context, String roomname) {
    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'Join $roomname?',
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text(
                  'No',
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(roomname)
                      .collection('tempMembers')
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getuserUid)
                      .set({
                    'joined': null,
                    'username':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getinitiUserName,
                    'userimage':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getinitiUserImage,
                    'useruid':
                        Provider.of<Authentication>(context, listen: false)
                            .getuserUid,
                    'time': Timestamp.now()
                  }).whenComplete(() {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }
}
