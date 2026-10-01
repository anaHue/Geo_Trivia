import 'package:geo_trivia/models/quiz_question.dart';
import 'package:geo_trivia/services/quiz_service/quiz_service.dart';

class FakeQuizService implements QuizService {
  static const questions = [
    QuizQuestion(
      flag: '🇧🇪',
      country: 'Belgium',
      capital: 'Brussels',
      options: ['Brussels', 'Paris', 'Berlin', 'Rome'],
    ),
    QuizQuestion(
      flag: '🇫🇷',
      country: 'France',
      capital: 'Paris',
      options: ['Brussels', 'Paris', 'Berlin', 'Rome'],
    ),
  ];

  @override
  List<QuizQuestion> loadQuestions() => questions;
}
