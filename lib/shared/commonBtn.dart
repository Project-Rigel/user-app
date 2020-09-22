import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String text;

  const CommonButton({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(61, 225, 182, .6)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Color.fromRGBO(53, 255, 170, 1),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
