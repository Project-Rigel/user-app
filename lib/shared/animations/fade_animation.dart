import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { color, offset }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
      ..add(AniProps.color, Tween(begin: 0.0, end: 1.0),
          Duration(milliseconds: 500))
      ..add(AniProps.offset, Tween(begin: -30.0, end: 0.0),
          Duration(milliseconds: 500), Curves.easeOut);

    return PlayAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AniProps.color),
        child: Transform.translate(
            offset: Offset(0, value.get(AniProps.offset)), child: child),
      ),
    );
  }
}
