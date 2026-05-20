import 'dart:math';
import 'word_banks.dart';

// ─── ENUMS ───────────────────────────────────────────────────────────────────

enum Gender { male, female }

enum GimmickType { costumes, personas, shock, mythology, humor, ideological }

extension GimmickTypeLabel on GimmickType {
  String get label {
    switch (this) {
      case GimmickType.costumes:    return 'Costumes';
      case GimmickType.personas:    return 'Personas';
      case GimmickType.shock:       return 'Shock';
      case GimmickType.mythology:   return 'Mythology';
      case GimmickType.humor:       return 'Humor';
      case GimmickType.ideological: return 'Ideological';
    }
  }
}

// ─── CONSTANTS ───────────────────────────────────────────────────────────────

/// Chance (out of 100) that a generated band has a gimmick. Easy to tune here.
const int kGimmickChance = 5;

/// Starting fan club range.
const int kFanClubMin = 50;
const int kFanClubMax = 500;

/// Member age range at generation.
const int kMemberAgeMin = 18;
const int kMemberAgeMax = 35;

// ─── BAND MEMBER ─────────────────────────────────────────────────────────────

class ComplexBandMember {
  final String name;
  final int age;
  final Gender gender;
  final String instrument;
  final String? doubleInstrument;

  final double charisma;
  final double skill;
  final double creativity;
  final double resilience;

  // True 1-100 rolls — not factored into any band averages.
  final double growthRate;
  final double motivation;

  const ComplexBandMember({
    required this.name,
    required this.age,
    required this.gender,
    required this.instrument,
    this.doubleInstrument,
    required this.charisma,
    required this.skill,
    required this.creativity,
    required this.resilience,
    required this.growthRate,
    required this.motivation,
  });

  String get displayInstrument {
    if (doubleInstrument != null) return '$instrument / $doubleInstrument';
    return instrument;
  }

  String get genderLabel => gender == Gender.male ? 'M' : 'F';
}

// ─── BAND SKILLS ─────────────────────────────────────────────────────────────

class BandSkills {
  final double technicalProwess;
  final double songwriting;
  final double stagePresence;
  final double dedication;
  final double signatureSound;
  final double chemistry;

  double get overall =>
      (technicalProwess + songwriting + stagePresence + dedication +
          signatureSound + chemistry) / 6.0;

  const BandSkills({
    required this.technicalProwess,
    required this.songwriting,
    required this.stagePresence,
    required this.dedication,
    required this.signatureSound,
    required this.chemistry,
  });
}

// ─── BAND TRAITS ─────────────────────────────────────────────────────────────

class BandTraits {
  final double happiness;
  final String genre;
  final GimmickType? gimmick;
  final int fanClub;

  const BandTraits({
    required this.happiness,
    required this.genre,
    required this.gimmick,
    required this.fanClub,
  });
}

// ─── COMPLEX BAND ────────────────────────────────────────────────────────────

class ComplexBand {
  final String name;
  final List<ComplexBandMember> members;
  final BandSkills skills;
  final BandTraits traits;

  const ComplexBand({
    required this.name,
    required this.members,
    required this.skills,
    required this.traits,
  });
}

// ─── GENERATOR ───────────────────────────────────────────────────────────────

class ComplexBandGenerator {
  final Random _random = Random();

  static const List<String> genres = [
    'Pop', 'Rock', 'Hip-Hop', 'Soul', 'Jazz', 'Glitch-Hop',
    'Rust Beat', 'Klangor', 'Vandalo', 'Gakkion', 'Bruitogaze',
    'Indie', 'Hipster', 'Doom', 'Punk', 'AuraCore',
  ];

  /// Min/max member counts per genre, mirroring band_generator.dart.
  static const Map<String, (int, int)> _genreSizes = {
    'Pop':        (1, 5),
    'Rock':       (3, 5),
    'Hip-Hop':    (1, 4),
    'Soul':       (1, 7),
    'Jazz':       (3, 6),
    'Glitch-Hop': (1, 5),
    'Rust Beat':  (2, 4),
    'Klangor':    (4, 8),
    'Vandalo':    (3, 5),
    'Gakkion':    (3, 5),
    'Bruitogaze': (2, 4),
    'Indie':      (1, 4),
    'Hipster':    (5, 10),
    'Doom':       (3, 5),
    'Punk':       (3, 5),
    'AuraCore':   (1, 1),
  };

  static const List<String> _instruments = [
    'Vocals', 'Guitar', 'Bass', 'Drums', 'Keyboard',
    'Piano', 'Synth', 'Brass', 'Percussion', 'DJ',
  ];

