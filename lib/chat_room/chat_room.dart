import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:the_social/chat_room/chat_room_helpers.dart';
import 'package:the_social/constants/Constantcolors.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.blueGreyColor,
        child: Icon(Icons.add, color: constantColors.greenColor),
        onPressed: () {
          Provider.of<ChatRoomHelpers>(context, listen: false)
              .showChatRoomSheet(context);
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // print('eneter');
              Provider.of<ChatRoomHelpers>(context, listen: false)
                  .showApproveSheet(context);
            },
            icon: Icon(
              Icons.notifications,
              color: constantColors.whiteColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: constantColors.whiteColor,
            ),
          ),
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
              text: 'Chat ',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              children: [
                TextSpan(
                  text: 'Box ',
                  style: TextStyle(
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ]),
        ),
      ),
      body: Provider.of<ChatRoomHelpers>(context, listen: false)
          .showChatrooms(context),
    );
  }
}
