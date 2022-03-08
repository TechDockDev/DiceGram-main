import 'package:flutter/material.dart';
import 'package:dicegram/snake_ladder/consts/snakes_ladders.dart';

class ImageItem extends StatelessWidget {
  const ImageItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -35,
          left: 70,
          child: Image.asset(
            SnakesLaddersConst.snake,
            height: 180,
            width: 60,
          ),
        ),
        Positioned(
          top: 45,
          left: 215,
          child: Image.asset(
            SnakesLaddersConst.snake,
            height: 180,
            width: 60,
          ),
        ),
        Positioned(
          top: 125,
          left: 70,
          child: Image.asset(
            SnakesLaddersConst.snake_two,
            height: 180,
            width: 60,
          ),
        ),
        Positioned(
          top: 40,
          left: -10,
          child: Image.asset(
            SnakesLaddersConst.ladders,
            height: 180,
            width: 60,
          ),
        ),
        Positioned(
          top: 128,
          right: 30,
          child: RotationTransition(
            turns: AlwaysStoppedAnimation(155 / 360),
            child: Image.asset(
              SnakesLaddersConst.ladders,
              height: 180,
              width: 60,
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 83,
          child: RotationTransition(
            turns: AlwaysStoppedAnimation(270 / 360),
            child: Image.asset(
             SnakesLaddersConst.ladders,
              height: 160,
              width: 70,
            ),
          ),
        ),
      ],
    );
  }
}
