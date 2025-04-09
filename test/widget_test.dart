// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import your main app file and router file
import 'package:bong_bae/main.dart';
import 'package:bong_bae/core/router.dart'; // Adjust path if needed

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // --- Add these lines ---
    // Create an instance of the router for the test.
    // Note: For widget tests, the full async init might not always run or be needed,
    // depending on what you test. If tests fail due to router state later,
    // you might need more sophisticated test setup (e.g., mocking or waiting).
    final AppRouter testAppRouter = AppRouter();
    // You might need a small delay IF your tests immediately try to navigate
    // and hit the redirect logic before the mock/test init completes.
    // await Future.delayed(const Duration(milliseconds: 10)); // Often not needed initially
    // ---------------------

    // Build our app and trigger a frame, passing the router instance.
    // Use the variable, not the global instance if you removed it.
    await tester.pumpWidget(
      BongBaeApp(appRouter: testAppRouter),
    ); // <-- Pass the instance

    // --- Original Counter Test Logic (You'll likely replace this later) ---
    // Verify that our counter starts at 0.
    expect(
      find.text('0'),
      findsOneWidget,
    ); // This will fail now as counter isn't there
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add)); // This will fail now
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing); // This will fail now
    expect(find.text('1'), findsOneWidget); // This will fail now
    // --- End of Original Counter Test Logic ---

    // TODO: Replace the counter test logic above with meaningful widget tests
    // for your actual app screens (e.g., verify splash screen appears,
    // verify login screen has email/password fields).
    // Example: Test if splash screen shows initially (may require pumpAndSettle)
    // await tester.pumpAndSettle(); // Allow time for initialization/redirects
    // expect(find.byType(SplashScreen), findsOneWidget); // Adjust based on actual initial screen after redirects
  });
}
