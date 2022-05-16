import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/screens/LandingPage/LandingHelpers.dart';
import 'package:the_social/screens/SpalshScreen/Spalshscreen.dart';
import 'package:the_social/services/Authentication.dart';

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
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingHelpers()),
        ]);
  }
}
