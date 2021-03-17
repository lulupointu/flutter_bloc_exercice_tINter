import 'dart:math';
import 'package:flutter/material.dart';

/// Exercice:
/// Dans cet exercice issue du tutoriel "Dicee" de www.appbrewery.co que vous avez déjà réalisé
/// vous devez faire en sorte qu'un bloc gère les dés.
///
/// Attention:
/// Dans l'exercice de www.appbrewery.co, les dés étaient tout les deux relancés a chaque fois.
/// J'ai modifié ce code pour que cliqué sur un dé ne relance que celui-ci et laisse l'autre
/// inchangé

void main() {
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text('Dicee'),
          backgroundColor: Colors.red,
        ),
        body: DicePage(),
      ),
    ),
  );
}

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

enum Side { left, right }

class _DicePageState extends State<DicePage> {
  int leftDiceNumber = 1;
  int rightDiceNumber = 1;

  void changeDiceFace(Side diceSide) {
    setState(() {
      if (diceSide == Side.left) {
        leftDiceNumber = Random().nextInt(6) + 1;
      } else {
        rightDiceNumber = Random().nextInt(6) + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: Image.asset(
                'images/dice$leftDiceNumber.png',
              ),
              onPressed: () {
                changeDiceFace(Side.left);
              },
            ),
          ),
          //Get students to create the second die as a challenge
          Expanded(
            child: FlatButton(
              child: Image.asset(
                'images/dice$rightDiceNumber.png',
              ),
              onPressed: () {
                changeDiceFace(Side.right);
              },
            ),
          ),
        ],
      ),
    );
  }
}
