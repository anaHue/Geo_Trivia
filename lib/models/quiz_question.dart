class QuizQuestion {
  const QuizQuestion({
    required this.flag,
    required this.country,
    required this.capital,
    required this.options,
  });

  final String flag;
  final String country;
  final String capital;
  final List<String> options;
}