import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/screens/LandingPage/LandingServices.dart';
import 'package:the_social/services/Authentication.dart';
import 'dart:io';

import 'package:the_social/services/FirebaseOperation.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController captioController = TextEditingController();
  File? uploadPostImage;
  File? get getUploadPostImage => uploadPostImage;
  String? uploadPostImageUrl;
  String? get getUploadPostImageUrl => uploadPostImageUrl;
  UploadTask? imagePostUploadTask;

  final picker = ImagePicker();
  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    uploadPostImageVal == null
        ? print('Select Image')
        : uploadPostImage = File(uploadPostImageVal.path);
    // print(uploadPostImageVal!.path);

    uploadPostImage != null
        ? showPostImage(context)
        : Fluttertoast.showToast(msg: "Image Upload Error");
    notifyListeners();
  }

  Future imageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('post/${uploadPostImage!.path}/${TimeOfDay.now()}');

    imagePostUploadTask = imageReference.putFile(uploadPostImage!);
    await imagePostUploadTask!.whenComplete(() {
      print('image uploaded to firebase');
    });
    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImage);
    });
    notifyListeners();
  }

  selectPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: constantColors.blueColor,
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.gallery);
                          // Navigator.pop(context);
                        },
                        child: Text(
                          'Gallery',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                    MaterialButton(
                        color: constantColors.blueColor,
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.camera);
                          // Navigator.pop(context);
                        },
                        child: Text(
                          'Camera',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Container(
                    height: 200,
                    width: 400,
                    child: Image.file(
                      uploadPostImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          color: constantColors.redColor,
                          child: Text(
                            'Reselect',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                // decoration: TextDecoration.underline,
                                decorationColor: constantColors.whiteColor),
                          ),
                          onPressed: () {
                            selectPostImage(context);
                          }),
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Confirm Image',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            imageToFirebase().whenComplete(() {
                              editPostSheet(context);
                              print('image uploade');
                            });
                          })
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      child: Column(children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.image_aspect_ratio,
                            color: constantColors.greenColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.fit_screen,
                            color: constantColors.yellowColor,
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      height: 200,
                      width: 300,
                      child: Image.file(
                        uploadPostImage!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Icon(Icons.surfing_outlined),
                    ),
                    Container(
                      height: 110,
                      width: 5,
                      color: constantColors.blueColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        height: 120,
                        width: 330,
                        child: TextField(
                          maxLines: 5,
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100)
                          ],
                          maxLength: 100,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          controller: captioController,
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Add Caption',
                            hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FloatingActionButton(
                backgroundColor: constantColors.blueColor,
                onPressed: () {},
                child: Icon(
                  FontAwesomeIcons.check,
                  color: constantColors.whiteColor,
                ),
              ),
              MaterialButton(
                  color: constantColors.blueColor,
                  onPressed: () async {
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .uploadPostData(captioController.text, {
                      'postimage': getUploadPostImageUrl,
                      'caption': captioController.text,
                      'username': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .initUserName,
                      'userimage': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .initUserImage,
                      'useremail': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .initUserEmail,
                      'useruid':
                          Provider.of<Authentication>(context, listen: false)
                              .getuserUid,
                      'time': Timestamp.now()
                    }).whenComplete(() async {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getuserUid)
                          .collection('posts')
                          .add({
                        'postimage': getUploadPostImageUrl,
                        'caption': captioController.text,
                        'username': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .initUserName,
                        'userimage': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .initUserImage,
                        'useremail': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .initUserEmail,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getuserUid,
                        'time': Timestamp.now()
                      });
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Share',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
            ]),
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        });
  }
}
