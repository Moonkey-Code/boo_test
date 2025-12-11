import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Basic widget test demonstrating interaction, tapping, and state updates.
/// This file is a template and should be adapted once real widgets are available.
void main() {
  testWidgets('Example counter test', (WidgetTester tester) async {
    // ------------------------------------------------------------------------
    // BUILD TEST WIDGET
    // ------------------------------------------------------------------------
    // You should replace this placeholder widget with your actual widget.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: StatefulBuilder(
              builder: (context, setState) {
                int counter = 0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$counter', key: const Key('counter-text')),
                    IconButton(
                      key: const Key('increment-btn'),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        counter++;
                        setState(() {});
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    // ------------------------------------------------------------------------
    // INITIAL STATE ASSERTIONS
    // ------------------------------------------------------------------------
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // ------------------------------------------------------------------------
    // PERFORM ACTION: TAP INCREMENT BUTTON
    // ------------------------------------------------------------------------
    await tester.tap(find.byKey(const Key('increment-btn')));
    await tester.pump();

    // ------------------------------------------------------------------------
    // VERIFY STATE UPDATE
    // ------------------------------------------------------------------------
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:boo_test/main.dart' as app;

// void main() {
//   testWidgets('App renders without exceptions', (WidgetTester tester) async {
//     await tester.pumpWidget(app.MyApp(initialProfiles: []));
//     expect(find.byType(MaterialApp), findsOneWidget);
//   });

//   testWidgets('MatchPage loads correctly', (WidgetTester tester) async {
//     await tester.pumpWidget(app.MyApp(initialProfiles: []));
//     await tester.pumpAndSettle();

//     // Expect at least scaffold exists
//     expect(find.byType(Scaffold), findsOneWidget);
//   });
// }

