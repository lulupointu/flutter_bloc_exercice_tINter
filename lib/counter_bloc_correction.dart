import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider<CounterBloc>(
      create: (BuildContext context) => CounterBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            BlocBuilder<CounterBloc, CounterState>(
              builder: (BuildContext context, CounterState counterState) {
                return Text(
                  '${counterState.counter}',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<CounterBloc>(context).add(IncrementEvent());
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0));

  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    // Increment counter
    if (event is IncrementEvent) {
      yield CounterState(state.counter + 1);
      return;
    }

    // Decrement counter
    if (event is DecrementEvent) {
      yield CounterState(state.counter - 1);
      return;
    }
  }
}

abstract class CounterEvent {
  const CounterEvent();
}

// Incrementer
class IncrementEvent extends CounterEvent {}

// Decrement
class DecrementEvent extends CounterEvent {}

// Our state
class CounterState {
  final int counter;

  const CounterState(this.counter);
}