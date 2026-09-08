import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).authStateChanges,
);

final currentUserProvider = Provider<User?>(
  (ref) => ref.watch(authStateProvider).value,
);

final isLoggedInProvider = Provider<bool>(
  (ref) => ref.watch(authStateProvider).value != null,
);
