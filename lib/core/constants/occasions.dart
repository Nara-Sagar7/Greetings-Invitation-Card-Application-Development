import 'package:flutter/material.dart';

/// Occasion registry - PRD Section 06.4
/// 18 categories • 200 templates target (ship 150-180 first, weekly drops to 200)
enum OccasionGroup { evergreen, indianFestival, broadFestival }

class Occasion {
  final String id;
  final String name;
  final String emoji;
  final OccasionGroup group;
  final String description;
  final bool needsCulturalReview;
  final Color accentColor;

  const Occasion({
    required this.id,
    required this.name,
    required this.emoji,
    required this.group,
    required this.description,
    this.needsCulturalReview = false,
    required this.accentColor,
  });
}

class Occasions {
  // EVERGREEN - 9 (10-15 templates each)
  static const birthday = Occasion(
    id: 'birthday',
    name: 'Birthday',
    emoji: '🎂',
    group: OccasionGroup.evergreen,
    description: 'Birthday invitations & greetings',
    accentColor: Color(0xFFE8A33D),
  );
  static const wedding = Occasion(
    id: 'wedding',
    name: 'Wedding',
    emoji: '💍',
    group: OccasionGroup.evergreen,
    description: 'Wedding invitations',
    accentColor: Color(0xFF3B2452),
  );
  static const anniversary = Occasion(
    id: 'anniversary',
    name: 'Anniversary',
    emoji: '💘',
    group: OccasionGroup.evergreen,
    description: 'Anniversary celebrations',
    accentColor: Color(0xFFF2726F),
  );
  static const thankYou = Occasion(
    id: 'thank_you',
    name: 'Thank You',
    emoji: '🙏',
    group: OccasionGroup.evergreen,
    description: 'Thank you cards',
    accentColor: Color(0xFF2E9E6D),
  );
  static const congratulations = Occasion(
    id: 'congratulations',
    name: 'Congratulations',
    emoji: '🎊',
    group: OccasionGroup.evergreen,
    description: 'Congratulations greetings',
    accentColor: Color(0xFFE8A33D),
  );
  static const getWellSoon = Occasion(
    id: 'get_well_soon',
    name: 'Get Well Soon',
    emoji: '🌿',
    group: OccasionGroup.evergreen,
    description: 'Get well wishes',
    accentColor: Color(0xFF3D7EBF),
  );
  static const newBaby = Occasion(
    id: 'new_baby',
    name: 'New Baby',
    emoji: '👶',
    group: OccasionGroup.evergreen,
    description: 'New baby arrivals',
    accentColor: Color(0xFFF2726F),
  );
  static const housewarming = Occasion(
    id: 'housewarming',
    name: 'Housewarming',
    emoji: '🏡',
    group: OccasionGroup.evergreen,
    description: 'Housewarming invitations',
    accentColor: Color(0xFF2E9E6D),
  );
  static const farewell = Occasion(
    id: 'farewell',
    name: 'Farewell / Retirement',
    emoji: '👋',
    group: OccasionGroup.evergreen,
    description: 'Farewell & retirement',
    accentColor: Color(0xFF3B2452),
  );

  // INDIAN FESTIVALS - 5 (Cultural Accuracy Gate Required)
  static const diwali = Occasion(
    id: 'diwali',
    name: 'Diwali',
    emoji: '🪔',
    group: OccasionGroup.indianFestival,
    description: 'Festival of Lights',
    needsCulturalReview: true,
    accentColor: Color(0xFFE8A33D),
  );
  static const holi = Occasion(
    id: 'holi',
    name: 'Holi',
    emoji: '🎨',
    group: OccasionGroup.indianFestival,
    description: 'Festival of Colors',
    needsCulturalReview: true,
    accentColor: Color(0xFFF2726F),
  );
  static const rakshaBandhan = Occasion(
    id: 'raksha_bandhan',
    name: 'Raksha Bandhan',
    emoji: '🎀',
    group: OccasionGroup.indianFestival,
    description: 'Bond of protection',
    needsCulturalReview: true,
    accentColor: Color(0xFFE8A33D),
  );
  static const navratri = Occasion(
    id: 'navratri',
    name: 'Navratri / Durga Puja',
    emoji: '🪔',
    group: OccasionGroup.indianFestival,
    description: 'Nine nights celebration',
    needsCulturalReview: true,
    accentColor: Color(0xFFD64550),
  );
  static const ganeshChaturthi = Occasion(
    id: 'ganesh_chaturthi',
    name: 'Ganesh Chaturthi',
    emoji: '🐘',
    group: OccasionGroup.indianFestival,
    description: 'Lord Ganesh festival',
    needsCulturalReview: true,
    accentColor: Color(0xFFE8A33D),
  );

  // BROAD FESTIVALS - 4
  static const eid = Occasion(
    id: 'eid',
    name: 'Eid',
    emoji: '☪️',
    group: OccasionGroup.broadFestival,
    description: 'Eid celebrations',
    accentColor: Color(0xFF2E9E6D),
  );
  static const christmas = Occasion(
    id: 'christmas',
    name: 'Christmas',
    emoji: '🎄',
    group: OccasionGroup.broadFestival,
    description: 'Christmas greetings',
    accentColor: Color(0xFFD64550),
  );
  static const newYear = Occasion(
    id: 'new_year',
    name: 'New Year',
    emoji: '🎆',
    group: OccasionGroup.broadFestival,
    description: 'New Year celebrations',
    accentColor: Color(0xFF3B2452),
  );
  static const valentines = Occasion(
    id: 'valentines',
    name: "Valentine's Day",
    emoji: '💝',
    group: OccasionGroup.broadFestival,
    description: 'Love & celebration',
    accentColor: Color(0xFFF2726F),
  );

  static const List<Occasion> all = [
    // Evergreen
    birthday,
    wedding,
    anniversary,
    thankYou,
    congratulations,
    getWellSoon,
    newBaby,
    housewarming,
    farewell,
    // Indian
    diwali,
    holi,
    rakshaBandhan,
    navratri,
    ganeshChaturthi,
    // Broad
    eid,
    christmas,
    newYear,
    valentines,
  ];

  static List<Occasion> get evergreen =>
      all.where((o) => o.group == OccasionGroup.evergreen).toList();
  static List<Occasion> get indianFestivals =>
      all.where((o) => o.group == OccasionGroup.indianFestival).toList();
  static List<Occasion> get broadFestivals =>
      all.where((o) => o.group == OccasionGroup.broadFestival).toList();

  static Occasion? byId(String id) {
    try {
      return all.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}
