import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/feed/feedHelpers.dart';
import 'package:the_social/profile/profileHelpers.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      drawer: Drawer(),
      appBar: Provider.of<FeedHelpers>(context, listen: false).appBar(context),
      body: Provider.of<FeedHelpers>(context, listen: false).feedBody(context),
    );
  }
}
