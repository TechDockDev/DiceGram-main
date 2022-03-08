import 'package:demoji/demoji.dart';

class SnakesLaddersConst {
  static String snake = 'assets/snakeLadder/snake.png';
  static String snake_two = 'assets/snakeLadder/snake_two.png';
  static String ladders = 'assets/snakeLadder/ladder.png';

  static List snakesLadders = [
    {
      'position': 96,
      'positionFuture': 78,
      'title': 'Ops... ' + Demoji.snake,
      'message': 'You will have to go back to the 24th house, you have fallen into a house where the snake\'s head is located.'
    },
    {
      'position': 61,
      'positionFuture': 43,
      'title': 'Que azar... '+ Demoji.snake,
      'message': 'You will have to go back to the 42th house, you have fallen into a house where the snake\'s head is located.'
    },
    {
      'position': 37,
      'positionFuture': 17,
      'title': 'Bahhh... '+ Demoji.snake,
      'message': 'You will have to go back to the 71th house, you have fallen into a house where the snake\'s head is located.'
    },
    {
      'position': 12,
      'positionFuture': 33,
      'title': 'Que sorte... '+ Demoji.fire,
      'message': 'You will go to house 45, you have fallen into a house where the base of the stairs is located.'
    },
    {
      'position': 55,
      'positionFuture': 58,
      'title': 'Boa... '+ Demoji.four_leaf_clover,
      'message': 'You will go to house 98, you have fallen into a house where the base of the stairs is located.'
    },
    {
      'position': 50,
      'positionFuture': 70,
      'title': 'É teu dia... ' + Demoji.star2,
      'message': 'You will go to house 76, you have fallen into a house where the base of the stairs is located.'
    }
  ];
}
