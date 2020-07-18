import 'package:flutter/material.dart';
import 'package:rigel/services/auth.dart';
import 'package:rigel/shared/animations/fade_animation.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthService auth = AuthService();

  bool _autoValidate = false;
  String _name;
  String _surname;
  String _email;
  String _password;
  String _passrepeat;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: formUI(),
      ),
    );
  }

  Widget formUI() {
    return new Column(
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
              child: new Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[100]))),
                    child: new TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Nombre",
                          hintStyle: TextStyle(color: Colors.grey[400])),
                      keyboardType: TextInputType.text,
                      validator: validateName,
                      onSaved: (String val) {
                        _name = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[100]))),
                    child: new TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Apellidos",
                          hintStyle: TextStyle(color: Colors.grey[400])),
                      keyboardType: TextInputType.text,
                      validator: validateName,
                      onSaved: (String val) {
                        _surname = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[100]))),
                    child: new TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.grey[400])),
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                      onSaved: (String val) {
                        _email = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[100]))),
                    child: new TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Contraseña",
                          hintStyle: TextStyle(color: Colors.grey[400])),
                      keyboardType: TextInputType.text,
                      validator: validateName,
                      onSaved: (String val) {
                        _password = val;
                      },
                      onChanged: (String value) {
                        _password = value;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: new TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Repite la Contraseña",
                          hintStyle: TextStyle(color: Colors.grey[400])),
                      keyboardType: TextInputType.text,
                      validator: validatePassword,
                      onChanged: (String val) {
                        _passrepeat = val;
                      },
                    ),
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 10,
        ),
        FadeAnimation(
            2,
            InkWell(
              onTap: _sendToServer,
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
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'Length must be more than 2 charater';
    else
      return null;
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value != _password) {
      print(_password);
      return "Passwords doesn't match";
    } else {
      return null;
    }
  }

  _sendToServer() {
    if (_formKey.currentState.validate()) {
      // No any error in validation
      _formKey.currentState.save();
      print("Email $_email");
      String displayName = _name + " " + _surname;
      auth.signUpWithEmail(
          email: _email, password: _password, name: displayName);
    } else {
      // validation error
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
