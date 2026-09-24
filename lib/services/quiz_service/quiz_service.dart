import 'package:geo_trivia/models/quiz_question.dart';

abstract class QuizService {
  List<QuizQuestion> loadQuestions();
}