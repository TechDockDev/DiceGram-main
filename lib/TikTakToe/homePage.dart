// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print, curly_braces_in_flow_control_structures

import 'dart:math';
import 'package:dicegram/TikTakToe/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'TikTakToeDatabase.dart';
import 'customDialog.dart';
import 'gameButton.dart';

class TickTackToe extends StatefulWidget {
  const TickTackToe({
    Key? key,
    required this.gameRoomId,
    required this.firstName,
    required this.currentUser,
    required this.receiver,
  }) : super(key: key);
  final String gameRoomId;
  final String firstName;
  final String currentUser;
  final String receiver;

  @override
  _TickTackToe createState() => _TickTackToe();
}

class _TickTackToe extends State<TickTackToe> {
  List<GameButton>? buttonsList;
  List<int> player1 = [];
  List<int> player2 = [];
  String activePlayer = '';
  TikTakToeDatabase tikTakToeDatabase = TikTakToeDatabase();
  Stream? getTikTakToeDataStream;

  @override
  void initState() {
    activePlayer = widget.firstName;
    buttonsList = doInit();
    super.initState();
  }

  doInit() {
    String activePlayer = widget.firstName;

    List<GameButton> gameButtons = [
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];
    Map<String, dynamic> activePlayerMap = {'activePlayer': activePlayer};
    tikTakToeDatabase.saveActivePlayerInFirestore(
        activePlayerMap, widget.gameRoomId);

    String text = '';
    String bg = 'grey';
    bool enabled = false;

    for (var id = 1; id < 10; id++) {
      Map<String, dynamic> gameMap = {
        'id': id,
        'text': text,
        'background': bg,
        'enabled': enabled
      };
      tikTakToeDatabase.sendGameButtonData(widget.gameRoomId, gameMap, id);
    }

    tikTakToeDatabase.getButtonData(widget.gameRoomId).then((value) {
      setState(() {
        getTikTakToeDataStream = value;
      });
    });

    return gameButtons;
  }

