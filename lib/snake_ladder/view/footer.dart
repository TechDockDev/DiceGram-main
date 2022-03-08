import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicegram/snake_ladder/stores/snakes-ladders.dart';
import 'package:dicegram/snake_ladder/widgets/play-dices.dart';

class Footer extends StatelessWidget {
  const Footer({ Key? key, required this.snakeLaddersStore, required this.diceTwo}) : super(key: key);
  final SnakesLadders snakeLaddersStore;
  final int diceTwo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        Observer(
          name: 'PlayDices',
          builder: (BuildContext context) {
            return PlayDices(
              snakeLaddersStore: snakeLaddersStore,
              dicesOne: snakeLaddersStore.currentDiceOne,
              diceTwo : diceTwo
            );
          },
        ),
      ],
    );
  }
}
