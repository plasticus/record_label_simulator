import 'dart:math';
import '../data/patterns.dart';
import '../data/asset_loader.dart';
import '../data/name_generation/gen_human_names.dart';
import '../models/band.dart';

// ─── CONSTANTS ───────────────────────────────────────────────────────────────

const int kGimmickChance = 5;

const List<String> creaturePrepositions = [
  'On', 'With', 'Without', 'Against', 'Beyond',
  'Before', 'After', 'Under', 'Over', 'Through',
  'During', 'Across', 'Within', 'Amid',
];

const int kFanClubMin   = 50;
const int kFanClubMax   = 500;
const int kMemberAgeMin = 18;
const int kMemberAgeMax = 35;

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

// ─── BAND GENERATOR ──────────────────────────────────────────────────────────

class BandGenerator {
  final Random _random = Random();
  AppData? _appData;
  NameGenerator? _nameGenerator;

  /// Call once at app startup before generating bands.
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
      description: 'Classic amplified energy fueled by driving drum beats, heavy bass lines, and raw electric guitar riffs.',
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
      minMembers: 3, maxMembers: 7,
      minInstruments: ['Drums', 'Bass'],
      otherInstruments: ['Trumpet', 'Saxophone', 'Piano', 'Guitar', 'Brass', 'Vocals', 'Percussion'],
      backingVocalChance: 5,
      vocalistType: 'optional',
      vocalDoubleWeights: {},
    ),
    'Glitch-Hop': GenreData(
      name: 'Glitch-Hop',
      description: 'A chaotic fusion of glitchy electronic textures, hip-hop beats, and fragmented digital audio manipulation.',
      minMembers: 1, maxMembers: 4,
      minInstruments: ['Vocals'],
      otherInstruments: ['Synth', 'DJ', 'Drums', 'Vocals'],
      backingVocalChance: 10,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'DJ': 60, 'Synth': 40},
    ),
    'Rust Beat': GenreData(
      name: 'Rust Beat',
      description: 'Industrial percussion and analogue warmth collide — think factory floors and tape hiss layered over booming 808s.',
      minMembers: 1, maxMembers: 3,
      minInstruments: ['Drums'],
      otherInstruments: ['Synth', 'Bass', 'Vocals', 'DJ'],
      backingVocalChance: 10,
      vocalistType: 'optional',
      vocalDoubleWeights: {},
    ),
    'Klangor': GenreData(
      name: 'Klangor',
      description: 'Abrasive, maximalist brass-driven noise-rock. If it doesn\'t hurt a little, it\'s not Klangor.',
      minMembers: 3, maxMembers: 6,
      minInstruments: ['Drums', 'Bass', 'Brass'],
      otherInstruments: ['Brass', 'Guitar', 'Vocals', 'Percussion'],
      backingVocalChance: 5,
      vocalistType: 'optional',
      vocalDoubleWeights: {},
    ),
    'Vandalo': GenreData(
      name: 'Vandalo',
      description: 'Street-art energy translated into sound — aggressive, rhythmic, and spray-painted in neon.',
      minMembers: 2, maxMembers: 5,
      minInstruments: ['Vocals', 'Drums'],
      otherInstruments: ['Guitar', 'Bass', 'Synth', 'DJ'],
      backingVocalChance: 15,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 50, 'DJ': 50},
    ),
    'Gakkion': GenreData(
      name: 'Gakkion',
      description: 'A Japanese-influenced fusion of traditional instrumentation with hyperpop production. Chaotic, precise, and extremely online.',
      minMembers: 2, maxMembers: 5,
      minInstruments: ['Vocals'],
      otherInstruments: ['Synth', 'Keyboard', 'Percussion', 'Vocals'],
      backingVocalChance: 30,
      vocalistType: 'standalone',
      vocalDoubleWeights: {'Keyboard': 60, 'Synth': 40},
    ),
    'Bruitogaze': GenreData(
      name: 'Bruitogaze',
      description: 'Walls of guitar noise and dreamy, indecipherable vocals — shoegaze pushed past its breaking point.',
      minMembers: 3, maxMembers: 5,
      minInstruments: ['Vocals', 'Guitar', 'Drums'],
      otherInstruments: ['Guitar', 'Bass', 'Keyboard'],
      backingVocalChance: 20,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 70, 'Bass': 30},
    ),
    'Indie': GenreData(
      name: 'Indie',
      description: 'Lo-fi heart, hi-fi ambition. Introspective lyrics, jangly guitars, and a studied disregard for mainstream polish.',
      minMembers: 2, maxMembers: 5,
      minInstruments: ['Vocals', 'Guitar'],
      otherInstruments: ['Bass', 'Drums', 'Keyboard', 'Guitar'],
      backingVocalChance: 20,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 60, 'Bass': 25, 'Keyboard': 15},
    ),
    'Hipster': GenreData(
      name: 'Hipster',
      description: 'You probably haven\'t heard of them. Obscure references, vintage gear, and an experimental bent that alienates as many fans as it earns.',
      minMembers: 2, maxMembers: 6,
      minInstruments: ['Vocals'],
      otherInstruments: ['Keyboard', 'Bass', 'Drums', 'Guitar', 'Synth', 'Vocals', 'Percussion'],
      backingVocalChance: 35,
      vocalistType: 'standalone',
      vocalDoubleWeights: {'Keyboard': 50, 'Guitar': 30, 'Synth': 20},
    ),
    'Doom': GenreData(
      name: 'Doom',
      description: 'Slow, crushing riffs and funeral tempos. Every note feels like a geological event.',
      minMembers: 3, maxMembers: 5,
      minInstruments: ['Vocals', 'Guitar', 'Bass', 'Drums'],
      otherInstruments: ['Guitar', 'Keyboard'],
      backingVocalChance: 5,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 60, 'Bass': 40},
    ),
    'Punk': GenreData(
      name: 'Punk',
      description: 'Fast, loud, three chords, and a grievance. No solos. No nonsense. No apologies.',
      minMembers: 3, maxMembers: 4,
      minInstruments: ['Vocals', 'Guitar', 'Bass', 'Drums'],
      otherInstruments: ['Guitar'],
      backingVocalChance: 25,
      vocalistType: 'likely_standalone',
      vocalDoubleWeights: {'Guitar': 70, 'Bass': 30},
    ),
    'AuraCore': GenreData(
      name: 'AuraCore',
      description: 'Ambient textures, spiritual subject matter, and production that sounds like it was recorded inside a cloud. Extremely niche. Extremely sincere.',
      minMembers: 1, maxMembers: 4,
      minInstruments: ['Vocals'],
      otherInstruments: ['Synth', 'Keyboard', 'Percussion', 'Vocals'],
      backingVocalChance: 40,
      vocalistType: 'standalone',
      vocalDoubleWeights: {'Synth': 60, 'Keyboard': 40},
    ),
  };

  // ─── PUBLIC API ──────────────────────────────────────────────────────────

  Band generate({String? forcedGenre, int? qualityTier}) {
    final genreName = forcedGenre ?? genres[_random.nextInt(genres.length)];
    final genre = genreData[genreName]!;
    final tier = qualityTier ?? (10 + _random.nextInt(9) * 10);

    final members = _buildMembers(genre, genreName, tier);
    final stats   = BandStats.fromMembers(members);
    final traits  = _buildTraits(genreName);
    final name    = _generateBandName();

    return Band(name: name, members: members, stats: stats, traits: traits);
  }

  // ─── MEMBER GENERATION ───────────────────────────────────────────────────

  List<BandMember> _buildMembers(GenreData genre, String genreName, int tier) {
    final bandSize = genre.minMembers +
        _random.nextInt(genre.maxMembers - genre.minMembers + 1);

    List<BandMember> members = List.generate(bandSize, (_) => _blankMember(tier));

    List<String> requiredPool = List.from(genre.minInstruments);
    requiredPool.remove('Backing Vocals');

    if (genreName == 'Klangor') {
      requiredPool.remove('Brass');
      requiredPool.add('Brass');
      requiredPool.add('Brass');
    }

    bool vocalsRequired = requiredPool.remove('Vocals');
    requiredPool.shuffle(_random);

    int memberIdx = 0;

    if (vocalsRequired && genre.vocalistType != 'none') {
      members[memberIdx].instrument = 'Vocals';
      members[memberIdx].isLeadVocals = true;
      memberIdx++;
    }

    List<String> droppedInstruments = [];
    for (String instrument in requiredPool) {
      if (memberIdx < members.length) {
        members[memberIdx].instrument = instrument;
        memberIdx++;
      } else {
        droppedInstruments.add(instrument);
      }
    }

    while (memberIdx < members.length) {
      members[memberIdx].instrument =
          _selectWildcard(genre.otherInstruments, genreName, members);
      memberIdx++;
    }

    if (vocalsRequired && genre.vocalistType == 'likely_standalone') {
      if (droppedInstruments.isNotEmpty) {
        _addDoubleInstrument(genre, members, forced: droppedInstruments);
      } else if (_random.nextInt(100) < 30) {
        _addDoubleInstrument(genre, members);
      }
    }

    const standaloneBackingGenres = {'Pop', 'Soul', 'Hipster'};
    for (var member in members) {
      if (member.isLeadVocals || member.instrument == 'Vocals') continue;
      if (member.instrument == 'Brass') continue;
      bool allowed = standaloneBackingGenres.contains(genreName) ||
          member.instrument != 'None';
      if (allowed && _random.nextInt(100) < genre.backingVocalChance) {
        member.isBackingVocals = true;
      }
    }

    int vocalTier(BandMember m) {
      if (m.instrument == 'Vocals' && m.doubleInstrument == null) return 0;
      if (m.instrument == 'Vocals') return 1;
      return 2;
    }
    members.sort((a, b) => vocalTier(a).compareTo(vocalTier(b)));

    return members;
  }

  BandMember _blankMember(int tier) {
    final gender = _random.nextBool() ? Gender.male : Gender.female;
    final age = kMemberAgeMin + _random.nextInt(kMemberAgeMax - kMemberAgeMin + 1);
    return BandMember(
      name:         _generateMemberName(gender),
      age:          age,
      gender:       gender,
      instrument:   'None',
      skill:        _rollStat(tier),
      songwriting:  _rollStat(tier),
      starPower:    _rollStat(tier),
      temperament:  _rollStat(tier),
      cooperation:  _rollStat(tier),
    );
  }

  String _generateMemberName(Gender gender) {
    if (_nameGenerator == null) return gender == Gender.male ? 'Male Member' : 'Female Member';
    final result = _nameGenerator!.generate(isMale: gender == Gender.male);
    return result.name;
  }

  void _addDoubleInstrument(GenreData genre, List<BandMember> members,
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
      int roll  = _random.nextInt(total);
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
      List<BandMember> lineup) {
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

  // ─── TRAITS ──────────────────────────────────────────────────────────────

  BandTraits _buildTraits(String genreName) {
    final gimmick = _random.nextInt(100) < kGimmickChance
        ? GimmickType.values[_random.nextInt(GimmickType.values.length)]
        : null;
    return BandTraits(
      happiness: 100.00,
      genre:     genreName,
      gimmick:   gimmick,
      fanClub:   kFanClubMin + _random.nextInt(kFanClubMax - kFanClubMin + 1),
    );
  }

  // ─── BAND NAME ───────────────────────────────────────────────────────────

  String _generateBandName() =>
      generateBandNameFromPattern(bandPatterns[_random.nextInt(bandPatterns.length)]);

  /// Public so dev tool screens can call it with a specific pattern.
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
    if (pattern.contains('[Creature_Noun]') && pattern.contains('[Situation_Noun]')) {
      return _buildCreatureName();
    }

    final name = pattern.replaceAllMapped(RegExp(r'\[([^\]]+)\]'), (m) {
      final token = m.group(1)!;
      final list  = _appData?.wordBank(token) ?? [];
      return list.isNotEmpty ? list[_random.nextInt(list.length)] : m.group(0)!;
    });

    final words = name.split(' ');
    if (words.length >= 4) {
      final acronym = words.map((w) => w[0].toUpperCase()).join('');
      return '$name ($acronym)';
    }
    return name;
  }

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

  int randomIndex(int max) => _random.nextInt(max);

  // ─── STAT HELPERS ────────────────────────────────────────────────────────

  double _rollStat(int tier) {
    final min   = (tier - 5).toDouble();
    final value = min + (_random.nextDouble() * 10.0) + (_random.nextDouble() * 0.99);
    return double.parse(value.toStringAsFixed(2));
  }
}
