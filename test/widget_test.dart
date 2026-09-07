import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mahder_mobile/core/widgets/button.dart';

void main() {
  testWidgets('submission button invokes action and blocks taps while loading',
      (tester) async {
    var submissions = 0;
    Future<void> showButton({bool loading = false}) => tester.pumpWidget(
          MaterialApp(
              home: Scaffold(
                  body: ButtonWidget(
            text: 'Submit',
            loadingText: 'Submitting',
            isLoading: loading,
            onPressed: () => submissions++,
          ))),
        );

    await showButton();
    expect(find.text('Submit'), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    expect(submissions, 1);

    await showButton(loading: true);
    expect(find.text('Submitting...'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull);
    await tester.tap(find.byType(ElevatedButton));
    expect(submissions, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
