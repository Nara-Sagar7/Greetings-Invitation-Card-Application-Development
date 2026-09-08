import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greetings_invitation_app/app.dart';
import 'package:greetings_invitation_app/core/providers/auth_provider.dart';
import 'package:greetings_invitation_app/core/providers/connectivity_provider.dart';
import 'package:greetings_invitation_app/core/providers/data_providers.dart';
import 'package:greetings_invitation_app/data/repositories/data_repository.dart';
import 'package:greetings_invitation_app/models/event_model.dart';
import 'package:greetings_invitation_app/models/template_model.dart';
import 'package:greetings_invitation_app/services/connectivity_service.dart';
import 'package:greetings_invitation_app/services/template_service.dart';

class FakeRepo implements DataRepository {
  @override
  Future<void> deleteDraft(String id) async {}
  @override
  Future<EventModel?> getDraft(String id) async => null;
  @override
  Future<List<EventModel>> getDrafts() async => [];
  @override
  Future<TemplateModel?> getTemplateById(String id) async => null;
  @override
  Future<List<TemplateModel>> getTemplates({
    String? occasionId,
    String? search,
  }) async => TemplateService.getDummyTemplates()
      .where((t) => occasionId == null || t.occasionId == occasionId)
      .toList();
  @override
  Future<void> queueAction(String action, Map<String, dynamic> payload) async {}
  @override
  Future<void> saveDraft(EventModel event) async {}
}

void main() {
  testWidgets('App boots to Home', (tester) async {
    final fakeRepo = FakeRepo();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
          isLoggedInProvider.overrideWith((ref) => false),
          currentUserProvider.overrideWith((ref) => null),
          dataRepositoryProvider.overrideWith((ref) => fakeRepo),
          connectivityServiceProvider.overrideWith((ref) {
            final svc = ConnectivityService();
            ref.onDispose(svc.dispose);
            return svc;
          }),
        ],
        child: const GreetingsApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Greetings'), findsOneWidget);
    expect(find.textContaining('What you see'), findsWidgets);
  });
}