  /// Generate a full complex band.
  /// [forcedGenre] — null means random.
  /// [qualityTier] — null means random (defaults to 20-tier range).
  ///   Valid values: 10, 20, 30, 40, 50, 60, 70, 80, 90.
  ///   Stats roll within [tier - 5, tier + 5] with decimal noise.
  ComplexBand generate({String? forcedGenre, int? qualityTier}) {
    final genre = forcedGenre ?? genres[_random.nextInt(genres.length)];
    final tier = qualityTier ?? 20;
    final (minM, maxM) = _genreSizes[genre] ?? (3, 5);
    final memberCount = minM + _random.nextInt(maxM - minM + 1);

    final members = List.generate(memberCount, (_) => _generateMember(tier));
    final skills = _buildSkills(members, tier);
    final traits = _buildTraits(genre);
    final name = _generateBandName();

    return ComplexBand(
      name: name,
      members: members,
      skills: skills,
      traits: traits,
    );
  }

  // ─── MEMBER ──────────────────────────────────────────────────────────────

  ComplexBandMember _generateMember(int tier) {
    final gender = _random.nextBool() ? Gender.male : Gender.female;
    final age = kMemberAgeMin + _random.nextInt(kMemberAgeMax - kMemberAgeMin + 1);

    return ComplexBandMember(
      name: _generateMemberName(gender),
      age: age,
      gender: gender,
      instrument: _instruments[_random.nextInt(_instruments.length)],
      charisma:   _rollCoreStat(tier),
      skill:      _rollCoreStat(tier),
      creativity: _rollCoreStat(tier),
      resilience: _rollCoreStat(tier),
      growthRate: _rollGrowthStat(),
      motivation: _rollGrowthStat(),
    );
  }

  /// Core stat: [tier-5 .. tier+5] with decimal noise.
  /// Naturally spills over 100 for high tiers — that's intentional.
  double _rollCoreStat(int tier) {
    final min = (tier - 5).toDouble();
    final value = min + (_random.nextDouble() * 10.0) + (_random.nextDouble() * 0.99);
    return double.parse(value.toStringAsFixed(2));
  }

  /// Growth stats: true 1.00–100.00, independent of quality tier.
  double _rollGrowthStat() {
    return double.parse((1.0 + _random.nextDouble() * 99.0).toStringAsFixed(2));
  }

  String _generateMemberName(Gender gender) {
    final firstNames = gender == Gender.male ? maleFirstNames : femaleFirstNames;
    final first = firstNames[_random.nextInt(firstNames.length)];
    final last = surnames[_random.nextInt(surnames.length)];
    return '$first $last';
  }

  // ─── BAND SKILLS ─────────────────────────────────────────────────────────

  BandSkills _buildSkills(List<ComplexBandMember> members, int tier) {
    double avg(double Function(ComplexBandMember) f) =>
        _round(members.fold(0.0, (s, m) => s + f(m)) / members.length);

    return BandSkills(
      technicalProwess: avg((m) => m.skill),
      songwriting:      avg((m) => m.creativity),
      stagePresence:    avg((m) => m.charisma),
      dedication:       avg((m) => m.resilience),
      signatureSound:   _rollCoreStat(tier),
      chemistry:        _rollCoreStat(tier),
    );
  }

  // ─── BAND TRAITS ─────────────────────────────────────────────────────────

  BandTraits _buildTraits(String genre) {
    final gimmick = _random.nextInt(100) < kGimmickChance
        ? GimmickType.values[_random.nextInt(GimmickType.values.length)]
        : null;

    return BandTraits(
      happiness: 100.00,
      genre: genre,
      gimmick: gimmick,
      fanClub: kFanClubMin + _random.nextInt(kFanClubMax - kFanClubMin + 1),
    );
  }

  // ─── BAND NAME ───────────────────────────────────────────────────────────

  String _generateBandName() => _fillPattern(
      bandPatterns[_random.nextInt(bandPatterns.length)]);

  String _fillPattern(String pattern) {
    if (pattern.startsWith('[Acronym:')) {
      final words = [_pick('Noun'), _pick('Noun'), _pick('Noun')];
      final acronym = words.map((w) => w[0].toUpperCase()).join('');
      return '$acronym (${words.join(' ')})';
    }
    if (pattern.contains('[First_Syllable]')) {
      return _pick('First_Syllable') + _pick('Second_Syllable');
    }
    return pattern.replaceAllMapped(RegExp(r'\[([^\]]+)\]'), (m) {
      final token = m.group(1)!;
      return wordBanks.containsKey(token) ? _pick(token) : m.group(0)!;
    });
  }

  String _pick(String category) {
    if (category == 'First_Syllable') {
      return firstSyllables[_random.nextInt(firstSyllables.length)];
    }
    if (category == 'Second_Syllable') {
      return secondSyllables[_random.nextInt(secondSyllables.length)];
    }
    final list = wordBanks[category];
    if (list == null || list.isEmpty) return '';
    return list[_random.nextInt(list.length)];
  }

  double _round(double v) => double.parse(v.toStringAsFixed(2));
}