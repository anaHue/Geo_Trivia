import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geo_trivia/models/quiz_question.dart';
import 'package:sealed_countries/sealed_countries.dart';

import 'quiz_screen.dart';

class QuizScreenState extends State<QuizScreen> {
  List<QuizQuestion> _questions = [];
  bool _loading = true;
  int _index = 0;
  int _score = 0;
  String? _feedback;
  bool _answered = false;
  bool _isCorrectAnswer = false;
  QuizQuestion get _currentQuestion => _questions[_index];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final countries = WorldCountry.list
          .where(
            (country) =>
                country.name.common.trim().isNotEmpty &&
                country.capitalInfo != null &&
                country.emoji.trim().isNotEmpty,
          )
          .toList()
        ..shuffle();

      final selected = countries.take(30).toList();
      final dynamicQuestions = <QuizQuestion>[];
      final random = Random();

      for (var i = 0; i < selected.length; i++) {
        final country = selected[i];
        final capital = country.capitalInfo?.capital.name.trim();
        if (capital == null || capital.isEmpty) continue;

        final distractors = <String>[];

        while (distractors.length < 3) {
          final randomIndex = random.nextInt(selected.length);
          if (randomIndex == i) continue;

          final otherCapital = selected[randomIndex].capitalInfo?.capital.name.trim();
          if (otherCapital != null &&
              otherCapital.isNotEmpty &&
              otherCapital != capital &&
              !distractors.contains(otherCapital)) {
            distractors.add(otherCapital);
          }
        }

        final options = <String>{capital, ...distractors}.toList();
        options.shuffle();

        dynamicQuestions.add(
          QuizQuestion(
            flag: country.emoji,
            country: country.name.common,
            capital: capital,
            options: options.take(4).toList(),
          ),
        );
      }

      dynamicQuestions.shuffle();

      if (!mounted) return;
      setState(() {
        _questions = dynamicQuestions.take(20).toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _questions = [];
        _loading = false;
      });
    }
  }

  void _checkAnswer(String selectedOption) {
    if (_answered) return;

    final isCorrect = selectedOption == _currentQuestion.capital;

    setState(() {
      _answered = true;
      _isCorrectAnswer = isCorrect;
      _score += isCorrect ? 1 : 0;
      _feedback = isCorrect
          ? 'Correct! ${_currentQuestion.capital} is the capital of ${_currentQuestion.country}.'
          : 'Not quite. The correct answer is ${_currentQuestion.capital} (${_currentQuestion.country}).';
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_index < _questions.length - 1) {
        _index += 1;
      } else {
        _index = 0;
      }
      _answered = false;
      _feedback = null;
      _isCorrectAnswer = false;
    });
  }

  void _restartGame() {
    setState(() {
      _loading = true;
      _questions = [];
      _index = 0;
      _score = 0;
      _answered = false;
      _feedback = null;
      _isCorrectAnswer = false;
    });
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Geo Trivia'),
          centerTitle: true,
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('No countries loaded. Please try again.'),
        ),
      );
    }

    final question = _currentQuestion;
    final isLastQuestion = _index == _questions.length - 1;

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final statsRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Question ${_index + 1}/${_questions.length}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Score: $_score',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    final flagCard = Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Find the capital city of ${question.country}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                question.flag,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 82),
              ),
            ),
          ],
        ),
      ),
    );

    final answerButtons = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: question.options.map(
        (option) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ElevatedButton(
            onPressed: _answered ? null : () => _checkAnswer(option),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green.shade900,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              option,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ).toList(),
    );

    final bodyContent = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            statsRow,
            const SizedBox(height: 24),
            if (isLandscape)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: flagCard),
                  const SizedBox(width: 20),
                  Expanded(child: answerButtons),
                ],
              )
            else ...[
              flagCard,
              const SizedBox(height: 20),
              answerButtons,
            ],
            if (_feedback != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _isCorrectAnswer ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _feedback!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _isCorrectAnswer ? Colors.green.shade900 : Colors.red.shade900,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (_answered)
              ElevatedButton.icon(
                onPressed: () {
                  if (isLastQuestion) {
                    _restartGame();
                  } else {
                    _nextQuestion();
                  }
                },
                icon: Icon(isLastQuestion ? Icons.refresh : Icons.arrow_forward),
                label: Text(isLastQuestion ? 'Play Again' : 'Next Question'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
          ],
        ),
      ),
    );

    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text('Geo Trivia'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      */
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: bodyContent,
          ),
        ),
      ),
    );
  }
}
