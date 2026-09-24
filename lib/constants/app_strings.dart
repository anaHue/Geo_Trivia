/// Centralised copy for the app. Not a substitute for real localization
/// (see the `intl` / `.arb` approach if multi-language support is ever
/// needed) - this just keeps literal strings out of widgets/controllers
/// so copy changes and typo fixes happen in one place.
abstract class AppStrings {
  static const appTitle = 'Geo Trivia';
  static const noCountriesLoaded = 'No countries loaded. Please try again.';
  static const playAgain = 'Play Again';
  static const nextQuestion = 'Next Question';

  static String findCapitalPrompt(String country) => 'Find the capital city of $country';

  static String questionCounter(int current, int total) => 'Question $current/$total';

  static String score(int score) => 'Score: $score';

  static String correctFeedback(String capital, String country) =>
      'Correct! $capital is the capital of $country.';

  static String incorrectFeedback(String capital, String country) =>
      'Not quite. The correct answer is $capital ($country).';
}