import 'dart:async';

import 'package:flutter/foundation.dart';

/// Converts Stream to Listenable for GoRouter refresh
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _sub;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
