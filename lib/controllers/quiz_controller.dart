import 'package:geo_trivia/services/quiz_service/quiz_service.dart';
import 'package:geo_trivia/services/quiz_service/quiz_service_impl.dart';

class QuizController {
  /**
  List<Task> tasks = [
    Task('Task 1', false),
    Task('Task 2', true),
    Task('Task 3', false),
  ];

  void toggleTaskCompletion(int index) {
    tasks[index].completed = !tasks[index].completed;
  }
  */

  QuizService quizService = QuizServiceImpl();
}