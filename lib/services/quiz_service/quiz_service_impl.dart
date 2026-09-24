import 'package:geo_trivia/models/quiz_question.dart';
import 'package:sealed_countries/sealed_countries.dart';

import 'quiz_service.dart';

class QuizServiceImpl implements QuizService {
  static const _poolSize = 30;
  static const _questionCount = 20;
  static const _optionCount = 4;

  @override
  List<QuizQuestion> loadQuestions() {
    final pool = WorldCountry.list
        .where((c) =>
            c.name.common.trim().isNotEmpty &&
            c.capitalInfo?.capital.name.trim().isNotEmpty == true &&
            c.emoji.trim().isNotEmpty)
        .toList()
      ..shuffle();

    final selected = pool.take(_poolSize).toList();
    final capitals = selected.map((c) => c.capitalInfo!.capital.name.trim()).toList();

    final questions = List.generate(selected.length, (i) {
      final country = selected[i];
      final capital = capitals[i];

      final distractors = (capitals.toSet()..remove(capital)).toList()
        ..shuffle();

      return QuizQuestion(
        flag: country.emoji,
        country: country.name.common,
        capital: capital,
        options: [capital, ...distractors.take(_optionCount - 1)]..shuffle(),
      );
    })..shuffle();

    return questions.take(_questionCount).toList();
  }
}