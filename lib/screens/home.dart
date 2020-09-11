import 'package:flutter/material.dart';
import 'package:rigel/shared/circle_progress_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          // Max Size
          Container(
            color: Colors.blue,
          ),
          ProgressCard(),
          Container(
            color: Colors.pink,
            height: 150.0,
            width: 150.0,
          )
        ],
      ),
    );
  }
}

class ProgressCard extends StatefulWidget {
  @override
  _ProgressCardState createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  double progressPercent = 0;

  @override
  Widget build(BuildContext context) {
    Color foreground = Colors.red;

    if (progressPercent >= 0.8) {
      foreground = Colors.green;
    } else if (progressPercent >= 0.4) {
      foreground = Colors.orange;
    }

    Color background = foreground.withOpacity(0.2);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: CircleProgressBar(
                backgroundColor: background,
                foregroundColor: foreground,
                value: this.progressPercent,
              ),
              onTap: () {
                final updated =
                    ((this.progressPercent + 0.1).clamp(0.0, 1.0) * 100);
                setState(() {
                  this.progressPercent = updated.round() / 100;
                });
              },
              onDoubleTap: () {
                final updated =
                    ((this.progressPercent - 0.1).clamp(0.0, 1.0) * 100);
                setState(() {
                  this.progressPercent = updated.round() / 100;
                });
              },
            ),
          ),
        ),
        Text("${this.progressPercent * 100}%"),
      ],
    );
  }
}
