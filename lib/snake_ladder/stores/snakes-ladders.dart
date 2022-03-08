
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/utils/firebase_utils.dart';
import 'package:dicegram/snake_ladder/consts/snakes_ladders.dart';
import 'package:dicegram/snake_ladder/widgets/utils.dart';
import 'package:mobx/mobx.dart';

part 'snakes-ladders.g.dart';

class SnakesLadders = _SnakesLaddersBase with _$SnakesLadders;

abstract class _SnakesLaddersBase with Store {
  Utils utils = Utils();

  @observable
  int _currentPlayer = 1;

  @observable
  int _currentDiceOne = 1;


  @observable
  int _totalPlayerTwo = 1;

  @observable
  int _totalPlayerOne = 1;

  String _gameId = '';

  String get gameId => _gameId;

  List<String> _players =[];

  List<String> get players => _players;

  String _p1='';

  String get p1=>_p1;

  String _p2='';

  String get p2=>_p2;

  @computed
  int get totalPlayerOne => _totalPlayerOne;

  @computed
  int get totalPlayerTwo => _totalPlayerTwo;

  @computed
  int get currentPlayer => _currentPlayer;

  @computed
  int get currentDiceOne => _currentDiceOne;


  @action
  init(String gameid,List<String> players){
    _currentPlayer=1;
    _currentDiceOne=1;
    _totalPlayerOne=1;
    _totalPlayerTwo=1;
    _gameId=gameid;
    _players = players;
    _p1 = UserServices.userId;
    _p2 = players.first == p1 ? players.last : players.first;
    print('p1 $p1 : p2 $p2');
    setStream();
  }

  @action
  play(diceOne, context) {
    _currentDiceOne = diceOne;

    if (_currentPlayer == 1) {
      var total = _totalPlayerOne + diceOne ;
      if (total > 100) utils.dialogRulesWin(context, _currentPlayer, total);
      _totalPlayerOne = (total > 100 ? _totalPlayerOne : total) as int;

      var element = SnakesLaddersConst.snakesLadders
          .where((element) => element['position'] == _totalPlayerOne);
      if (element.isNotEmpty) utils.dialogRules(context, element, _currentPlayer);
    }

    if (_currentPlayer == 2) {
      var total = _totalPlayerTwo + diceOne ;
      if (total > 100) utils.dialogRulesWin(context, _currentPlayer, total);
      _totalPlayerTwo = (total > 100 ? _totalPlayerTwo : total) as int;
      var element = SnakesLaddersConst.snakesLadders
          .where((element) => element['position'] == _totalPlayerTwo);
      if (element.isNotEmpty) utils.dialogRules(context, element, _currentPlayer);
    }

    if (_totalPlayerTwo == 100 || _totalPlayerOne == 100)
      Utils.dialogWin(context, _currentPlayer);
    _currentPlayer = _currentPlayer == 1 ? 2 : 1;

    FirebaseUtils.getGameColRef().doc(gameId).collection('game').doc('snakeLadder').set(
        {
          p2: _totalPlayerTwo,
          p1: _totalPlayerOne,
          'currentPlayer': _currentPlayer==1?p1:p2,
          'currentDiceOne': _currentDiceOne
        }
        );
  }

  @action
  restartPlayers() {
    _totalPlayerOne = 1;
    _totalPlayerTwo = 1;
  }

  @action
  setPlayers(player, value) {
    player == 1 ? _totalPlayerOne = value : _totalPlayerTwo = value;
    FirebaseUtils.getGameColRef().doc(gameId).collection('game').doc('snakeLadder').set(
        {
          p2: _totalPlayerTwo,
          p1: _totalPlayerOne,
          'currentPlayer': _currentPlayer==1?p1:p2,
          'currentDiceOne': _currentDiceOne
        }
    );
  }



  void setStream() {
    FirebaseUtils.getGameColRef().doc(gameId).collection('game').snapshots().listen((event) {
      if(event.docs.isNotEmpty){
        _currentDiceOne = event.docs[0]["currentDiceOne"];
        _totalPlayerOne = event.docs[0][p1];
        _currentPlayer = event.docs[0]["currentPlayer"] == p1 ? 1 : 2;
        _totalPlayerTwo = event.docs[0][p2];
      }
    });
  }
}
