import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greetings_invitation_app/app.dart';

void main() {
  testWidgets('App boots to Home', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: GreetingsApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Greetings'), findsOneWidget);
    expect(find.text('What you see'), findsWidgets);
  });
}