  void playGame(GameButton gameButton, int id) async {
    activePlayer =
        await tikTakToeDatabase.getActivePlayerData(widget.gameRoomId);
    setState(() {
      if (activePlayer == widget.currentUser) {
        Map<String, dynamic> updateButtonDataMap =
            activePlayer == widget.firstName
                ? {
                    'id': id,
                    'text': "X",
                    'background': 'red',
                    'enabled': gameButton.enabled
                  }
                : {
                    'id': id,
                    'text': "O",
                    'background': 'black',
                    'enabled': gameButton.enabled
                  };
        tikTakToeDatabase.updateGameButtonData(
            widget.gameRoomId, updateButtonDataMap, gameButton.id);

        Map<String, List> playersListMap = {
          activePlayer.toString(): player1,
        };
        tikTakToeDatabase.sendTikTakToeData(widget.gameRoomId, playersListMap);

        activePlayer = widget.receiver;
        tikTakToeDatabase.updateActivePlayerInFirestore(
            activePlayer, widget.gameRoomId);

        checkWinner().then((value) {
          print('WINNERS');
          print(value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getTikTakToeDataStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            // GriDelegate controlls the layout of GridView
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    //TO Change Size here
                                    crossAxisCount: 3,
                                    childAspectRatio: 1.0,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0),
                            itemCount: snapshot.data.docs.length, // 9 buttons
                            itemBuilder: (context, i) {
                              var taju = tikTakToeDatabase
                                  .getActivePlayerData(widget.gameRoomId);
                              return ButtonTheme(
                                minWidth: 50,
                                height: 50,
                                child: RaisedButton(
                                  padding: const EdgeInsets.all(8.0),
                                  // if enabled, call a function
                                  onPressed:
                                      snapshot.data.docs[i].data()['enabled'] ==
                                              false
                                          ? () {
                                              playGame(buttonsList![i], i);
                                            }
                                          : null,
                                  child: Text(
                                    snapshot.data.docs[i].data()['text'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 40.0),
                                  ),
                                  color: snapshot.data.docs[i]
                                              .data()['background'] ==
                                          'grey'
                                      ? Colors.grey
                                      : snapshot.data.docs[i]
                                                  .data()['background'] ==
                                              'red'
                                          ? Colors.red
                                          : Colors.green[700],
                                  disabledColor: snapshot.data.docs[i]
                                              .data()['background'] ==
                                          'grey'
                                      ? Colors.grey
                                      : snapshot.data.docs[i]
                                                  .data()['background'] ==
                                              'red'
                                          ? Colors.red
                                          : Colors.green[700],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // ElevatedButton(onPressed: (){}, child: Text(activePlayer.toString())),
                      SizedBox(height: 50),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ElevatedButton(
                          child: Text(
                            "Reset",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0),
                          ),
                          onPressed: resetGame,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else
            return Container();
        });
  }

  Future<String> getPlayerListData(int id) async {
    var g = await tikTakToeDatabase.getPlayerListData(widget.gameRoomId, id);
    return g;
  }

// Simple
  Future<int> checkWinner() async {
    var winner = -1;
    var id1 = await getPlayerListData(1);
    var id2 = await getPlayerListData(2);
    var id3 = await getPlayerListData(3);
    var id4 = await getPlayerListData(4);
    var id5 = await getPlayerListData(5);
    var id6 = await getPlayerListData(6);
    var id7 = await getPlayerListData(7);
    var id8 = await getPlayerListData(8);
    var id9 = await getPlayerListData(9);

    if (id1 == 'O' && id2 == 'O' && id3 == 'O') {
      winner = 1;
    }
    if (id1 == 'X' && id2 == 'X' && id3 == 'X') {
      winner = 2;
    }

    // row 2
    if (id4 == 'O' && id5 == 'O' && id6 == 'O') {
      winner = 1;
    }
    if (id4 == 'X' && id5 == 'X' && id6 == 'X') {
      winner = 2;
    }
//ROW 3
    if (id7 == 'O' && id8 == 'O' && id9 == 'O') {
      winner = 1;
    }
    if (id7 == 'X' && id8 == 'X' && id9 == 'X') {
      winner = 2;
    }

// Column 1
    if (id1 == 'O' && id4 == 'O' && id7 == 'O') {
      winner = 1;
    }
    if (id1 == 'X' && id4 == 'X' && id7 == 'X') {
      winner = 2;
    }

    // column 2
    if (id2 == 'O' && id5 == 'O' && id8 == 'O') {
      winner = 1;
    }
    if (id2 == 'X' && id5 == 'X' && id8 == 'X') {
      winner = 2;
    }
//column 3
    if (id3 == 'O' && id6 == 'O' && id9 == 'O') {
      winner = 1;
    }
    if (id3 == 'X' && id6 == 'X' && id9 == 'X') {
      winner = 2;
    }

// Digonal
    if (id1 == 'O' && id5 == 'O' && id9 == 'O') {
      winner = 1;
    }
    if (id1 == 'X' && id5 == 'X' && id9 == 'X') {
      winner = 2;
    }
//digonal 2
    if (id3 == 'O' && id5 == 'O' && id7 == 'O') {
      winner = 1;
    }
    if (id3 == 'X' && id5 == 'X' && id7 == 'X') {
      winner = 2;
    }

    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => CustomDialog("Player 1 Won",
                "Press the reset button to start again.", resetFromDialogGame));
      } else {
        showDialog(
            context: context,
            builder: (_) => CustomDialog("Player 2 Won",
                "Press the reset button to start again.", resetFromDialogGame));
      }
    }
    return winner;
  }

  void resetFromDialogGame() {
    buttonsList = doInit();
    Navigator.pop(context);
  }

  void resetGame() {
    buttonsList = doInit();
  }
}
