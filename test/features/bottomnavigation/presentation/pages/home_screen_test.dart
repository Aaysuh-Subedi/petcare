import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petcare/features/bottomnavigation/presentation/pages/home_screen.dart';

void main() {
  testWidgets('HomeScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen(firstName: 'Aayush')),
    );

    // All widgets render instantly in test
    expect(find.text('Hello, Aayush! 👋'), findsOneWidget);
    expect(find.text('Welcome to PawCare'), findsOneWidget);
    expect(find.text('Add Your Pet'), findsOneWidget);
    expect(find.text('My Pets'), findsOneWidget);
    expect(find.text('No pets yet'), findsOneWidget);
    expect(find.text('Services'), findsOneWidget);

    // Service cards
    expect(find.text('Veterinary'), findsOneWidget);
    expect(find.text('Grooming'), findsOneWidget);
    expect(find.text('Pet Shop'), findsOneWidget);
    expect(find.text('Boarding'), findsOneWidget);
  });
}
