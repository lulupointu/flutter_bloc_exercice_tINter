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

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <Word>[];
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return BlocBuilder<WordsBloc, WordsState>(
      builder: (BuildContext context, WordsState wordsState) {
        child:
        return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider();

              final index = i ~/ 2;
              if (index >= wordsState.wordList.length) {
                BlocProvider.of<WordsBloc>(context).add(AddMoreWordsEvent(_suggestions, 10));
              }
              return _buildRow(WordsState(_suggestions).wordList[index]);
            });
      }
      );
  }

  Widget _buildRow(Word word) {
    return ListTile(
      title: Text(
        word.word.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        word.isFavorite ? Icons.favorite : Icons.favorite_border,
        color: word.isFavorite ? Colors.red : null,
      ),
      onTap: () {
        BlocProvider.of<WordsBloc>(context).add(FavoritePushedEvent(word, _suggestions));
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

    if (event is AddMoreWordsEvent) {

      int nbWords = event.nbWords;
      List<Word> wordList = event.wordList;
      List<Word> moreWordList;

      List<WordPair> newWordPairList = generateWordPairs().take(nbWords);

      for (int i=0; i<nbWords; i++) {
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
  final List<Word> wordList;

  const FavoritePushedEvent(this.wordPushed, this.wordList);
}

class ShowFavoritesPushedEvent extends WordsEvent {
  final List<Word> wordList;

  const ShowFavoritesPushedEvent(this.wordList);
}

class AddMoreWordsEvent extends WordsEvent {
  final List<Word> wordList;
  final int nbWords;

  const AddMoreWordsEvent(this.wordList, this.nbWords);
}

class WordsState {
  final List<Word> wordList;

  const WordsState(this.wordList);
}

