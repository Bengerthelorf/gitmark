import 'package:flutter_test/flutter_test.dart';
import 'package:gitmark/app.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GitHubMarkdownApp());

    // 验证应用程序启动成功
    expect(find.byType(GitHubMarkdownApp), findsOneWidget);
  });
}
