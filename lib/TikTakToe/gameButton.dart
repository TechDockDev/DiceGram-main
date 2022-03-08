import 'package:flutter/material.dart';

class GameButton {
  final int id;
  String text; // X or 0
  Color bg; // backGround color, Red or black
  bool enabled; // if pressed before, cant press again. Default always enabled.

  GameButton(
      {required this.id, this.text = "", this.bg = Colors.grey, this.enabled = true});
}