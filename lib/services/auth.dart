import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  String mVerificationId;

  // Firebase user one-time fetch
  Future<FirebaseUser> get getUser => _auth.currentUser();

  // Firebase user a realtime stream
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  // Determine if Apple Signin is available on device
  Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  /// Sign in with Apple
  Future<FirebaseUser> appleSignIn() async {
    try {
      final AuthorizationResult appleResult =
          await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        // handle errors from Apple
      }

      final AuthCredential credential =
          OAuthProvider(providerId: 'apple.com').getCredential(
        accessToken:
            String.fromCharCodes(appleResult.credential.authorizationCode),
        idToken: String.fromCharCodes(appleResult.credential.identityToken),
      );

      AuthResult firebaseResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = firebaseResult.user;

      //New User
      if (firebaseResult.additionalUserInfo.isNewUser) {
        newUserData(user);
      }
      // Update user data
      updateUserData(user);

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// Sign in with Google
  Future<FirebaseUser> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;

      //New User
      if (result.additionalUserInfo.isNewUser) {
        newUserData(user);
      }
      // Update user data
      updateUserData(user);

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// Sign in with Phone
  Future<void> phone2Factor(String phone) async {
    try {
      String phoneNum = "+34" + phone;
      log('data: $phoneNum');
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNum,
          timeout: Duration(seconds: 0),
          verificationCompleted: (authCredential) =>
              _verificationComplete(authCredential),
          verificationFailed: (authException) => log(authException.message),
          codeSent: (String verificationId, [int code]) =>
              _codeSent(verificationId, code),
          codeAutoRetrievalTimeout: null);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<FirebaseUser> loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<FirebaseUser> signUpWithEmail({
    @required String email,
    @required String password,
    @required String name,
  }) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //New User
      if (authResult.additionalUserInfo.isNewUser) {
        newUserData(authResult.user, name);
      }
      // Update user data
      updateUserData(authResult.user);
      return authResult.user;
    } catch (e) {
      return e.message;
    }
  }

  /// Anonymous Firebase login
  Future<FirebaseUser> anonLogin() async {
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;

    updateUserData(user);
    return user;
  }

  /// Creates the User's data in Firestore on first login
  Future<void> newUserData(FirebaseUser user, [String name]) {
    DocumentReference reportRef =
        _db.collection('customers').document(user.uid);
    if (name != null) {
      UserUpdateInfo info = new UserUpdateInfo();
      info.displayName = name;
      info.photoUrl =
          "https://firebasestorage.googleapis.com/v0/b/rigel-admin.appspot.com/o/userapp%2Funknown_profile.png?alt=media&token=0dfd930d-60c9-4a8c-be1b-8802f6d9685d";
      user.updateProfile(info);
    }

    return reportRef.setData(
        {'uid': user.uid, 'creationDate': DateTime.now(), 'verified': false},
        merge: true);
  }

  /// Updates the User's data in Firestore on each new login
  Future<void> updateUserData(FirebaseUser user) {
    DocumentReference reportRef =
        _db.collection('customers').document(user.uid);

    return reportRef.setData({'lastActivity': DateTime.now()}, merge: true);
  }

  Future<void> onUserVerificationComplete(FirebaseUser user, String phone) {
    DocumentReference reportRef =
        _db.collection('customers').document(user.uid);

    reportRef.setData({'verified': true, 'phoneNumber': phone}, merge: true);
  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }

  _verificationComplete(AuthCredential authCredential) {
    FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  _codeSent(String verificationId, [int forceResendingToken]) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("smsVerificationId", verificationId);
    mVerificationId = verificationId;
  }

  phoneVerification(String smsCode) async {
    print(mVerificationId);
    Future<bool> phoneVerification(String smsCode, BuildContext context) async {
      final prefs = await SharedPreferences.getInstance();
      mVerificationId = prefs.getString('smsVerificationId') ?? '';
      bool success;
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: mVerificationId,
        smsCode: smsCode,
      );
      print(credential);

      FirebaseUser actualUser = await _auth.currentUser();
      await actualUser.linkWithCredential(credential).then((value) {
        success = true;
        Navigator.pushReplacementNamed(context, '/home');
      }).catchError((error) => success = false);
      return success;
    }
  }
}
