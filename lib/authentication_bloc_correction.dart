import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (_) => AuthenticationBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState authenticationState) {
          return (authenticationState is LoggedOutState)
              ? MyConnexionPage(title: 'Connexion page')
              : MyHomePage(title: 'Home page');
        },
      ),
    );
  }
}

class MyConnexionPage extends StatelessWidget {
  MyConnexionPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onSubmitted: (username) {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(LoginEvent(username: username));
                },
              ),
              SizedBox(height: 40),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (BuildContext context, AuthenticationState authenticationState) {
                  return (authenticationState is LogAwaitingState)
                      ? CircularProgressIndicator()
                      : Container();
                },
              ),
            ],
          ),
        ),
      ),
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
              'Vous etes connectez',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Disconnect
          BlocProvider.of<AuthenticationBloc>(context).add(LogoutEvent());
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(LoggedOutState());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    switch (event.runtimeType) {
      case LoginEvent:
        yield* mapLoginEventToState(event);
        return;
      case LogoutEvent:
        yield LoggedOutState();
        return;
      default:
        throw Exception('Unexpected State: ${event.runtimeType}');
    }
  }

  Stream<AuthenticationState> mapLoginEventToState(LoginEvent event) async* {
    yield LogAwaitingState();

    await Future.delayed(Duration(seconds: 2));

    if (event.username == 'bob') {
      yield LoggedInState();
    } else {
      yield LoggedOutState();
    }
  }
}

@immutable
abstract class AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {
  final String username;

  LoginEvent({@required this.username});
}

class LogoutEvent extends AuthenticationEvent {}

@immutable
abstract class AuthenticationState {}

class LoggedInState extends AuthenticationState {}

class LogAwaitingState extends LoggedOutState {}

class LoggedOutState extends AuthenticationState {}
