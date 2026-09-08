import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/event_model.dart';

class GuestListNotifier extends StateNotifier<List<GuestModel>> {
  static const _boxName = 'guests_box';
  GuestListNotifier() : super([]) {
    _load();
  }

  Future<Box<GuestModel>> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box<GuestModel>(_boxName);
    return Hive.openBox<GuestModel>(_boxName);
  }

  Future<void> _load() async {
    final box = await _box();
    state = box.values.toList();
  }

  bool isValidEmail(String e) => RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(e);

  Future<bool> addGuest(String name, String email) async {
    if (!isValidEmail(email)) return false;
    if (state.any((g) => g.email.toLowerCase() == email.toLowerCase()))
      return false;
    final guest = GuestModel(email: email.trim(), name: name.trim());
    final box = await _box();
    await box.put(email.toLowerCase(), guest);
    state = [...state, guest];
    return true;
  }

  Future<void> removeGuest(String email) async {
    final box = await _box();
    await box.delete(email.toLowerCase());
    state = state
        .where((g) => g.email.toLowerCase() != email.toLowerCase())
        .toList();
  }

  Future<void> clearAll() async {
    final box = await _box();
    await box.clear();
    state = [];
  }

  String toCsv() {
    final buf = StringBuffer();
    buf.writeln('Name,Email,RSVP,Answer');
    for (final g in state) {
      buf.writeln(
        '${_esc(g.name)},${_esc(g.email)},${g.rsvp},${_esc(g.customAnswer ?? '')}',
      );
    }
    return buf.toString();
  }

  String _esc(String s) => '"${s.replaceAll('"', '""')}"';
}

final guestListProvider =
    StateNotifierProvider<GuestListNotifier, List<GuestModel>>(
      (ref) => GuestListNotifier(),
    );
