import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:rigel/screens/login/widgets/loginForm.dart';
import 'package:rigel/services/services.dart';

class LoginScreen extends StatefulWidget {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    auth.getUser.then(
      (user) {
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/topics');
        }
      },
    );
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

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No tienes una cuenta ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Registrarse',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  final emailField = TextField(
    obscureText: false,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
  );
  final passwordField = TextField(
    obscureText: true,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Contraseña",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
  );

  @override
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
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key key, this.text, this.icon, this.color, this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: FlatButton.icon(
        padding: EdgeInsets.all(20),
        icon: Icon(icon, color: Colors.white),
        color: color,
        onPressed: () async {
          var user = await loginMethod();
          if (user != null) {
            Navigator.pushReplacementNamed(context, '/topics');
          }
        },
        label: Expanded(
          child: Text('$text', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
