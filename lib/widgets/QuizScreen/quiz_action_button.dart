import 'package:flutter/material.dart';

import 'package:geo_trivia/constants/app_strings.dart';

class QuizActionButton extends StatelessWidget {
  const QuizActionButton({
    super.key,
    required this.isLastQuestion,
    required this.onPressed,
  });

  final bool isLastQuestion;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(isLastQuestion ? Icons.refresh : Icons.arrow_forward),
      label: Text(isLastQuestion ? AppStrings.playAgain : AppStrings.nextQuestion),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      ),
    );
  }
}
