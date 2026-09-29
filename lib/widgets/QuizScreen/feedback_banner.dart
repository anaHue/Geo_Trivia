import 'package:flutter/material.dart';

class FeedbackBanner extends StatelessWidget {
  const FeedbackBanner({super.key, required this.feedback, required this.isCorrect});

  final String? feedback;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: animation, child: child),
      ),
      child: feedback == null
          ? const SizedBox.shrink(key: ValueKey('empty'))
          : Container(
              key: ValueKey(feedback),
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                feedback!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isCorrect ? Colors.green.shade900 : Colors.red.shade900,
                ),
              ),
            ),
    );
  }
}
