import 'package:flutter/material.dart';
import 'package:dicegram/snake_ladder/widgets/avatar-player.dart';

class Play extends StatelessWidget {
  const Play(
      {Key? key,
      required this.index,
      required this.totalPlayerOne,
      required this.totalPlayerTwo,
      required this.currentPlayer})
      : super(key: key);
  final int index, totalPlayerOne, totalPlayerTwo, currentPlayer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (totalPlayerOne == (100 - index))
          AvatarPlayer(
            player: 1,
            size: totalPlayerOne == totalPlayerTwo ? 8 : 3,
          ),
        if (totalPlayerTwo == (100 - index))
          AvatarPlayer(
            player: 2,
            size: 3,
          )
      ],
    );
  }
}
