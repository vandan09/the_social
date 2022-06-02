import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/chat_room/chat_room_helpers.dart';
import 'package:the_social/screens/LandingPage/LandingUtils.dart';
import 'package:the_social/services/Authentication.dart';

class FirebaseOperations with ChangeNotifier {
  late String initUserEmail;
  String? initUserName;
  String? initUserImage;
  String? initchatroomimage;

  late UploadTask imageUploadTask;
  late UploadTask chatroomimageUploadTask;
  String? get getinitiChatroomImage => initchatroomimage;

  String? get getinitiUserName => initUserName;
  String? get getinitiUserEmail => initUserEmail;
  String? get getinitiUserImage => initUserImage;

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

  Future uploadChatroomAvatar(BuildContext context) async {
    Reference chatroomimageReference = FirebaseStorage.instance.ref().child(
        'chatroomAvatar/${Provider.of<ChatRoomHelpers>(context, listen: false).chatRoomAvatar.path}/${TimeOfDay.now()}');

    chatroomimageUploadTask = chatroomimageReference.putFile(
        Provider.of<ChatRoomHelpers>(context, listen: false).chatRoomAvatar);
    await chatroomimageUploadTask.whenComplete(() {
      print("chatroom image uploaded");
    });

    chatroomimageReference.getDownloadURL().then((url) {
      Provider.of<ChatRoomHelpers>(context, listen: false).chatRoomAvatarUrl =
          url.toString();
      print(
          "the chatroom avatar url=>${Provider.of<ChatRoomHelpers>(context, listen: false).chatRoomAvatar}");
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getuserUid)
        .set(data);
  }

  Future createChatroomCollection(
      BuildContext context, String chatroomname, dynamic chatdata) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomname)
        .set(chatdata);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getuserUid)
        .get()
        .then((doc) {
      initUserName = doc.data()!['username'];
      initUserEmail = doc.data()!['useremail'];
      initUserImage = doc.data()!['userimage'];
      print(initUserName);
      print(initUserEmail);
      print(initUserImage);
      notifyListeners();
    });
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String userid, dynamic collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(userid)
        .delete()
        .then((value) => null);
  }

  Future updateCaption(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future followUser(String followingUid, followingDocId, dynamic followingData,
      String followerUid, followerDocId, dynamic followerData) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }
}
