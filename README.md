# Geo Trivia

A simple Flutter quiz game: guess the capital city of a country from its flag.

## Architecture

The app follows an **MVVM-style split** (Model / ViewModel / View) built on Flutter's
own `ChangeNotifier`, rather than a classic MVC where a Controller mediates between a
passive View and a Model. Flutter widgets rebuild reactively from state, so the
natural fit is: state lives in an observable object, and the widget just listens and
renders.

```
lib/
  constants/
    app_strings.dart       # All user-facing copy in one place
  models/
    quiz_question.dart     # A single question: flag, country, capital, options
    quiz_state.dart         # Immutable snapshot of the whole quiz session
  services/
    quiz_service/
      quiz_service.dart        # Abstract contract: how questions are produced
      quiz_service_impl.dart   # Real implementation (sealed_countries data)
  controllers/
    quiz_controller.dart   # ChangeNotifier "ViewModel": owns QuizState, exposes
                            # loadQuestions / checkAnswer / nextQuestion / restartGame
  widgets/
    QuizScreen/
      quiz_screen.dart          # StatefulWidget shell (optionally takes an injected controller)
      quiz_screen_state.dart    # Pure view: composes the widgets below, no business logic
      stats_row.dart            # Question counter + animated score
      flag_card.dart            # Prompt + flag emoji
      answer_option_button.dart # One answer choice, animates to green/red once answered
      feedback_banner.dart      # Correct/incorrect message, fades + scales in
      quiz_action_button.dart   # "Next Question" / "Play Again"
  main.dart
test/
  fakes/
    fake_quiz_service.dart # Shared deterministic QuizService double for tests
  models/
    quiz_state_test.dart
  controllers/
    quiz_controller_test.dart
  widgets/
    quiz_screen_test.dart
```

### Layer responsibilities

- **Model** (`models/`) — plain data. `QuizQuestion` is a single question; `QuizState`
  is an immutable snapshot of the *entire session* (current question index, score,
  whether the current question has been answered, etc.), with a `copyWith` for
  producing the next snapshot. Scalar fields are public `final`; the `questions` list
  is kept private and exposed through an unmodifiable view, since a `final List` only
  locks the reference, not its contents.
- **Service** (`services/`) — stateless data access. `QuizService.loadQuestions()`
  knows nothing about scores, current index, or UI — it just produces a list of
  questions. This is what makes it trivially swappable (e.g. for a network-backed
  implementation) and easy to fake in tests.
- **Controller / ViewModel** (`controllers/`) — a `ChangeNotifier` holding one
  `QuizState` and exposing the operations that transition it (`checkAnswer`,
  `nextQuestion`, `restartGame`). It's the only thing that talks to `QuizService`.
  The widget layer never touches the service directly and never mutates state itself.
- **View** (`widgets/`) — listens to the controller and renders `controller.state`.
  No business logic lives here; each sub-widget (`AnswerOptionButton`, `StatsRow`,
  etc.) is responsible only for its own presentation and animation.

### Why not classic MVC?

A Controller that pushes updates to a passive View fights Flutter's model, where
widgets rebuild themselves from state changes. `ChangeNotifier` + `notifyListeners()`
gives you that rebuild-on-change behavior for free, and the same single-state-object
shape (`QuizState` + `copyWith`) is the same pattern used by Cubit (`flutter_bloc`) and
Riverpod's `Notifier` — so migrating to one of those later, if the app grows, is a
mechanical change rather than a redesign.

## Running the app

```bash
flutter pub get
flutter run
```

## Running the tests

```bash
flutter test
```

- `test/models/quiz_state_test.dart` — unit tests for `QuizState`'s `copyWith`
  semantics (including the `clearFeedback` / `clearSelectedOption` reset flags).
- `test/controllers/quiz_controller_test.dart` — unit tests for `QuizController`,
  using `FakeQuizService` (constructor-injected) instead of real country data.
- `test/widgets/quiz_screen_test.dart` — end-to-end widget tests: tapping answers,
  checking feedback/score, advancing questions, and restarting the game.

All tests share one fixture, `test/fakes/fake_quiz_service.dart`, a deterministic
`QuizService` returning a fixed two-question list (Belgium/Brussels, France/Paris),
so behavior doesn't depend on shuffling or real data.

## Notes on conventions used

- **Strings**: all user-facing copy lives in `constants/app_strings.dart`, not
  scattered through widgets. This isn't full localization (see the `intl` / `.arb`
  approach if multi-language support is ever needed) — just a single source of truth
  for copy changes and typo fixes.
- **Dependency injection**: both `QuizController` and `QuizScreen` accept an optional
  dependency (`QuizService` / `QuizController` respectively) via their constructor,
  defaulting to the real implementation when not provided. This is what makes the
  controller and widget tests possible without hitting real data.