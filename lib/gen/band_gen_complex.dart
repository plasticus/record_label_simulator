import 'dart:math';
import 'patterns.dart';
import 'asset_loader.dart';
import 'gen_human_names.dart';

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

const int kGimmickChance   = 5;

/// Prepositions that make logical sense in creature/situation band name patterns.
/// e.g. "Yeti On A Budget", "Kraken Against A Tribunal"
const List<String> creaturePrepositions = [
  'On', 'With', 'Without', 'Against', 'Beyond',
  'Before', 'After', 'Under', 'Over', 'Through',
  'During', 'Across', 'Within', 'Amid',
];
const int kFanClubMin      = 50;
const int kFanClubMax      = 500;
const int kMemberAgeMin    = 18;
const int kMemberAgeMax    = 35;

// ─── GENRE DATA ──────────────────────────────────────────────────────────────

class GenreData {
  final String name;
  final String description;
  final int minMembers;
  final int maxMembers;
  final List<String> minInstruments;
  final List<String> otherInstruments;
  final int backingVocalChance;
  final String vocalistType;
  final Map<String, int> vocalDoubleWeights;

  GenreData({
    required this.name,
    required this.description,
    required this.minMembers,
    required this.maxMembers,
    required this.minInstruments,
    required this.otherInstruments,
    required this.backingVocalChance,
    required this.vocalistType,
    required this.vocalDoubleWeights,
  });
}

// ─── BAND MEMBER ─────────────────────────────────────────────────────────────

class ComplexBandMember {
  String name;
  final int age;
  final Gender gender;
  String instrument;
  String? doubleInstrument;
  bool isLeadVocals;
  bool isBackingVocals;

  // Core stats — soft ceiling 100, legendary can exceed.
  final double charisma;
  final double skill;
  final double creativity;
  final double resilience;

  // Growth stats — true 1-100, not factored into band averages.
  final double growthRate;
  final double motivation;

  ComplexBandMember({
    required this.name,
    required this.age,
    required this.gender,
    required this.instrument,
    this.doubleInstrument,
    this.isLeadVocals = false,
    this.isBackingVocals = false,
    required this.charisma,
    required this.skill,
    required this.creativity,
    required this.resilience,
    required this.growthRate,
    required this.motivation,
  });

