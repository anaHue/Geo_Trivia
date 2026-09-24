import 'package:flutter/foundation.dart';

@immutable
class QuizQuestion {
  const QuizQuestion({
    required this.flag,
    required this.country,
    required this.capital,
    required List<String> options,
  }) : _options = options;

  final String flag;
  final String country;
  final String capital;
  final List<String> _options;

  List<String> get options => List.unmodifiable(_options);
}