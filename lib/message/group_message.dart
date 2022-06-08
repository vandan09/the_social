import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/message/group_message_helper.dart';
import 'package:the_social/services/Authentication.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  GroupMessage(this.documentSnapshot);

  @override
  State<GroupMessage> createState() =>
      _GroupMessageState(this.documentSnapshot);
}

class _GroupMessageState extends State<GroupMessage> {
  TextEditingController messageController = TextEditingController();
  final DocumentSnapshot documentSnapshot;
  _GroupMessageState(this.documentSnapshot);
  ConstantColors constantColors = ConstantColors();
  @override
  void initState() {
    Provider.of<GroupMessageHelpers>(context, listen: false)
        .checkIfJoined(context, documentSnapshot.id, documentSnapshot['userid'])
        .whenComplete(() async {
      if (Provider.of<GroupMessageHelpers>(context, listen: false)
                  .getMemberJoined ==
              false &&
          documentSnapshot['userid'] !=
              Provider.of<Authentication>(context, listen: false).getuserUid) {
        Timer(
            Duration(microseconds: 10),
            () => Provider.of<GroupMessageHelpers>(context, listen: false)
                .askToJoin(context, documentSnapshot.id));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: Provider.of<Authentication>(context, listen: false)
                          .getuserUid ==
                      documentSnapshot['userid']
                  ? Icon(Icons.more_vert)
                  : Container(
                      height: 0,
                      width: 0,
                    )),
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            Provider.of<GroupMessageHelpers>(context, listen: false)
                .groupDetails(context, documentSnapshot);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            // color: constantColors.blueGreyColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  documentSnapshot['roomname'],
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('members')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Text(
                          '${(snapshot.data!.docs.length + 1).toString()} members',
                          style: TextStyle(
                              color: constantColors.greenColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                child: Provider.of<GroupMessageHelpers>(context, listen: false)
                    .showMessage(
                  context,
                  documentSnapshot,
                  documentSnapshot['userid'],
                ),
                // color: constantColors.redColor,
                duration: Duration(seconds: 1),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                curve: Curves.bounceIn,
              ),
              Container(
                color: constantColors.blueGreyColor.withOpacity(0.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: messageController,
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: constantColors.whiteColor)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: constantColors.greenColor)),
                          hintText: 'message',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      child: FloatingActionButton(
                          backgroundColor: constantColors.blueGreyColor,
                          child: Icon(
                            Icons.send,
                            color: constantColors.greenColor,
                          ),
                          onPressed: () {
                            if (messageController.text.isNotEmpty) {
                              Provider.of<GroupMessageHelpers>(context,
                                      listen: false)
                                  .sendMessage(context, documentSnapshot,
                                      messageController);
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
