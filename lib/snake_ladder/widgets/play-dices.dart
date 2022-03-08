import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dicegram/snake_ladder/consts/dices.dart';
import 'package:dicegram/snake_ladder/stores/snakes-ladders.dart';
import 'package:dicegram/snake_ladder/widgets/dice-item.dart';
import 'package:dicegram/snake_ladder/widgets/utils.dart';
import 'package:spring/spring.dart';

class PlayDices extends StatelessWidget {
  const PlayDices(
      {Key? key, required this.snakeLaddersStore, required this.dicesOne, required this.diceTwo})
      : super(key: key);
  final SnakesLadders snakeLaddersStore;
  final int dicesOne;
  final int diceTwo;

  @override
  Widget build(BuildContext context) {
    final random = Random();
    if(diceTwo>0){
      if(snakeLaddersStore.currentPlayer==2){
        if (snakeLaddersStore.totalPlayerOne == 100 ||
            snakeLaddersStore.totalPlayerTwo == 100) {
          Utils.dialogFinish(context);
        } else {
          snakeLaddersStore.play(diceTwo, context);
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: (){
              if(snakeLaddersStore.currentPlayer==1){
                if (snakeLaddersStore.totalPlayerOne == 100 ||
                    snakeLaddersStore.totalPlayerTwo == 100) {
                  Utils.dialogFinish(context);
                } else {
                  var diceOne = 1 + random.nextInt(5);
                  snakeLaddersStore.play(diceOne, context);
                }
              }
            },
            child: DiceItem(
              dice: DicesConst.dice(
                dicesOne.toString(),
              ),
              color : snakeLaddersStore.currentPlayer==1 ? Colors.transparent : Colors.black38,
              springController: SpringController(initialAnim: Motion.play),
            ),
          ),
        ],
      ),
    );
  }
}
