import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rigel/screens/login/phoneVerification.dart';
import 'package:rigel/services/auth.dart';


class PhoneInputScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    AuthService auth = AuthService();

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Confirmación de la cuenta", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Text("Introduce tu teléfono y pulsa el botón de solicitar código para poder confirmar tu cuenta", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child:TextField(
                      controller: myController,
                    ),
                )
              ],
            ),
            FlatButton(
              padding: EdgeInsets.all(20),
              color: Colors.black,
              onPressed: () async {
                if (user != null) {
                  auth.phone2Factor(myController.text);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PinCodeVerificationScreen(myController.text)),);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
