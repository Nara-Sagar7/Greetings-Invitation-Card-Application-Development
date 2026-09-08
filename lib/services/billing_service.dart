import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';

/// BillingService - PRD 6.9 gates 3/5 per month + premium
class BillingService {
  static const _boxName = 'billing';
  static const _eventsKey = 'event_timestamps';
  static const _cardsKey = 'card_timestamps';
  static const _premiumKey = 'isPremium';

  static Future<Box> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box(_boxName);
    return Hive.openBox(_boxName);
  }

  static Future<bool> get isPremium async {
    final box = await _box();
    return box.get(_premiumKey, defaultValue: false) as bool;
  }

  static Future<void> setPremium(bool v) async {
    final box = await _box();
    await box.put(_premiumKey, v);
  }

  static bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  static Future<bool> canCreateEvent() async {
    if (await isPremium) return true;
    final box = await _box();
    final list = List<String>.from(
      box.get(_eventsKey, defaultValue: <String>[]) as List,
    );
    final now = DateTime.now();
    final count = list
        .where((s) => _isSameMonth(DateTime.parse(s), now))
        .length;
    return count < AppConstants.maxFreeEventsPerMonth;
  }

  static Future<bool> canCreateCard() async {
    if (await isPremium) return true;
    final box = await _box();
    final list = List<String>.from(
      box.get(_cardsKey, defaultValue: <String>[]) as List,
    );
    final now = DateTime.now();
    final count = list
        .where((s) => _isSameMonth(DateTime.parse(s), now))
        .length;
    return count < AppConstants.maxFreeCardsPerMonth;
  }

  static Future<void> recordEvent() async {
    final box = await _box();
    final list = List<String>.from(
      box.get(_eventsKey, defaultValue: <String>[]) as List,
    );
    list.add(DateTime.now().toIso8601String());
    await box.put(_eventsKey, list);
  }

  static Future<void> recordCard() async {
    final box = await _box();
    final list = List<String>.from(
      box.get(_cardsKey, defaultValue: <String>[]) as List,
    );
    list.add(DateTime.now().toIso8601String());
    await box.put(_cardsKey, list);
  }

  static Future<void> clearForTest() async {
    final box = await _box();
    await box.clear();
  }
}
