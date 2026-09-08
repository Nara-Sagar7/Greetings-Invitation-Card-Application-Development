import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'models/event_model.dart';
import 'models/template_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hive for offline queue - PRD 06.7
  await Hive.initFlutter();
  // Register Hive adapters - P0-1 typed boxes
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TemplateModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(EventModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(GuestModelAdapter());
  }
  // Clear old raw boxes (user approved clear) - P0-1 migration
  try {
    await Hive.deleteBoxFromDisk('drafts');
  } catch (_) {}
  try {
    await Hive.deleteBoxFromDisk('offline_queue');
  } catch (_) {}
  // Firebase Phase B - initialized via flutterfire
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: GreetingsApp()));
}
