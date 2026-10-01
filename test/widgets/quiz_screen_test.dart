import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_trivia/controllers/quiz_controller.dart';
import 'package:geo_trivia/widgets/QuizScreen/quiz_screen.dart';

import '../fakes/fake_quiz_service.dart';

Future<void> pumpQuizScreen(WidgetTester tester, QuizController controller) {
  return tester.pumpWidget(
    MaterialApp(
      home: QuizScreen(controller: controller),
    ),
  );
}

void main() {
  late QuizController controller;

  setUp(() {
    controller = QuizController(quizService: FakeQuizService());
  });

  testWidgets('shows a loading indicator, then the first question', (tester) async {
    await pumpQuizScreen(tester, controller);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.textContaining('Belgium'), findsOneWidget);
    expect(find.text('Brussels'), findsOneWidget);
    expect(find.text('Question 1/2'), findsOneWidget);
    expect(find.text('Score: 0'), findsOneWidget);
  });

  testWidgets('tapping the correct answer shows feedback and increments the score', (tester) async {
    await pumpQuizScreen(tester, controller);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Brussels'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Correct!'), findsOneWidget);
    expect(find.text('Score: 1'), findsOneWidget);
    expect(find.text('Next Question'), findsOneWidget);
  });

  testWidgets('tapping a wrong answer shows feedback without changing the score', (tester) async {
    await pumpQuizScreen(tester, controller);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Paris'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Not quite'), findsOneWidget);
    expect(find.text('Score: 0'), findsOneWidget);
  });

  testWidgets('tapping an answer twice only counts the first tap', (tester) async {
    await pumpQuizScreen(tester, controller);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Brussels'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paris'));
    await tester.pumpAndSettle();

    expect(find.text('Score: 1'), findsOneWidget);
  });

  testWidgets('Next Question advances to the second question', (tester) async {
    await pumpQuizScreen(tester, controller);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Brussels'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next Question'));
    await tester.pumpAndSettle();

    expect(find.textContaining('France'), findsOneWidget);
    expect(find.text('Question 2/2'), findsOneWidget);
    expect(find.text('Score: 1'), findsOneWidget);
  });

  testWidgets('the last question shows a Play Again button that restarts the game', (tester) async {
    await pumpQuizScreen(tester, controller);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Brussels'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next Question'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Paris'));
    await tester.pumpAndSettle();

    expect(find.text('Play Again'), findsOneWidget);

    await tester.tap(find.text('Play Again'));
    await tester.pumpAndSettle();

    expect(find.text('Question 1/2'), findsOneWidget);
    expect(find.text('Score: 0'), findsOneWidget);
  });
}
