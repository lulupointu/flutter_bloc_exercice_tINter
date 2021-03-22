import 'dart:core';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Exercice:
/// Dans cet exercice issue du tutoriel "Write your first Flutter app" que vous avez déjà réalisé
/// vous devez faire en sorte qu'un bloc gère les mots.
///
/// N'oubliez pas de mettre votre BlocProvider au dessus de MaterialApp sinon vous aurez des
/// problèmes

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WordsBloc>(
      create: (BuildContext context) => WordsBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Startup Name Generator',
        home: RandomWords(),
      ),
    );
  }
}

class RandomWords extends StatelessWidget {
  final _biggerFont = TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return BlocBuilder<WordsBloc, WordsState>(
      builder: (BuildContext context, WordsState wordsState) {
        return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemBuilder: (BuildContext context, int i) {
            if (i.isOdd) return Divider();

            final index = i ~/ 2;
            if (index >= wordsState.wordList.length) {
              BlocProvider.of<WordsBloc>(context).add(AddMoreWordsEvent(10));
              return CircularProgressIndicator();
            }
            return _buildRow(wordsState.wordList[index], context: context);
          },
        );
      },
    );
  }

  Widget _buildRow(Word word, {@required BuildContext context}) {
    return ListTile(
      title: Text(
        word.wordString.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        word.isFavorite ? Icons.favorite : Icons.favorite_border,
        color: word.isFavorite ? Colors.red : null,
      ),
      onTap: () {
        BlocProvider.of<WordsBloc>(context).add(FavoritePushedEvent(word));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: () => _pushSaved(context)),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return BlocBuilder<WordsBloc, WordsState>(
            builder: (
                BuildContext context,
                WordsState wordsState,
                ) {
              final tiles = wordsState.wordList.where((element) => element.isFavorite).map(
                    (Word word) {
                  return ListTile(
                    title: Text(
                      word.wordString.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                },
              );
              final divided = ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList();

              return Scaffold(
                appBar: AppBar(
                  title: Text('Saved Suggestions'),
                ),
                body: ListView(children: divided),
              );
            },
          );
        },
      ),
    );
  }
}

class Word {
  final WordPair wordString;
  final bool isFavorite;

  const Word(this.wordString, this.isFavorite);
}

class WordsBloc extends Bloc<WordsEvent, WordsState> {
  WordsBloc() : super(WordsState(generateWordPairs().take(20).map((e) => Word(e, false)).toList()));

  @override
  Stream<WordsState> mapEventToState(WordsEvent event) async* {
    if (event is FavoritePushedEvent) {
      List<Word> wordList = state.wordList
          .map((element) => (element.wordString == event.wordPushed.wordString)
          ? Word(element.wordString, !element.isFavorite)
          : element)
          .toList();

      yield WordsState(wordList);
      return;
    }

    if (event is AddMoreWordsEvent) {
      int nbWords = event.numberWords;
      List<Word> wordList = state.wordList;
      List<Word> moreWordList = [];

      List<WordPair> newWordPairList = generateWordPairs().take(nbWords).toList();

      for (int i = 0; i < nbWords; i++) {
        Word newWord = Word(newWordPairList[i], false);
        moreWordList.add(newWord);
      }

      wordList.addAll(moreWordList);

      yield WordsState(wordList);
      return;
    }
  }
}

abstract class WordsEvent {
  const WordsEvent();
}

class FavoritePushedEvent extends WordsEvent {
  final Word wordPushed;

  const FavoritePushedEvent(this.wordPushed);
}

class AddMoreWordsEvent extends WordsEvent {
  final int numberWords;

  const AddMoreWordsEvent(this.numberWords);
}

class WordsState {
  final List<Word> wordList;

  const WordsState(this.wordList);
}
