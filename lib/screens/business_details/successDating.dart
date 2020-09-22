import 'package:flutter/material.dart';
import 'package:rigel/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccessDating extends StatefulWidget {
  const SuccessDating({Key key, this.business}) : super(key: key);
  final Bussiness business;

  @override
  _SuccessDatingState createState() => _SuccessDatingState();
}

class _SuccessDatingState extends State<SuccessDating> {
  String dateString;
  Future<String> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    dateString = prefs.getString('dateSelected');
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    getStringValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Su cita se ha confirmado",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 25,
        ),
        Text("Visita:",
            style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2)),
        Text(
          dateString ?? "",
          style: TextStyle(
              color: Colors.grey[400],
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2),
        ),
        Image.network(
            "https://media-exp1.licdn.com/dms/image/C511BAQFGPRVBNp59Fg/company-background_10000/0?e=2159024400&v=beta&t=VIsbHPppejbBJGuQNkXeypF_yBpQgHo-hJrlvjlitnM",
            height: MediaQuery.of(context).size.height / 3),
        Text(
          widget.business.name,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    ));
  }
}
