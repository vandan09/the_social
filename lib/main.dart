import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/Altprofile/alt_profile.dart';
import 'package:the_social/chat_room/chat_room.dart';
import 'package:the_social/chat_room/chat_room_helpers.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/feed/feedHelpers.dart';
import 'package:the_social/message/group_message_helper.dart';
import 'package:the_social/profile/profileHelpers.dart';
import 'package:the_social/screens/HomePage/HomePageHelpers.dart';
import 'package:the_social/screens/LandingPage/LandingHelpers.dart';
import 'package:the_social/screens/LandingPage/LandingServices.dart';
import 'package:the_social/screens/LandingPage/LandingUtils.dart';
import 'package:the_social/screens/SpalshScreen/Spalshscreen.dart';
import 'package:the_social/services/Authentication.dart';
import 'package:the_social/services/FirebaseOperation.dart';
import 'package:the_social/utils/PostOptions.dart';
import 'package:the_social/utils/UploadPost.dart';
import 'package:the_social/Altprofile/alt_profile_helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
        child: MaterialApp(
          home: Spalshscreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            accentColor: constantColors.blueColor,
            fontFamily: 'Poppins',
            canvasColor: Colors.transparent,
          ),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => GroupMessageHelpers()),
          ChangeNotifierProvider(create: (_) => ChatRoomHelpers()),
          ChangeNotifierProvider(create: (_) => AtlProfileHelpers()),
          ChangeNotifierProvider(create: (_) => PostFunctions()),
          ChangeNotifierProvider(create: (_) => FeedHelpers()),
          ChangeNotifierProvider(create: (_) => UploadPost()),
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => HomePageHelpers()),
          ChangeNotifierProvider(create: (_) => LandingUtils()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => LandingService()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingHelpers()),
        ]);
  }
}