  String get displayInstrument {
    List<String> roles = [instrument];
    if (instrument == 'Vocals' && doubleInstrument != null) {
      roles.add(doubleInstrument!);
    }
    if (isLeadVocals && instrument != 'Vocals') {
      roles.add('Vocals');
    }
    if (isBackingVocals) {
      roles.add('Backing Vocals');
    }
    return roles.join(' / ');
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
  AppData? _appData;
  NameGenerator? _nameGenerator;

  /// Must be called once before generating bands.
  /// e.g. await ComplexBandGenerator.instance.init();
  Future<void> init() async {
    _appData = await AssetLoader.load();
    final surnameGen = SurnameGenerator(_appData!);
    _nameGenerator = NameGenerator(_appData!, surnameGen);
  }

  static const List<String> genres = [
    'Pop', 'Rock', 'Hip-Hop', 'Soul', 'Jazz', 'Glitch-Hop',
    'Rust Beat', 'Klangor', 'Vandalo', 'Gakkion', 'Bruitogaze',
    'Indie', 'Hipster', 'Doom', 'Punk', 'AuraCore',
  ];

  final Map<String, GenreData> genreData = {
    'Pop': GenreData(
      name: 'Pop',
      description: 'Polished, chart-topping melodies designed for mass-market appeal, catchy hooks, and radio dominance.',
      minMembers: 1, maxMembers: 5,
      minInstruments: ['Vocals'],
      otherInstruments: ['Vocals', 'Piano', 'Keyboard', 'Guitar'],
      backingVocalChance: 25,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 50, 'Keyboard': 35, 'Bass': 15},
    ),
    'Rock': GenreData(
      name: 'Rock',
      description: 'Classic amplified energy fueled by driving drum beats, heavy bass lines, and raw, electric guitar riffs.',
      minMembers: 3, maxMembers: 5,
      minInstruments: ['Vocals', 'Drums', 'Guitar', 'Bass'],
      otherInstruments: ['Guitar', 'Brass', 'Keyboard'],
      backingVocalChance: 10,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 60, 'Bass': 25, 'Drums': 15},
    ),
    'Hip-Hop': GenreData(
      name: 'Hip-Hop',
      description: 'Rhythm-and-rhyme focused street poetry backed by booming electronic beats, clever wordplay, and heavy bass lines.',
      minMembers: 1, maxMembers: 4,
      minInstruments: ['Vocals'],
      otherInstruments: ['Vocals', 'DJ', 'Drums'],
      backingVocalChance: 25,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {},
    ),
    'Soul': GenreData(
      name: 'Soul',
      description: 'Deeply emotional, expressive music rooted in powerful vocal harmonies, warm brass sections, and groovy rhythm sections.',
      minMembers: 1, maxMembers: 7,
      minInstruments: ['Vocals'],
      otherInstruments: ['Vocals', 'Keyboard', 'Drums', 'Bass', 'Brass', 'Percussion'],
      backingVocalChance: 50,
      vocalistType: 'standalone',
      vocalDoubleWeights: {},
    ),
    'Jazz': GenreData(
      name: 'Jazz',
      description: 'Complex, improvisational musicianship driven by swing rhythms, virtuosic solos, and intricate chord progressions.',
      minMembers: 3, maxMembers: 6,
      minInstruments: ['Drums', 'Bass', 'Brass'],
      otherInstruments: ['Vocals', 'Piano', 'Keyboard', 'Guitar'],
      backingVocalChance: 10,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 70, 'Piano': 30},
    ),
    'Glitch-Hop': GenreData(
      name: 'Glitch-Hop',
      description: 'Funk-infused electronic hip-hop beats chopped up with digital stutter effects, heavy synthetic bass, and mechanical chirps.',
      minMembers: 1, maxMembers: 5,
      minInstruments: ['Vocals', 'DJ'],
      otherInstruments: ['Vocals', 'Synth', 'Drums', 'Bass'],
      backingVocalChance: 50,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Synth': 60, 'Bass': 40},
    ),
    'Rust Beat': GenreData(
      name: 'Rust Beat',
      description: 'Industrial, dance-focused garage rock echoing with metallic clangs, driving drum machines, and fuzzy, distorted bass lines.',
      minMembers: 2, maxMembers: 4,
      minInstruments: ['Vocals', 'Drums', 'Bass'],
      otherInstruments: ['Guitar', 'Synth', 'Keyboard', 'Percussion'],
      backingVocalChance: 10,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 55, 'Bass': 30, 'Drums': 15},
    ),
    'Klangor': GenreData(
      name: 'Klangor',
      description: 'Aggressive German-born heavy metal welded seamlessly to powerful, booming brass orchestration and thunderous rhythms.',
      minMembers: 4, maxMembers: 8,
      minInstruments: ['Vocals', 'Guitar', 'Drums', 'Brass'],
      otherInstruments: ['Guitar', 'Bass', 'Brass', 'Percussion'],
      backingVocalChance: 25,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 70, 'Bass': 30},
    ),
    'Vandalo': GenreData(
      name: 'Vandalo',
      description: 'High-octane, rebellious Latin rock infused with explosive tropical percussion and fiercely passionate, high-energy vocals.',
      minMembers: 3, maxMembers: 5,
      minInstruments: ['Vocals', 'Guitar', 'Drums', 'Percussion'],
      otherInstruments: ['Percussion', 'Vocals', 'Brass'],
      backingVocalChance: 25,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 55, 'Percussion': 45},
    ),
    'Gakkion': GenreData(
      name: 'Gakkion',
      description: 'Japanese-pioneered math rock featuring hyper-complex time signatures played on predominantly customized, handmade instruments.',
      minMembers: 3, maxMembers: 5,
      minInstruments: ['Vocals', 'Guitar', 'Bass', 'Drums'],
      otherInstruments: ['Percussion', 'Keyboard'],
      backingVocalChance: 10,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 65, 'Bass': 35},
    ),
    'Bruitogaze': GenreData(
      name: 'Bruitogaze',
      description: 'French-inspired hypnotic soundscapes drowning in staggering walls of pure distortion, echoes, and heavily affected vocals.',
      minMembers: 2, maxMembers: 4,
      minInstruments: ['Vocals', 'Synth'],
      otherInstruments: ['Vocals', 'Drums', 'Guitar', 'Keyboard'],
      backingVocalChance: 10,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 50, 'Synth': 50},
    ),
    'Indie': GenreData(
      name: 'Indie',
      description: 'Quirky, independent bedroom productions favoring artistic freedom, acoustic textures, and slightly eccentric lyrical themes.',
      minMembers: 1, maxMembers: 4,
      minInstruments: ['Vocals', 'Guitar'],
      otherInstruments: ['Vocals', 'Drums', 'Bass', 'Keyboard', 'Piano', 'Brass'],
      backingVocalChance: 25,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 65, 'Piano': 20, 'Bass': 15},
    ),
    'Hipster': GenreData(
      name: 'Hipster',
      description: "Folksy, fast paced strum heavy poems, filled with hey's and ho's. Feels like thrift shop background music.",
      minMembers: 5, maxMembers: 10,
      minInstruments: ['Vocals', 'Backing Vocals', 'Guitar'],
      otherInstruments: ['Keyboard', 'Guitar', 'Bass', 'Drums', 'Percussion', 'Brass'],
      backingVocalChance: 25,
      vocalistType: 'standalone',
      vocalDoubleWeights: {},
    ),
    'Doom': GenreData(
      name: 'Doom',
      description: 'Musical equivalent of a very tired, very loud dinosaur trying to get out of a beanbag chair while being haunted by a fuzz guitar.',
      minMembers: 3, maxMembers: 5,
      minInstruments: ['Vocals', 'Guitar', 'Bass', 'Drums'],
      otherInstruments: ['Keyboard', 'Synth', 'Percussion'],
      backingVocalChance: 10,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 55, 'Bass': 30, 'Drums': 15},
    ),
    'Punk': GenreData(
      name: 'Punk',
      description: 'Fighting the power for 50 years with raucous guitars and blazing bass lines.',
      minMembers: 3, maxMembers: 5,
      minInstruments: ['Vocals', 'Drums', 'Bass', 'Guitar'],
      otherInstruments: ['Vocals', 'Guitar'],
      backingVocalChance: 25,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 70, 'Bass': 30},
    ),
    'AuraCore': GenreData(
      name: 'AuraCore',
      description: 'Mystical synthy backdrop to your deep mind. See yourself floating on a river of notes and colors. Made in bedrooms for bedrooms.',
      minMembers: 1, maxMembers: 1,
      minInstruments: ['Synth'],
      otherInstruments: ['Vocals'],
      backingVocalChance: 0,
      vocalistType: 'none',
      vocalDoubleWeights: {},
    ),
  };

  // ─── GENERATE ──────────────────────────────────────────────────────────────

  ComplexBand generate({String? forcedGenre, int? qualityTier}) {
    final genreName = forcedGenre ?? genres[_random.nextInt(genres.length)];
    final genre = genreData[genreName]!;
    final tier = qualityTier ?? 20;

    final members = _buildLineup(genre, genreName, tier);
    final skills = _buildSkills(members, tier);
    final traits = _buildTraits(genreName);
    // Solo artist rule: 75% chance to use the member's real name instead of a band name.
    // AuraCore always uses a generated band name regardless of size.
    final bool isSoloArtist = members.length == 1 && genreName != 'AuraCore';
    final name = (isSoloArtist && _random.nextInt(100) < 75)
        ? members.first.name
        : _generateBandName();

    return ComplexBand(
      name: name,
      members: members,
      skills: skills,
      traits: traits,
    );
  }

  // ─── LINEUP (ported from band_generator.dart) ────────────────────────────

  List<ComplexBandMember> _buildLineup(GenreData genre, String genreName, int tier) {
    final bandSize = genre.minMembers + _random.nextInt(genre.maxMembers - genre.minMembers + 1);

    List<ComplexBandMember> members = List.generate(
      bandSize,
          (i) => _blankMember(tier),
    );

    // --- STEP 1: PREP REQUIRED POOL ---
    List<String> requiredPool = List.from(genre.minInstruments);
    requiredPool.remove('Backing Vocals');

    if (genreName == 'Klangor') {
      requiredPool.remove('Brass');
      requiredPool.add('Brass');
      requiredPool.add('Brass');
    }

    bool vocalsRequired = requiredPool.remove('Vocals');
    requiredPool.shuffle(_random);

    // --- STEP 2: RESERVE VOCALIST SLOT ---
    int memberIdx = 0;
    if (vocalsRequired && genre.vocalistType != 'none') {
      members[memberIdx].instrument = 'Vocals';
      members[memberIdx].isLeadVocals = true;
      memberIdx++;
    }

    // --- STEP 3: ASSIGN REQUIRED INSTRUMENTS ---
    List<String> droppedInstruments = [];
    for (String instrument in requiredPool) {
      if (memberIdx < members.length) {
        members[memberIdx].instrument = instrument;
        memberIdx++;
      } else {
        droppedInstruments.add(instrument);
      }
    }

    // --- STEP 4: WILDCARD ROLLS ---
    while (memberIdx < members.length) {
      members[memberIdx].instrument =
          _selectWildcard(genre.otherInstruments, genreName, members);
      memberIdx++;
    }

    // --- STEP 5: VOCAL DOUBLING ---
    if (vocalsRequired && genre.vocalistType == 'likely_standalone') {
      if (droppedInstruments.isNotEmpty) {
        _addDoubleInstrument(genre, members, forced: droppedInstruments);
      } else if (_random.nextInt(100) < 30) {
        _addDoubleInstrument(genre, members);
      }
    }

    // --- STEP 6: BACKING VOCALS ---
    const standaloneBackingGenres = {'Pop', 'Soul', 'Hipster'};
    for (var member in members) {
      if (member.isLeadVocals || member.instrument == 'Vocals') continue;
      if (member.instrument == 'Brass') continue;
      bool allowed = standaloneBackingGenres.contains(genreName)
          || member.instrument != 'None';
      if (allowed && _random.nextInt(100) < genre.backingVocalChance) {
        member.isBackingVocals = true;
      }
    }

    // --- STEP 7: SORT VOCALISTS TO TOP ---
    int vocalTier(ComplexBandMember m) {
      if (m.instrument == 'Vocals' && m.doubleInstrument == null) return 0;
      if (m.instrument == 'Vocals') return 1;
      return 2;
    }
    members.sort((a, b) => vocalTier(a).compareTo(vocalTier(b)));

    return members;
  }

  ComplexBandMember _blankMember(int tier) {
    final gender = _random.nextBool() ? Gender.male : Gender.female;
    final age = kMemberAgeMin + _random.nextInt(kMemberAgeMax - kMemberAgeMin + 1);
    return ComplexBandMember(
      name: _generateMemberName(gender),
      age: age,
      gender: gender,
      instrument: 'None',
      charisma:   _rollCoreStat(tier),
      skill:      _rollCoreStat(tier),
      creativity: _rollCoreStat(tier),
      resilience: _rollCoreStat(tier),
      growthRate: _rollGrowthStat(),
      motivation: _rollGrowthStat(),
    );
  }

  String _generateMemberName(Gender gender) {
    if (_nameGenerator == null) return gender == Gender.male ? 'Male Member' : 'Female Member';
    final result = _nameGenerator!.generate(isMale: gender == Gender.male);
    // TODO: if result.isStupid, apply +25% Motivation boost to this member
    return result.name;
  }

  void _addDoubleInstrument(GenreData genre, List<ComplexBandMember> members,
      {List<String> forced = const []}) {
    final vocalist = members.where((m) => m.isLeadVocals).firstOrNull;
    if (vocalist == null) return;

    String chosen;
    if (forced.isNotEmpty) {
      final weighted = forced
          .where((i) => genre.vocalDoubleWeights.containsKey(i))
          .toList()
        ..sort((a, b) => (genre.vocalDoubleWeights[b] ?? 0)
            .compareTo(genre.vocalDoubleWeights[a] ?? 0));
      chosen = weighted.isNotEmpty ? weighted.first : forced.first;
    } else {
      if (genre.vocalDoubleWeights.isEmpty) return;
      int total = genre.vocalDoubleWeights.values.fold(0, (a, b) => a + b);
      int roll = _random.nextInt(total);
      int cumulative = 0;
      chosen = genre.vocalDoubleWeights.keys.first;
      for (var entry in genre.vocalDoubleWeights.entries) {
        cumulative += entry.value;
        if (roll < cumulative) { chosen = entry.key; break; }
      }
    }
    vocalist.doubleInstrument = chosen;
  }

  String _selectWildcard(List<String> choices, String genreName,
      List<ComplexBandMember> lineup) {
    const unique = {'Drums', 'Bass', 'Piano', 'Keyboard', 'DJ', 'Synth'};
    final shuffled = List.from(choices)..shuffle(_random);
    for (String option in shuffled) {
      if (unique.contains(option)) {
        bool dupe = lineup.any((m) => m.instrument == option);
        if (dupe && !(genreName == 'Klangor' && option == 'Bass')) continue;
      }
      return option;
    }
    return choices[_random.nextInt(choices.length)];
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

  BandTraits _buildTraits(String genreName) {
    final gimmick = _random.nextInt(100) < kGimmickChance
        ? GimmickType.values[_random.nextInt(GimmickType.values.length)]
        : null;
    return BandTraits(
      happiness: 100.00,
      genre: genreName,
      gimmick: gimmick,
      fanClub: kFanClubMin + _random.nextInt(kFanClubMax - kFanClubMin + 1),
    );
  }

  // ─── BAND NAME ───────────────────────────────────────────────────────────

  String _generateBandName() =>
      generateBandNameFromPattern(bandPatterns[_random.nextInt(bandPatterns.length)]);

  /// Public so the band name test screen can call it with a specific pattern.
  String generateBandNameFromPattern(String pattern) {
    if (pattern.startsWith('[Acronym:')) {
      final words = [_pickBank('Noun'), _pickBank('Noun'), _pickBank('Noun')];
      final acronym = words.map((w) => w[0].toUpperCase()).join('');
      return '$acronym (${words.join(' ')})';
    }
    if (pattern.contains('[First_Syllable]')) {
      return firstSyllables[_random.nextInt(firstSyllables.length)]
          + secondSyllables[_random.nextInt(secondSyllables.length)];
    }

    // Creature pattern gets special handling for preposition and article agreement
    if (pattern.contains('[Creature_Noun]') && pattern.contains('[Situation_Noun]')) {
      return _buildCreatureName();
    }

    final name = pattern.replaceAllMapped(RegExp(r'\[([^\]]+)\]'), (m) {
      final token = m.group(1)!;
      final list = _appData?.wordBank(token) ?? [];
      return list.isNotEmpty
          ? list[_random.nextInt(list.length)]
          : m.group(0)!;
    });
    // Append acronym for names with 4+ words
    final words = name.split(' ');
    if (words.length >= 4) {
      final acronym = words.map((w) => w[0].toUpperCase()).join('');
      return '$name ($acronym)';
    }
    return name;
  }

  /// Builds a creature/situation name.
  /// e.g. "Yeti On a Budget", "Manticore With a Grievance"
  String _buildCreatureName() {
    final creature = _pickBank('Creature_Noun');
    final phrase   = _pickBank('Situation_Phrase');
    return '$creature $phrase';
  }

  String _pickBank(String token) {
    final list = _appData?.wordBank(token) ?? [];
    if (list.isEmpty) return '';
    return list[_random.nextInt(list.length)];
  }

  /// Exposes random index for external use (e.g. test screens picking patterns).
  int randomIndex(int max) => _random.nextInt(max);

  // ─── STAT HELPERS ────────────────────────────────────────────────────────

  double _rollCoreStat(int tier) {
    final min = (tier - 5).toDouble();
    final value = min + (_random.nextDouble() * 10.0) + (_random.nextDouble() * 0.99);
    return double.parse(value.toStringAsFixed(2));
  }

  double _rollGrowthStat() =>
      double.parse((1.0 + _random.nextDouble() * 99.0).toStringAsFixed(2));

  double _round(double v) => double.parse(v.toStringAsFixed(2));
}