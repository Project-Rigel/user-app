import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final Firestore _db = Firestore.instance;

    Future<bool> isUserVerified(FirebaseUser user) async {
      DocumentSnapshot snapshot =
          await _db.collection('customers').document(user.uid).get();
      bool verified = await snapshot['verified'];

      if (verified == true) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, "/verification");
      }
      return verified;
    }

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
            isUserVerified(user);
          } else {
            showAlertDialog(context);
          }
        },
        label: Expanded(
          child: Text('$text', textAlign: TextAlign.center),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error",
          style: TextStyle(color: Color.fromRGBO(61, 225, 182, .6))),
      content:
          Text("Algo ha salido mal, prueba otro método de inicio de sesión"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
