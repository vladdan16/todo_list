import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_list/main_development.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('add task test', (tester) async {
    // await tester.pumpWidget(const TodoListApp());
    app.main();

    // I need this, because I don't know how to wait app to be initialized ;)
    await Future.delayed(const Duration(seconds: 5));

    await tester.pumpAndSettle();

    final Finder fab = find.byType(FloatingActionButton);
    await tester.tap(fab);

    await tester.pumpAndSettle();

    final Finder textField = find.byType(TextField);
    await tester.enterText(textField, 'New Test Task');

    final Finder saveButton = find.widgetWithText(TextButton, 'SAVE');
    await tester.tap(saveButton);

    await tester.pumpAndSettle();

    expect(find.text('New Task'), findsOneWidget);
  });
}
