import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petcare/features/dashboard/presentation/pages/dashboard_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: Dashboard(firstName: 'Aayush', email: 'aayush@gmail.com'),
      ),
    );
  }

  group('Dashboard Widget Tests', () {
    testWidgets('should render Dashboard widget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Dashboard), findsOneWidget);
    });

    testWidgets('should show Home screen by default', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('should show 4 bottom navigation items', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Discover'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should navigate to Explore screen when tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Explore'));
      await tester.pumpAndSettle();

      expect(find.text('Explore'), findsWidgets);
    });

    testWidgets('should navigate to Discover screen when tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Discover'));
      await tester.pumpAndSettle();

      expect(find.text('Discover'), findsWidgets);
    });

    testWidgets('should navigate to Profile screen when tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsWidgets);
    });
  });
}
