import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_primera_app/screens/sprite_carousel.dart';

void main() {
  testWidgets('Carousel smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: SpriteCarousel(),
      ),
    ));

    // Verify if next button is present
    expect(find.text('Next'), findsOneWidget);
  });
}
