import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/LandingPage/LandingUtils.dart';
import 'package:the_social/services/Authentication.dart';

class FirebaseOperations with ChangeNotifier {
  late UploadTask imageUploadTask;
  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');

    imageUploadTask = imageReference
        .putFile(Provider.of<LandingUtils>(context, listen: false).userAvatar);
    await imageUploadTask.whenComplete(() {
      print("image uploaded");
    });

    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
          url.toString();
      print(
          "the user avatar url=>${Provider.of<LandingUtils>(context, listen: false).getUserAvatar}");
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getuserUid)
        .set(data);
  }
}
