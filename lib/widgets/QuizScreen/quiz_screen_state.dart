import 'package:flutter/material.dart';

import 'package:geo_trivia/constants/app_strings.dart';
import 'package:geo_trivia/controllers/quiz_controller.dart';

import 'quiz_screen.dart';

/// Pure view: reads state from [QuizController] and forwards user input
/// to it. Contains no business logic and never touches services directly.
class QuizScreenState extends State<QuizScreen> {
  late final QuizController _controller = widget.controller ?? QuizController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _controller.loadQuestions();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.state.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_controller.state.hasQuestions) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.appTitle),
          centerTitle: true,
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(AppStrings.noCountriesLoaded),
        ),
      );
    }

    final question = _controller.state.currentQuestion;
    final isLastQuestion = _controller.state.isLastQuestion;

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final statsRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.questionCounter(_controller.state.index + 1, _controller.state.questionCount),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          AppStrings.score(_controller.state.score),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    final flagCard = Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              AppStrings.findCapitalPrompt(question.country),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                question.flag,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 82),
              ),
            ),
          ],
        ),
      ),
    );

    final answerButtons = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: question.options.map(
        (option) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ElevatedButton(
            onPressed: _controller.state.answered ? null : () => _controller.checkAnswer(option),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green.shade900,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              option,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ).toList(),
    );

    final bodyContent = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            statsRow,
            const SizedBox(height: 24),
            if (isLandscape)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: flagCard),
                  const SizedBox(width: 20),
                  Expanded(child: answerButtons),
                ],
              )
            else ...[
              flagCard,
              const SizedBox(height: 20),
              answerButtons,
            ],
            if (_controller.state.feedback != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _controller.state.isCorrectAnswer ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _controller.state.feedback!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _controller.state.isCorrectAnswer ? Colors.green.shade900 : Colors.red.shade900,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (_controller.state.answered)
              ElevatedButton.icon(
                onPressed: () {
                  if (isLastQuestion) {
                    _controller.restartGame();
                  } else {
                    _controller.nextQuestion();
                  }
                },
                icon: Icon(isLastQuestion ? Icons.refresh : Icons.arrow_forward),
                label: Text(isLastQuestion ? AppStrings.playAgain : AppStrings.nextQuestion),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: bodyContent,
          ),
        ),
      ),
    );
  }
}