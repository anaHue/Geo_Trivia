import 'package:flutter/material.dart';

import 'package:geo_trivia/controllers/quiz_controller.dart';

import 'quiz_screen_state.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, this.controller});


  final QuizController? controller;

  @override
  State<QuizScreen> createState() => QuizScreenState();
}
