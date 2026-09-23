import 'package:flutter_test/flutter_test.dart';

import 'package:geo_trivia/main.dart';

void main() {
  testWidgets('shows the flag quiz and answer options', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Find the capital city for this flag'), findsOneWidget);
    expect(find.textContaining('Question 1/'), findsOneWidget);
    expect(find.text('Paris'), findsOneWidget);
  });
}
