import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/chat_room/chat_room.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/feed/feed.dart';
import 'package:the_social/profile/profile.dart';
import 'package:the_social/screens/HomePage/HomePageHelpers.dart';
import 'package:the_social/services/FirebaseOperation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homepageController,
        children: [
          Feed(),
          ChatRoom(),
          Profile(),
        ],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomePageHelpers>(context, listen: false)
          .bottomNavBar(context, pageIndex, homepageController),
    );
  }
}
