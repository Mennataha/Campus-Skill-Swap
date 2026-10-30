import 'package:flutter_test/flutter_test.dart';
import 'package:skillswap/main.dart';

void main() {
  testWidgets('SkillSwap app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SkillSwapApp());

    expect(find.text('Welcome to SkillSwap!'), findsOneWidget);
  });
}
