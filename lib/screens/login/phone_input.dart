import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rigel/screens/login/phone_verification.dart';
import 'package:rigel/services/auth.dart';
import 'package:rigel/shared/animations/fade_animation.dart';
import 'package:rxdart/rxdart.dart';

class PhoneInputScreen extends StatefulWidget {
  @override
  _PhoneInputScreenState createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen>
    with AutomaticKeepAliveClientMixin {
  PageController _controller =
      new PageController(initialPage: 0, viewportFraction: 1.0);

  bool hasError = false;

  StreamController<ErrorAnimationType> errorController;

  TextEditingController textEditingController = TextEditingController();
  final myPhoneController = TextEditingController();

  String currentText = "";
  String inputPhone;

  @override
  void initState() {
    errorController = BehaviorSubject<ErrorAnimationType>();
    super.initState();
    textEditingController?.addListener(updateKeepAlive);
  }

  @override
  void dispose() {
    errorController.close();
    textEditingController?.removeListener(updateKeepAlive);
    textEditingController.dispose();
    super.dispose();
  }

  gotoVerification() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      1,
      duration: Duration(milliseconds: 800),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return Material(
      child: Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            physics: new AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              phoneInputWidget(context),
              verificationCodeWidget(context),
            ],
            scrollDirection: Axis.horizontal,
          )),
    );
  }

  Widget verificationCodeWidget(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    AuthService auth = AuthService();

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 20.0,
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Center(
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/message.png'))),
                                ),
                              ),
                            )),
                      ),
                      Positioned(
                          width: MediaQuery.of(context).size.width,
                          top: MediaQuery.of(context).size.height / 3.3,
                          child: FadeAnimation(
                              2.0,
                              Container(
                                  margin: EdgeInsets.all(20.0),
                                  child: Text(
                                    "Introduce el código recibido mediante SMS y pulsa el botón enviar para poder verificar tu cuenta",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2),
                                  )))),
                      Positioned(
                        width: MediaQuery.of(context).size.width,
                        top: MediaQuery.of(context).size.height / 2.3,
                        child: FadeAnimation(
                            1.8,
                            Center(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 30),
                                  child: PinCodeTextField(
                                    autoDisposeControllers: false,
                                    length: 6,
                                    obsecureText: false,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      selectedColor:
                                          Theme.of(context).primaryColor,
                                      selectedFillColor:
                                          Theme.of(context).primaryColorLight,
                                      inactiveColor:
                                          Theme.of(context).primaryColorLight,
                                      inactiveFillColor: Colors.white,
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(10),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      activeFillColor:
                                          hasError ? Colors.red : Colors.white,
                                    ),
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    backgroundColor: Colors.white,
                                    enableActiveFill: true,
                                    errorAnimationController: errorController,
                                    controller: textEditingController,
                                    onCompleted: (v) {
                                      print("Completed");
                                    },
                                    onChanged: (value) {
                                      print(value);
                                      setState(() {
                                        currentText = value;
                                      });
                                    },
                                    beforeTextPaste: (text) {
                                      print("Allowing to paste $text");
                                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                      return true;
                                    },
                                  )),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    hasError
                        ? "* Hay que rellenar las celdas correctamente"
                        : "",
                    style: TextStyle(color: Colors.red.shade300, fontSize: 15),
                  ),
                ),
                FadeAnimation(
                    2,
                    InkWell(
                      onTap: () async {
                        if (currentText.length != 6) {
                          errorController.add(ErrorAnimationType
                              .shake); // Triggering error shake animation
                          setState(() {
                            hasError = true;
                          });
                        } else {
                          try {
                            bool success = await auth.phoneVerification(
                                currentText, inputPhone, context);
                            setState(() {
                              if (success) {
                                hasError = false;
                              } else {
                                hasError = true;
                              }
                            });
                          } catch (e) {
                            errorController.add(ErrorAnimationType.shake);
                            setState(() {
                              hasError = true;
                            });
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(53, 255, 170, 1),
                              Color.fromRGBO(61, 225, 182, .6),
                            ])),
                        child: Center(
                          child: Text(
                            "Enviar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  Widget phoneInputWidget(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    AuthService auth = AuthService();

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 20.0,
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Center(
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/phone_verification.png'))),
                                ),
                              ),
                            )),
                      ),
                      Positioned(
                          width: MediaQuery.of(context).size.width,
                          top: MediaQuery.of(context).size.height / 3.3,
                          child: FadeAnimation(
                              2.0,
                              Container(
                                  margin: EdgeInsets.all(20.0),
                                  child: Text(
                                    "Introduce tu teléfono y pulsa el botón enviar para poder verificar tu cuenta",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2),
                                  )))),
                      Positioned(
                        width: MediaQuery.of(context).size.width,
                        top: MediaQuery.of(context).size.height / 2.5,
                        child: FadeAnimation(
                            1.8,
                            Center(
                              child: Container(
                                  margin: EdgeInsets.all(20.0),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                143, 148, 251, .2),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: new TextField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Telefono",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                      keyboardType: TextInputType.phone,
                                      controller: myPhoneController,
                                    ),
                                  )),
                            )),
                      )
                    ],
                  ),
                ),
                FadeAnimation(
                    2,
                    InkWell(
                      onTap: () async {
                        if (user != null) {
                          inputPhone = myPhoneController.text;
                          auth.phone2Factor(myPhoneController.text);
                          gotoVerification();
                        }
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(53, 255, 170, 1),
                              Color.fromRGBO(61, 225, 182, .6),
                            ])),
                        child: Center(
                          child: Text(
                            "Enviar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => textEditingController?.text?.isNotEmpty == true;
}
