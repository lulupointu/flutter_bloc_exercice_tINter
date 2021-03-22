import 'dart:math';
import 'package:flutter/material.dart';
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
    BlocProvider(
      create: (_) => DiceBloc(),
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

class DicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: BlocBuilder<DiceBloc, DiceState>(
                builder: (_, DiceState state) {
                  return Image.asset(
                    'images/dice${state.leftDiceValue}.png',
                  );
                },
              ),
              onPressed: () {
                BlocProvider.of<DiceBloc>(context).add(LeftDiceClickedEvent());
              },
            ),
          ),
          //Get students to create the second die as a challenge
          Expanded(
            child: FlatButton(
              child: BlocBuilder<DiceBloc, DiceState>(
                builder: (_, DiceState state) {
                  return Image.asset(
                    'images/dice${state.rightDiceValue}.png',
                  );
                },
              ),
              onPressed: () {
                BlocProvider.of<DiceBloc>(context).add(RightDiceClickedEvent());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DiceBloc extends Bloc<DiceEvent, DiceState> {
  DiceBloc()
      : super(
          DiceState(
            rightDiceValue: Random().nextInt(6) + 1,
            leftDiceValue: Random().nextInt(6) + 1,
          ),
        );

  @override
  Stream<DiceState> mapEventToState(DiceEvent event) async* {
    switch (event.runtimeType) {
      case LeftDiceClickedEvent:
        yield DiceState(
          rightDiceValue: state.rightDiceValue,
          leftDiceValue: Random().nextInt(6) + 1,
        );
        return;
      case RightDiceClickedEvent:
        yield DiceState(
          rightDiceValue: Random().nextInt(6) + 1,
          leftDiceValue: state.leftDiceValue,
        );
        return;
    }
  }
}

abstract class DiceEvent {
  const DiceEvent();
}

class LeftDiceClickedEvent extends DiceEvent {}

class RightDiceClickedEvent extends DiceEvent {}

// Our state
@immutable
class DiceState {
  final int rightDiceValue;
  final int leftDiceValue;

  DiceState({@required this.rightDiceValue, @required this.leftDiceValue});
}
