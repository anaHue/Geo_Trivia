import 'package:flutter/material.dart';

import 'package:geo_trivia/constants/app_strings.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.score,
  });

  final int currentQuestion;
  final int totalQuestions;
  final int score;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppStrings.questionCounter(currentQuestion, totalQuestions), style: style),
        TweenAnimationBuilder<double>(
          key: ValueKey(score),
          tween: Tween(begin: 1.3, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
          child: Text(AppStrings.score(score), style: style),
        ),
      ],
    );
  }
}
