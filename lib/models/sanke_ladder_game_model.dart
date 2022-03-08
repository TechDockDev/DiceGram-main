import 'package:cloud_firestore/cloud_firestore.dart';

class SnakeLadderGameModel{
  int currentPlayer=1;
  int currentDiceOne=0;
  int totalPlayerTwo=0;
  int totalPlayerOne=0;
  Timestamp timerStart = Timestamp.now();
  SnakeLadderGameModel(
      {required this.timerStart,
        required this.currentPlayer,
        required this.currentDiceOne,
        required this.totalPlayerTwo,
        required this.totalPlayerOne});

  SnakeLadderGameModel.fromJson(Map<String, dynamic> json) {
    currentPlayer = json['currentPlayer'];
    currentDiceOne = json['currentDiceOne'];
    totalPlayerTwo = json['totalPlayerTwo'];
    totalPlayerOne = json['totalPlayerOne'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['currentPlayer'] = currentPlayer;
    data['currentDiceOne'] = currentDiceOne;
    data['totalPlayerTwo'] = totalPlayerTwo;
    data['totalPlayerOne'] = totalPlayerOne;
    return data;
  }
}