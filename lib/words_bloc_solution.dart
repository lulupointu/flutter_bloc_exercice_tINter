import 'dart:core';
import 'dart:core';
import 'dart:core';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
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
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class Word {
  final WordPair word;
  final bool isFavorite;

  const Word(this.word, this.isFavorite);
}

class WordsBloc extends Bloc<WordsEvent, WordsState> {
  WordsBloc() : super(WordsState(?));

  @override
  Stream<WordsState> mapEventToState(WordsEvent event) async* {

    if (event is FavoritePushedEvent) {

      List<Word> wordList = event.wordList;
      Word wordPushed = event.wordPushed;
      int index = wordList.indexOf(wordPushed);

      wordList.remove(wordPushed);
      Word updatedWord = Word(wordPushed.word, !wordPushed.isFavorite);
      wordList.insert(index, updatedWord);

      yield WordsState(wordList);
      return;
    }

    if (event is ShowFavoritesPushedEvent) {

      List<Word> wordList = event.wordList;
      for (var Word in wordList) {
        if (Word.isFavorite == false) {
          wordList.remove(Word);
        }
      }

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
  final List<Word> wordList;

  const FavoritePushedEvent(this.wordPushed, this.wordList);
}

class ShowFavoritesPushedEvent extends WordsEvent {
  final List<Word> wordList;

  const ShowFavoritesPushedEvent(this.wordList);
}

class WordsState {
  final List<Word> wordList;

  const WordsState(this.wordList);
}

