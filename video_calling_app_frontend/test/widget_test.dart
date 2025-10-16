import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_calling_app_frontend/main.dart';

void main() {
  testWidgets('App generation message displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('video_calling_app_frontend App is being generated...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('App bar has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('video_calling_app_frontend'), findsOneWidget);
  });
}
