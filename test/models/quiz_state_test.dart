import 'package:flutter_test/flutter_test.dart';
import 'package:geo_trivia/models/quiz_state.dart';

import '../fakes/fake_quiz_service.dart';

void main() {
  final questionA = FakeQuizService.questions[0];
  final questionB = FakeQuizService.questions[1];

  group('QuizState defaults', () {
    test('starts loading, at index 0, score 0, unanswered', () {
      const state = QuizState();

      expect(state.loading, isTrue);
      expect(state.index, 0);
      expect(state.score, 0);
      expect(state.answered, isFalse);
      expect(state.isCorrectAnswer, isFalse);
      expect(state.feedback, isNull);
      expect(state.selectedOption, isNull);
      expect(state.hasQuestions, isFalse);
    });
  });

  group('QuizState derived getters', () {
    final state = QuizState(questions: [questionA, questionB], loading: false);

    test('currentQuestion follows index', () {
      expect(state.currentQuestion, questionA);
      expect(state.copyWith(index: 1).currentQuestion, questionB);
    });

    test('isLastQuestion is true only on the final index', () {
      expect(state.isLastQuestion, isFalse);
      expect(state.copyWith(index: 1).isLastQuestion, isTrue);
    });

    test('questionCount matches the number of questions', () {
      expect(state.questionCount, 2);
    });

    test('questions getter is unmodifiable', () {
      expect(() => state.questions.add(questionA), throwsUnsupportedError);
    });
  });

  group('QuizState.copyWith', () {
    test('leaves fields untouched when no argument is passed', () {
      final original = QuizState(
        questions: [questionA],
        loading: false,
        index: 0,
        score: 3,
        feedback: 'Correct!',
        answered: true,
        isCorrectAnswer: true,
        selectedOption: 'Brussels',
      );

      final copy = original.copyWith();

      expect(copy.score, original.score);
      expect(copy.feedback, original.feedback);
      expect(copy.answered, original.answered);
      expect(copy.selectedOption, original.selectedOption);
    });

    test('overwrites only the fields explicitly passed', () {
      final original = QuizState(questions: [questionA], loading: false, score: 3);

      final copy = original.copyWith(score: 4, answered: true);

      expect(copy.score, 4);
      expect(copy.answered, isTrue);
      expect(copy.loading, isFalse);
      expect(copy.questionCount, 1);
    });

    test('clearFeedback: false keeps existing feedback even if not passed', () {
      final original = QuizState(feedback: 'Correct!');

      final copy = original.copyWith(score: 1);

      expect(copy.feedback, 'Correct!');
    });

    test('clearFeedback: true resets feedback to null', () {
      final original = QuizState(feedback: 'Correct!');

      final copy = original.copyWith(clearFeedback: true);

      expect(copy.feedback, isNull);
    });

    test('clearSelectedOption: true resets selectedOption to null', () {
      final original = QuizState(selectedOption: 'Brussels');

      final copy = original.copyWith(clearSelectedOption: true);

      expect(copy.selectedOption, isNull);
    });

    test('passing a new feedback while clearFeedback is true still results in null', () {
      final original = QuizState(feedback: 'Correct!');

      final copy = original.copyWith(feedback: 'Not quite.', clearFeedback: true);

      expect(copy.feedback, isNull);
    });
  });
}
