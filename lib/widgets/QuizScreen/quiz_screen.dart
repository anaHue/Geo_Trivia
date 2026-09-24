import 'package:flutter/material.dart';

import 'package:geo_trivia/controllers/quiz_controller.dart';

import 'quiz_screen_state.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, this.controller});

  /// Optional controller injection - mainly so widget/unit tests can pass
  /// in a fake [QuizController]. When null, the screen creates and owns
  /// its own instance and disposes it automatically.
  final QuizController? controller;

  @override
  State<QuizScreen> createState() => QuizScreenState();
}
