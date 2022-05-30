import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:the_social/Altprofile/alt_profile_helpers.dart';
import 'package:the_social/constants/Constantcolors.dart';

class AltProfile extends StatefulWidget {
  // const AltProfile({Key? key}) : super(key: key);
  final String useruid;
  // ignore: use_key_in_widget_constructors
  AltProfile({
    required this.useruid,
  });

  @override
  // ignore: no_logic_in_create_state
  State<AltProfile> createState() => _AltProfileState(useruid);
}

class _AltProfileState extends State<AltProfile> {
  ConstantColors constantColors = ConstantColors();
  final String useruid;
  _AltProfileState(this.useruid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<AtlProfileHelpers>(context, listen: false)
          .appBarAltProfile(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor.withOpacity(0.6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(useruid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Provider.of<AtlProfileHelpers>(context, listen: false)
                        .headerProfile(context, snapshot, useruid),
                    Provider.of<AtlProfileHelpers>(context, listen: false)
                        .divider(),
                    Provider.of<AtlProfileHelpers>(context, listen: false)
                        .middelProfile(context, snapshot),
                    Provider.of<AtlProfileHelpers>(context, listen: false)
                        .footerProfile(context, snapshot),
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
