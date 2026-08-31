import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook_workspace/main.dart';

void main() {
  testWidgets('WidgetbookApp builds without crashing', (tester) async {
    await tester.pumpWidget(const ThanksWidgetbookApp());
    expect(find.byType(ThanksWidgetbookApp), findsOneWidget);
  });
}
