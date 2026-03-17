import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_match/main.dart';

void main() {
  testWidgets('GitMatch app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GitMatchApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
