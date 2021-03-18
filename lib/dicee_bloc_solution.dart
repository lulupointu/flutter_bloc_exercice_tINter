import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    BlocProvider<DiceeBloc>(
      create: (BuildContext context) => DiceeBloc(),
      child: MaterialApp(
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
    ),
  );
}

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<DiceeBloc, DiceeState>(
        builder: (BuildContext context, DiceeState diceeSate) {
          int leftNumber = diceeSate.leftNumber;
          int rightNumber = diceeSate.rightNumber;
          child:
          return Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  child: Image.asset(
                    'images/dice$leftNumber.png',
                  ),
                  onPressed: () {
                    BlocProvider.of<DiceeBloc>(context).add(LeftDiceeEvent());
                  },
                ),
              ),
              //Get students to create the second die as a challenge
              Expanded(
                child: FlatButton(
                  child: Image.asset(
                    'images/dice$rightNumber.png',
                  ),
                  onPressed: () {
                    BlocProvider.of<DiceeBloc>(context).add(RightDiceeEvent());
                  },
                ),
              ),
            ],
          );
        }
        ),
    );
  }
}

class DiceeBloc extends Bloc<DiceeEvent, DiceeState> {
  DiceeBloc() : super(DiceeState(1, 1));

  @override
  Stream<DiceeState> mapEventToState(DiceeEvent event) async* {

    int number = Random().nextInt(6) + 1;

    // Si le dé de gauche est cliqué
    if (event is LeftDiceeEvent) {
      yield DiceeState(number, state.rightNumber);
      return;
    }

    // Si le dé de droite est cliqué
    if (event is RightDiceeEvent) {
      yield DiceeState(state.leftNumber, number);
      return;
    }
  }
}

abstract class DiceeEvent {
  const DiceeEvent();
}

class LeftDiceeEvent extends DiceeEvent {}

class RightDiceeEvent extends DiceeEvent {}

// Our state
class DiceeState {
  final int leftNumber;
  final int rightNumber;

  const DiceeState(this.leftNumber, this.rightNumber);
}

