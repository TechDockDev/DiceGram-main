import 'package:flutter/material.dart';
import 'package:demoji/demoji.dart';

class AvatarPlayer extends StatelessWidget {
  const AvatarPlayer({Key? key, required this.player, required this.size}) : super(key: key);
  final int player;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size),
      child: Container(
        height: 30,
        width: 30,
        child: player == 1
            ? Text(
                Demoji.running_woman,
                style: TextStyle(fontSize: 18),
              )
            : Text(Demoji.running_man, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
