import 'package:flutter/material.dart';

class CountDown extends AnimatedWidget {
  CountDown({this.animation}) : super(listenable: animation);
  Animation<int> animation;
  @override
  Widget build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);
    var timerText =
        "${clockTimer.inMinutes.remainder(60).toString().padLeft(2, "0")} : ${clockTimer.inSeconds.remainder(60).toString().padLeft(2, "0")}";
    return Text(
      "${timerText}",
      style: TextStyle(fontSize: 40, color:Colors.black87),
    );
  }
}
