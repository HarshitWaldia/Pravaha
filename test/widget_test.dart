import 'package:flutter_test/flutter_test.dart';
import 'package:pravaha/main.dart';

void main() {
  testWidgets('Pravaha app boots up smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PravahaApp());
    expect(find.textContaining('Pravāha'), findsWidgets);
  });
}
