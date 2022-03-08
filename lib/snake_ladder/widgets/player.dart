import 'package:flutter/material.dart';
import 'package:dicegram/snake_ladder/widgets/utils.dart';

class Player extends StatelessWidget {
  const Player({Key? key, required this.numPlayer}) : super(key: key);
  final String numPlayer;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        width: 50,
        height: 40,
        child: Center(
            child: Text(
          'Pl ${numPlayer}',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.orange.shade300),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.orange.shade100)]),
      ),
    );
  }
}
