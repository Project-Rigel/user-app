import 'package:flutter/material.dart';
import 'package:rigel/services/auth.dart';

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
    AuthService auth = AuthService();
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 10),
      child: FlatButton.icon(
        padding: EdgeInsets.all(10),
        shape: new RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: new BorderRadius.circular(10.0)),
        icon: Icon(icon, color: Theme.of(context).primaryColor),
        color: color,
        onPressed: () async {
          var user = await loginMethod();
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
          }
        },
        label: Expanded(
          child: Text('$text', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
