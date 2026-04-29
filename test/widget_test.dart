import 'package:flutter_test/flutter_test.dart';
import 'package:futvision_mobile/main.dart';

void main() {
  testWidgets('FutVision app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FutVisionApp());
    expect(find.text('FutVision'), findsNothing);
  });
}
