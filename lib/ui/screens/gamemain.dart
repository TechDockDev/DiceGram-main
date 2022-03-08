/// Flutter code sample for IconButton

// This sample shows an `IconButton` that uses the Material icon "volume_up" to
// increase the volume.
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/material/icon_button.png)

import 'package:flutter/material.dart';


void main() => runApp(const GameBoard());

/// This is the main application widget.
class GameBoard extends StatelessWidget {
  const GameBoard({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Center(
          child: GameBoardStateLess.empty(),
        ),
      ),
    );
  }
}

double _volume = 0.0;

/// This is the stateful widget that the main application instantiates.
class GameBoardStateLess extends StatefulWidget {
  dynamic playerName1 = "";
  dynamic playerName2 = "";
  dynamic gameSelected;
  dynamic _roomId;
  dynamic userId;
  bool reset = false;
  VoidCallback onReset= (){};
  List<String>? playersSelected;
  List<dynamic>? playersSelectedDynamic;
  GameBoardStateLess.empty();
  GameBoardStateLess(this.gameSelected, this._roomId, this.userId,
      this.playersSelected, this.playersSelectedDynamic);
  @override
  State<GameBoardStateLess> createState() => GameBoardState();
  bool adLoaded = false;
}

/// This is the private State class that goes with MyStatefulWidget.
class GameBoardState extends State<GameBoardStateLess> {
  // Widget getGame() {
  //     return ChessGame.fromChatApp(widget._roomId, widget.userId,
  //         widget.playersSelectedDynamic, widget.onReset);
  //  // }
  // }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.playerName1 = widget.playersSelectedDynamic?.first.toString();
    widget.playerName2 = widget.playersSelectedDynamic?.last.toString();

    // if (widget.playersSelectedDynamic.length > 1) {
    //   widget.playerName2 = widget.playersSelectedDynamic[1].userName;
    // }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height /
          2, // Also Including Tab-bar height.
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 70.0),
                    child: SizedBox(
                      width: 70.0,
                      height: 30.0,
                      child: OutlinedButton(
                        onPressed: () {
                          widget.onReset.call();
                          setState(() {
                            widget.reset = !widget.reset;
                          });
                        },
                        style: ButtonStyle(),
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      widget.playerName1 +
                          (widget.gameSelected != null &&
                                  widget.gameSelected["name"] == "Chess"
                              ? "(white)"
                              : ""),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
              // Expanded(
              //   child: getGame(),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      widget.playerName2 +
                          (widget.gameSelected != null &&
                                  widget.gameSelected["name"] == "Chess"
                              ? "(black)"
                              : ""),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
