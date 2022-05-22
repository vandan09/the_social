import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/HomePage/HomePage.dart';
import 'package:the_social/screens/LandingPage/LandingUtils.dart';
import 'package:the_social/screens/LandingPage/Landingpage.dart';
import 'package:the_social/services/FirebaseOperation.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String? userUid;
  String? get getuserUid => userUid;
  void toast(String data) {
    Fluttertoast.showToast(
        msg: data,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        timeInSecForIosWeb: 10);
  }

  Future logIntoAccount(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      userUid = user?.uid;
      print(userUid);
      toast('Logged in');
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: HomePage(), type: PageTransitionType.bottomToTop));
    } catch (e) {
      toast(e.toString());
    }
    notifyListeners();
  }

  Future createAccount(
      BuildContext context, String email, String password, String name) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      userUid = user?.uid;
      toast('Account created');

      print(userUid);
      Provider.of<FirebaseOperations>(context, listen: false)
          .createUserCollection(context, {
        'userid':
            Provider.of<Authentication>(context, listen: false).getuserUid,
        'useremail': email,
        'username': name,
        'userimage':
            Provider.of<LandingUtils>(context, listen: false).getUserAvatarUrl,
      }).whenComplete(() {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: Landingpage(), type: PageTransitionType.bottomToTop));
      });
    } catch (exception) {
      toast(exception.toString());
    }

    notifyListeners();
  }

  Future logOutViaEmail() async {
    firebaseAuth.signOut();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    final AuthCredential authentication = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken);

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authentication);
    final User? user = userCredential.user;
    assert(user!.uid != null);

    userUid = user!.uid;
    print('Google user uid=>$userUid');
    notifyListeners();
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signIn();
  }
}
