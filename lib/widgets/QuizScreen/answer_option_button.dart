import 'package:flutter/material.dart';

class AnswerOptionButton extends StatelessWidget {
  const AnswerOptionButton({
    super.key,
    required this.option,
    required this.correctOption,
    required this.selectedOption,
    required this.answered,
    required this.onSelected,
  });

  final String option;
  final String correctOption;
  final String? selectedOption;
  final bool answered;
  final ValueChanged<String> onSelected;

  bool get _isCorrectOption => option == correctOption;
  bool get _isSelectedOption => option == selectedOption;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;
    final double opacity;

    if (!answered) {
      background = Colors.white;
      foreground = Colors.green.shade900;
      opacity = 1;
    } else if (_isCorrectOption) {
      background = Colors.green.shade400;
      foreground = Colors.white;
      opacity = 1;
    } else if (_isSelectedOption) {
      background = Colors.red.shade300;
      foreground = Colors.white;
      opacity = 1;
    } else {
      background = Colors.white;
      foreground = Colors.green.shade900;
      opacity = 0.45;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: opacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: answered ? null : () => onSelected(option),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(fontSize: 18, color: foreground),
                    child: Text(option),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
