import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/screens/LandingPage/LandingServices.dart';
import 'package:the_social/services/Authentication.dart';
import 'package:the_social/services/FirebaseOperation.dart';

class ChatRoomHelpers with ChangeNotifier {
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

  var chatRoomAvatar;
  File get getchatRoomAvatar => chatRoomAvatar;
  String? chatRoomAvatarUrl;
  String? get getchatRoomAvatarUrl => chatRoomAvatarUrl;

  Future pickChatAvatar(BuildContext context, ImageSource source) async {
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
                          title: Text(
                            documnetSnapshot['roomname'],
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          subtitle: Text(
                            'last message',
                            style: TextStyle(
                                color:
                                    constantColors.whiteColor.withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          trailing: Text(
                            '2 hours ago',
                            style: TextStyle(
                                color:
                                    constantColors.whiteColor.withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
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
}
