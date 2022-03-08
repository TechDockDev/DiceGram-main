import 'package:demoji/demoji.dart';
import 'package:dicegram/helpers/game_service.dart';
import 'package:dicegram/utils/firebase_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:dicegram/snake_ladder/stores/snakes-ladders.dart';
import 'package:dicegram/snake_ladder/view/footer.dart';
import 'package:dicegram/snake_ladder/widgets/image-item.dart';
import 'package:dicegram/snake_ladder/widgets/play.dart';
import 'package:dicegram/snake_ladder/widgets/utils.dart';
import 'package:get_it/get_it.dart';

class SnakeLadder extends StatefulWidget {
  const SnakeLadder({Key? key, required this.gameId, required this.players, required this.chatId, required this.onEnd,}) : super(key: key);
  final String gameId;
  final List<String> players;
  final String chatId;
  final VoidCallback onEnd;

  @override
  _SnakeLadderState createState() => _SnakeLadderState();
}

class _SnakeLadderState extends State<SnakeLadder> {
  int dice = 0;
  late Utils utils ;

  late SnakesLadders _snakesLaddersStore;


  @override
  void initState() {
    super.initState();
    _snakesLaddersStore = GetIt.instance<SnakesLadders>();
    _snakesLaddersStore.init(widget.gameId,widget.players);
    utils = Utils();
    // FirebaseUtils.getGameColRef().doc(widget.gameId).collection('game').snapshots().listen((event) {
    //   if(event.docs.isNotEmpty){
    //     setState(() {
    //       dice = event.docs[0]["dice"];
    //     });
    //     dice =0;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AnimationLimiter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(children: [
                    Observer(
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange.shade300),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [BoxShadow(color: Colors.orange.shade100)]),
                          child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(3),
                              addAutomaticKeepAlives: true,
                              gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 10),
                              itemCount: 100,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var color = index % 2 == 0
                                    ? Colors.black38
                                    : Colors.orange[300];
                                return  Observer(
                                        builder: (BuildContext context) {
                                          return Stack(
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 100,
                                                decoration:
                                                BoxDecoration(color: color),
                                                child: Center(
                                                  child:
                                                  (100 - index) == 100
                                                      ? Text(Demoji.house, style: TextStyle(fontSize: 18),)
                                                      : Text(
                                                    (100 - index).toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                              Play(
                                                totalPlayerOne:
                                                _snakesLaddersStore
                                                    .totalPlayerOne,
                                                totalPlayerTwo:
                                                _snakesLaddersStore
                                                    .totalPlayerTwo,
                                                currentPlayer: _snakesLaddersStore
                                                    .currentPlayer,
                                                index: index,
                                              )
                                            ],
                                          );
                                        },

                                );
                              }),
                        );
                      },
                    ),
                    ImageItem(),
                  ]),
                ),
              ),
            ),
            Observer(
              builder: (context){
                return  Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Footer(
                          snakeLaddersStore: _snakesLaddersStore,
                          diceTwo : dice
                      ),

                      Column(
                        children: [

                          ElevatedButton(
                            onPressed: () {

                              GameService().deleteGame(widget.gameId,widget.chatId );
                              widget.onEnd();
                            },
                            child: Text('End'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.orange)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              utils.dialogRestart(context);
                            },
                            child: Text('Reset'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.orange)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
      );
  }
}