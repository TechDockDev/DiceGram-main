import 'package:demoji/demoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dicegram/snake_ladder/stores/snakes-ladders.dart';
import 'package:get_it/get_it.dart';

class Utils {
  SnakesLadders? snakesLaddersStore;

  Utils({SnakesLadders? snakesLaddersStore}) {
    this.snakesLaddersStore = snakesLaddersStore;
  }

  static dialogWin(context, player) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text(
              'Congratulation, you won ' + Demoji.star2,
              style: TextStyle(color: Colors.black54),
            ),
            content: Text(
              'Player ' + player.toString() + ' is the winner!',
              style: TextStyle(color: Colors.black45),
            ),
            backgroundColor: Colors.orange[100],
            elevation: 10,
            actions: [
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                      },
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        });
  }

dialogRulesWin(context, player, total) {
  this.snakesLaddersStore = GetIt.instance<SnakesLadders>();
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'You almost won ' + Demoji.boom,
              style: TextStyle(color: Colors.black54),
            ),
            content: Text(
              'Player ' +
                  player.toString() +
                  ' need to take exactly the number of houses left, you will return the number of houses left!',
              style: TextStyle(color: Colors.black45),
            ),
            backgroundColor: Colors.orange[100],
            elevation: 10,
            actions: [
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                        snakesLaddersStore!.setPlayers(player, (100 -(total - 100)))
                      },
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        });
  }

  static dialogFinish(context) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Game is over...' + Demoji.warning,
              style: TextStyle(color: Colors.black54),
            ),
            content: Text(
              'Start a new game.',
              style: TextStyle(color: Colors.black45),
            ),
            backgroundColor: Colors.orange[100],
            elevation: 10,
            actions: [
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                      },
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        });
  }

  dialogRules(context, element, currentPlayer) {
   this.snakesLaddersStore = GetIt.instance<SnakesLadders>();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              element.first['title'],
              style: TextStyle(color: Colors.black54),
            ),
            content: Text(
              'Player ' + currentPlayer.toString() + element.first['message'],
              style: TextStyle(color: Colors.black45),
            ),
            backgroundColor: Colors.orange[100],
            elevation: 10,
            actions: [
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                        this.snakesLaddersStore!.setPlayers(currentPlayer, element.first['positionFuture'])
                      },
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        });
  }

    dialogRestart(context) {
   this.snakesLaddersStore = GetIt.instance<SnakesLadders>();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Do you want to start a new game?',
              style: TextStyle(color: Colors.black54),
            ),
            backgroundColor: Colors.orange[100],
            elevation: 10,
            actions: [
               TextButton(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                      },
                  child: Text(
                    "No",
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                        this.snakesLaddersStore!.restartPlayers()
                      },
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }
}
