import 'package:flutter/material.dart';

import 'package:geo_trivia/constants/app_strings.dart';
import 'package:geo_trivia/controllers/quiz_controller.dart';
import 'package:geo_trivia/models/quiz_state.dart';

import 'answer_option_button.dart';
import 'feedback_banner.dart';
import 'flag_card.dart';
import 'quiz_action_button.dart';
import 'quiz_screen.dart';
import 'stats_row.dart';

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
    final state = _controller.state;

    if (state.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!state.hasQuestions) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.appTitle),
          centerTitle: true,
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text(AppStrings.noCountriesLoaded)),
      );
    }

    final question = state.currentQuestion;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final questionContent = AnimatedSwitcher(
      key: const ValueKey('questionSwitcher'),
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(animation),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey(state.index),
        child: isLandscape
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: FlagCard(country: question.country, flag: question.flag)),
                  const SizedBox(width: 20),
                  Expanded(child: _AnswerOptions(state: state, controller: _controller)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FlagCard(country: question.country, flag: question.flag),
                  const SizedBox(height: 20),
                  _AnswerOptions(state: state, controller: _controller),
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StatsRow(
                      currentQuestion: state.index + 1,
                      totalQuestions: state.questionCount,
                      score: state.score,
                    ),
                    const SizedBox(height: 24),
                    questionContent,
                    FeedbackBanner(feedback: state.feedback, isCorrect: state.isCorrectAnswer),
                    const SizedBox(height: 24),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: state.answered
                          ? QuizActionButton(
                              key: const ValueKey('actionButton'),
                              isLastQuestion: state.isLastQuestion,
                              onPressed: state.isLastQuestion ? _controller.restartGame : _controller.nextQuestion,
                            )
                          : const SizedBox.shrink(key: ValueKey('noActionButton')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerOptions extends StatelessWidget {
  const _AnswerOptions({required this.state, required this.controller});

  final QuizState state;
  final QuizController controller;

  @override
  Widget build(BuildContext context) {
    final question = state.currentQuestion;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final option in question.options)
          AnswerOptionButton(
            option: option,
            correctOption: question.capital,
            selectedOption: state.selectedOption,
            answered: state.answered,
            onSelected: controller.checkAnswer,
          ),
      ],
    );
  }
}
