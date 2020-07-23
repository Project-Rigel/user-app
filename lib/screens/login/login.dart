import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:rigel/screens/login/widgets/loginBtn.dart';
import 'package:rigel/screens/login/widgets/loginForm.dart';
import 'package:rigel/services/services.dart';
import 'dart:async';

import 'package:rigel/shared/animations/fade_animation.dart';

class LoginScreen extends StatefulWidget {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();
  final Firestore _db = Firestore.instance;

  @override
  void initState() {
    super.initState();
    auth.getUser.then((user) {
      if (user != null) {
        auth.isUserVerified(user).then((val) {
          if (val == true) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Navigator.pushReplacementNamed(context, "/verification");
          }
          print("success");
        }).catchError((error, stackTrace) {
          print("outer: $error");
        });
      } //TODO modal saying service not available
    });
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('o'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  static final emailController = TextEditingController();
  static final passController = TextEditingController();
  final emailField = TextField(
    controller: emailController,
    decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.grey[400])),
  );
  final passwordField = TextField(
    controller: passController,
    obscureText: true,
    decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Contraseña",
        hintStyle: TextStyle(color: Colors.grey[400])),
  );

  PageController _controller =
      new PageController(initialPage: 0, viewportFraction: 1.0);

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignup() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      1,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            physics: new AlwaysScrollableScrollPhysics(),
            children: <Widget>[loginWidget(), signupWidget()],
            scrollDirection: Axis.horizontal,
          )),
    );
  }

  Widget loginWidget() {
    final headerHeight = MediaQuery.of(context).size.height / 3;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: headerHeight,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/flutter_clip.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 70,
                        height: headerHeight / 1.8,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 70,
                        height: headerHeight / 2.5,
                        child: FadeAnimation(
                            1.3,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 50,
                        height: headerHeight / 2.5,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: AssetImage('assets/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 40),
                              child: Center(
                                child: Container(
                                  width: headerHeight / 1.5,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/gni_logo_white.png'))),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: emailField,
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: passwordField,
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          1.5,
                          Text(
                            "¿Contraseña olvidada?",
                            style: TextStyle(
                                color: Color.fromRGBO(61, 225, 182, .6)),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      FadeAnimation(
                          2,
                          InkWell(
                            onTap: () async {
                              var user = await auth.loginWithEmail(
                                  email: emailController.text,
                                  password: passController.text);
                              if (user != null) {
                                auth.isUserVerified(user).then((val) {
                                  if (val == true) {
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  } else {
                                    Navigator.pushReplacementNamed(
                                        context, "/verification");
                                  }
                                  print("success");
                                }).catchError((error, stackTrace) {
                                  print("outer: $error");
                                });
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(53, 255, 170, 1),
                                    Color.fromRGBO(61, 225, 182, .6),
                                  ])),
                              child: Center(
                                child: Text(
                                  "Iniciar Sesión",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                          2,
                          InkWell(
                            onTap: gotoSignup,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(61, 225, 182, .6),
                                    Color.fromRGBO(53, 255, 170, 1),
                                  ])),
                              child: Center(
                                child: Text(
                                  "Registrase",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      FadeAnimation(
                        1.5,
                        _divider(),
                      ),
                      FadeAnimation(
                        2.1,
                        LoginButton(
                          text: 'LOGIN WITH GOOGLE',
                          icon: FontAwesomeIcons.google,
                          color: Colors.white,
                          loginMethod: auth.googleSignIn,
                        ),
                      ),
                      FadeAnimation(
                          2.1,
                          FutureBuilder<Object>(
                            future: auth.appleSignInAvailable,
                            builder: (context, snapshot) {
                              if (snapshot.data == true) {
                                return AppleSignInButton(
                                  cornerRadius: 10.0,
                                  style: ButtonStyle.black,
                                  onPressed: () async {
                                    FirebaseUser user =
                                        await auth.appleSignIn();
                                    if (user != null) {
                                      auth.isUserVerified(user).then((val) {
                                        if (val == true) {
                                          Navigator.pushReplacementNamed(
                                              context, '/home');
                                        } else {
                                          Navigator.pushReplacementNamed(
                                              context, "/verification");
                                        }
                                        print("success");
                                      }).catchError((error, stackTrace) {
                                        print("outer: $error");
                                      });
                                    }
                                  },
                                );
                              } else {
                                return Container();
                              }
                            },
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget signupWidget() {
    final headerHeight = MediaQuery.of(context).size.height / 3;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: headerHeight,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/flutter_clip-2.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Center(
                                child: Container(
                                  width: headerHeight / 1.5,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/gni_logo_white.png'))),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: LoginForm(),
                )
              ],
            ),
          ),
        ));
  }
  /*@override
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlutterLogo(
                  size: 150,
                ),
                SizedBox(height: 5.0),
                Text(
                  'Rigel',
                  style: Theme.of(context).textTheme.headline,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.0),
                LoginForm(),
                SizedBox(height: 25.0),
                LoginButton(
                  text: 'LOGIN',
                  icon: FontAwesomeIcons.signInAlt,
                  color: Colors.black45,
                  //loginMethod: auth.loginWithEmail(),
                ),
                _divider(),
                LoginButton(
                  text: 'LOGIN WITH GOOGLE',
                  icon: FontAwesomeIcons.google,
                  color: Colors.black45,
                  loginMethod: auth.googleSignIn,
                ),
                SizedBox(height: 25.0),
                FutureBuilder<Object>(
                  future: auth.appleSignInAvailable,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return AppleSignInButton(
                        onPressed: () async {
                          FirebaseUser user = await auth.appleSignIn();
                          if (user != null) {
                            Navigator.pushReplacementNamed(context, '/topics');
                          }
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                LoginButton(
                    text: 'Continue as Guest', loginMethod: auth.anonLogin),
                _createAccountLabel()
              ],
            ),
          )),
    );
  }*/
}
