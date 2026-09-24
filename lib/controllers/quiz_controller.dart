import 'package:flutter/foundation.dart';
import 'package:geo_trivia/constants/app_strings.dart';

import 'package:geo_trivia/models/quiz_state.dart';
import 'package:geo_trivia/services/quiz_service/quiz_service.dart';
import 'package:geo_trivia/services/quiz_service/quiz_service_impl.dart';

/// Holds the current [QuizState] and produces new states in response to
/// user input (the "ViewModel" in an MVVM split). The widget layer only
/// reads [state] and calls these methods - it never talks to
/// [QuizService] directly and never mutates state itself.
class QuizController extends ChangeNotifier {
  QuizController({QuizService? quizService})
      : _quizService = quizService ?? QuizServiceImpl();

  final QuizService _quizService;

  QuizState _state = const QuizState();
  QuizState get state => _state;

  void _update(QuizState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loadQuestions() async {
    _update(const QuizState());

    final loadedQuestions = await Future.value(_quizService.loadQuestions());

    _update(_state.copyWith(questions: loadedQuestions, loading: false));
  }

  void checkAnswer(String selectedOption) {
    if (_state.answered) return;

    final currentQuestion = _state.currentQuestion;
    final isCorrect = selectedOption == currentQuestion.capital;

    _update(_state.copyWith(
      answered: true,
      isCorrectAnswer: isCorrect,
      score: _state.score + (isCorrect ? 1 : 0),
      feedback: isCorrect
          ? AppStrings.correctFeedback(currentQuestion.capital, currentQuestion.country)
          : AppStrings.incorrectFeedback(currentQuestion.capital, currentQuestion.country),
    ));
  }

  void nextQuestion() {
    final nextIndex = _state.index < _state.questionCount - 1 ? _state.index + 1 : 0;

    _update(_state.copyWith(
      index: nextIndex,
      answered: false,
      isCorrectAnswer: false,
      clearFeedback: true,
    ));
  }

  void restartGame() {
    loadQuestions();
  }
}