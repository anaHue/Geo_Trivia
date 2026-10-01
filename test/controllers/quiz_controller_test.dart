import 'package:flutter_test/flutter_test.dart';
import 'package:geo_trivia/controllers/quiz_controller.dart';

import '../fakes/fake_quiz_service.dart';

void main() {
  late QuizController controller;

  setUp(() {
    controller = QuizController(quizService: FakeQuizService());
  });

  group('loadQuestions', () {
    test('starts in a loading state before completion', () {
      final future = controller.loadQuestions();
      expect(controller.state.loading, isTrue);
      return future;
    });

    test('populates questions and turns loading off once complete', () async {
      await controller.loadQuestions();

      expect(controller.state.loading, isFalse);
      expect(controller.state.hasQuestions, isTrue);
      expect(controller.state.questionCount, FakeQuizService.questions.length);
    });

    test('notifies listeners at least twice (loading on, then loaded)', () async {
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);

      await controller.loadQuestions();

      expect(notifyCount, greaterThanOrEqualTo(2));
    });
  });

  group('checkAnswer', () {
    test('marks answered, correct, and increments score on a right answer', () async {
      await controller.loadQuestions();

      controller.checkAnswer('Brussels');

      expect(controller.state.answered, isTrue);
      expect(controller.state.isCorrectAnswer, isTrue);
      expect(controller.state.score, 1);
      expect(controller.state.selectedOption, 'Brussels');
      expect(controller.state.feedback, contains('Brussels'));
    });

    test('marks answered, incorrect, and leaves score unchanged on a wrong answer', () async {
      await controller.loadQuestions();

      controller.checkAnswer('Paris');

      expect(controller.state.answered, isTrue);
      expect(controller.state.isCorrectAnswer, isFalse);
      expect(controller.state.score, 0);
      expect(controller.state.selectedOption, 'Paris');
    });

    test('is a no-op once the question has already been answered', () async {
      await controller.loadQuestions();

      controller.checkAnswer('Brussels'); 
      controller.checkAnswer('Paris');

      expect(controller.state.score, 1);
      expect(controller.state.selectedOption, 'Brussels');
    });
  });

  group('nextQuestion', () {
    test('advances the index and resets per-question state', () async {
      await controller.loadQuestions();
      controller.checkAnswer('Brussels');

      controller.nextQuestion();

      expect(controller.state.index, 1);
      expect(controller.state.answered, isFalse);
      expect(controller.state.isCorrectAnswer, isFalse);
      expect(controller.state.feedback, isNull);
      expect(controller.state.selectedOption, isNull);
      expect(controller.state.score, 1);
    });

    test('wraps back to index 0 after the last question', () async {
      await controller.loadQuestions();
      controller.checkAnswer('Brussels');
      controller.nextQuestion();

      controller.checkAnswer('Paris');
      controller.nextQuestion();

      expect(controller.state.index, 0);
    });
  });

  group('restartGame', () {
    test('resets score, index, and per-question state, and reloads questions', () async {
      await controller.loadQuestions();
      controller.checkAnswer('Brussels');
      controller.nextQuestion();
      controller.checkAnswer('Berlin');

      controller.restartGame();

      expect(controller.state.score, 0);
      expect(controller.state.index, 0);
      expect(controller.state.answered, isFalse);
      expect(controller.state.feedback, isNull);
      expect(controller.state.selectedOption, isNull);
      expect(controller.state.hasQuestions, isTrue);
    });
  });
}
