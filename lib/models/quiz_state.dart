import 'package:flutter/foundation.dart';

import 'quiz_question.dart';

/// Immutable snapshot of everything the quiz screen needs to render.
///
/// Scalar fields (bool/int/String?) are plain public `final` fields -
/// they're already value types, so a private field + pass-through getter
/// would add ceremony without adding any real immutability guarantee.
///
/// [questions] is different: a `final List` only locks the *reference*,
/// not the list's contents, so it's kept private and exposed through an
/// unmodifiable view to stop callers from mutating state in place
/// (e.g. `state.questions.shuffle()`) without going through [copyWith]
/// and `notifyListeners()`.
@immutable
class QuizState {
  const QuizState({
    List<QuizQuestion> questions = const [],
    this.loading = true,
    this.index = 0,
    this.score = 0,
    this.feedback,
    this.answered = false,
    this.isCorrectAnswer = false,
  }) : _questions = questions;

  final List<QuizQuestion> _questions;
  final bool loading;
  final int index;
  final int score;
  final String? feedback;
  final bool answered;
  final bool isCorrectAnswer;

  List<QuizQuestion> get questions => List.unmodifiable(_questions);
  int get questionCount => _questions.length;
  bool get hasQuestions => _questions.isNotEmpty;
  bool get isLastQuestion => index == _questions.length - 1;
  QuizQuestion get currentQuestion => _questions[index];

  QuizState copyWith({
    List<QuizQuestion>? questions,
    bool? loading,
    int? index,
    int? score,
    String? feedback,
    bool clearFeedback = false,
    bool? answered,
    bool? isCorrectAnswer,
  }) {
    return QuizState(
      questions: questions ?? _questions,
      loading: loading ?? this.loading,
      index: index ?? this.index,
      score: score ?? this.score,
      feedback: clearFeedback ? null : (feedback ?? this.feedback),
      answered: answered ?? this.answered,
      isCorrectAnswer: isCorrectAnswer ?? this.isCorrectAnswer,
    );
  }
}