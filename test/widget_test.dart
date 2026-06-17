// This is a basic Flutter widget test for the Resume Builder app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package.

import 'package:flutter_test/flutter_test.dart';
import 'package:resume_builder/main.dart';

void main() {
  testWidgets('Resume Builder smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title "Hero Resume" is displayed.
    expect(find.text('Hero Resume'), findsOneWidget);
  });
}
