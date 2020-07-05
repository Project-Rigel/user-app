import 'package:flutter/material.dart';

class TopContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final EdgeInsets padding;
  TopContainer({this.height, this.width, this.child, this.padding});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding!=null ? padding : EdgeInsets.symmetric(horizontal: 10.0, vertical:  5.0),
      decoration: BoxDecoration(
          image: new DecorationImage(image: NetworkImage("https://media-exp1.licdn.com/dms/image/C511BAQFGPRVBNp59Fg/company-background_10000/0?e=2159024400&v=beta&t=VIsbHPppejbBJGuQNkXeypF_yBpQgHo-hJrlvjlitnM",),fit: BoxFit.cover),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          )),
      height: height,
      width: width,
      child: child,
    );
  }
}