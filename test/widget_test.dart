import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itt_portal_estudiantil/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ITTPortalApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
