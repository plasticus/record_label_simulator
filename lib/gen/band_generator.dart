import 'dart:math';

/// Represents an individual musician in the generated band.
class BandMember {
  String name;
  String instrument;        // 'Vocals' for standalone singer, otherwise their physical instrument
  String? doubleInstrument; // Set if a likely_standalone vocalist also plays an instrument
  bool isLeadVocals;
  bool isBackingVocals;

  BandMember({
    required this.name,
    required this.instrument,
    this.doubleInstrument,
    this.isLeadVocals = false,
    this.isBackingVocals = false,
  });

  @override
  String toString() {
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
}

/// Holds the structural configurations for a genre.
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

/// The master control room for generating bands and managing genre configurations.
class BandGenerator {
  final Random _random = Random();

  final Map<String, GenreData> genres = {
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

  /// Generates a roster of musicians for a given genre.
  List<BandMember> generateBand(String genreName) {
    final genre = genres[genreName];
    if (genre == null) return [];

    // --- STEP 1: ROLL BAND SIZE ---
    int bandSize = genre.minMembers + _random.nextInt(genre.maxMembers - genre.minMembers + 1);

    List<BandMember> members = [];
    for (int i = 1; i <= bandSize; i++) {
      members.add(BandMember(name: 'Member $i', instrument: 'None'));
    }

    // --- STEP 2: LOAD & MODULATE REQUIRED INSTRUMENTS ---
    List<String> requiredPool = List.from(genre.minInstruments);

    // Hipster's guaranteed Backing Vocals slot is handled in Step 6b via the roll system.
    requiredPool.remove('Backing Vocals');

    // Klangor override: brass acts as the bass/rhythm section; always needs TWO brass minimum.
    if (genreName == 'Klangor') {
      requiredPool.remove('Brass');
      requiredPool.add('Brass');
      requiredPool.add('Brass');
    }

    // Pull Vocals out — vocalist gets their own reserved slot before anything else fills in.
    bool vocalsRequired = requiredPool.remove('Vocals');

    // Shuffle so required instruments don't always land on the same member slot.
    requiredPool.shuffle(_random);

    // --- STEP 3: RESERVE VOCALIST SLOT FIRST ---
    // The vocalist is always guaranteed slot 0. Doubling decision comes later in Step 6a.
    int memberIdx = 0;
    if (vocalsRequired && genre.vocalistType != 'none') {
      members[memberIdx].instrument = 'Vocals';
      members[memberIdx].isLeadVocals = true;
      memberIdx++;
    }

    // --- STEP 4: ASSIGN MANDATORY PHYSICAL INSTRUMENTS ---
    // Track anything dropped because the band is too small — vocalist doubles on it in Step 6a.
    List<String> droppedInstruments = [];
    for (String instrument in requiredPool) {
      if (memberIdx < members.length) {
        members[memberIdx].instrument = instrument;
        memberIdx++;
      } else {
        droppedInstruments.add(instrument);
      }
    }

    // --- STEP 5: WILDCARD ROLLS FOR EXTRA SLOTS ---
    while (memberIdx < members.length) {
      String wildcard = _selectWildcard(genre.otherInstruments, genreName, members);
      members[memberIdx].instrument = wildcard;
      memberIdx++;
    }

    // --- STEP 6a: APPLY VOCAL DOUBLING (likely_standalone only) ---
    // If required instruments were dropped due to band size, vocalist MUST double on one.
    // Otherwise, 30% random chance to pick up a second instrument.
    if (vocalsRequired && genre.vocalistType == 'likely_standalone') {
      if (droppedInstruments.isNotEmpty) {
        _addDoubleInstrumentToVocalist(genre, members, forced: droppedInstruments);
      } else if (_random.nextInt(100) < 30) {
        _addDoubleInstrumentToVocalist(genre, members);
      }
    }

    // --- STEP 6b: BACKING VOCALS ROLL ---
    const standaloneBackingGenres = {'Pop', 'Soul', 'Hipster'};

    for (var member in members) {
      if (member.isLeadVocals || member.instrument == 'Vocals') continue;
      if (member.instrument == 'Brass') continue;

      bool structureAllowsBackup = standaloneBackingGenres.contains(genreName)
          || (member.instrument != 'None');

      if (structureAllowsBackup && _random.nextInt(100) < genre.backingVocalChance) {
        member.isBackingVocals = true;
      }
    }

    // --- STEP 7: SORT — VOCALISTS BUBBLE TO THE TOP ---
    // Tier 0: pure standalone vocalist (Vocals only)
    // Tier 1: vocalist who doubles on an instrument (Vocals / Guitar etc.)
    // Tier 2: everyone else
    int vocalTier(BandMember m) {
      if (m.instrument == 'Vocals' && m.doubleInstrument == null) return 0;
      if (m.instrument == 'Vocals') return 1;
      return 2;
    }
    members.sort((a, b) => vocalTier(a).compareTo(vocalTier(b)));

    for (int i = 0; i < members.length; i++) {
      members[i].name = 'Member ${i + 1}';
    }

    return members;
  }

  /// Adds a second instrument to the vocalist using VocalDoubleWeights.
  /// [forced]: vocalist MUST take one of these (band too small to give it its own slot).
  /// Without forced, picks randomly via weighted roll.
  void _addDoubleInstrumentToVocalist(GenreData genre, List<BandMember> members,
      {List<String> forced = const []}) {
    final vocalist = members.where((m) => m.isLeadVocals).firstOrNull;
    if (vocalist == null) return;

    String chosenInstrument;

    if (forced.isNotEmpty) {
      final weightedDropped = forced
          .where((i) => genre.vocalDoubleWeights.containsKey(i))
          .toList()
        ..sort((a, b) => (genre.vocalDoubleWeights[b] ?? 0)
            .compareTo(genre.vocalDoubleWeights[a] ?? 0));
      chosenInstrument = weightedDropped.isNotEmpty ? weightedDropped.first : forced.first;
    } else {
      if (genre.vocalDoubleWeights.isEmpty) return;

      int totalWeight = genre.vocalDoubleWeights.values.fold(0, (a, b) => a + b);
      int roll = _random.nextInt(totalWeight);
      int cumulative = 0;
      chosenInstrument = genre.vocalDoubleWeights.keys.first;

      for (var entry in genre.vocalDoubleWeights.entries) {
        cumulative += entry.value;
        if (roll < cumulative) {
          chosenInstrument = entry.key;
          break;
        }
      }
    }

    vocalist.doubleInstrument = chosenInstrument;
  }

  /// Wildcard selection keeping duplicates and uniqueness rules in check.
  String _selectWildcard(List<String> choices, String genreName, List<BandMember> activeLineup) {
    const uniqueInstruments = {'Drums', 'Bass', 'Piano', 'Keyboard', 'DJ', 'Synth'};

    List<String> shuffledChoices = List.from(choices)..shuffle(_random);

    for (String option in shuffledChoices) {
      if (uniqueInstruments.contains(option)) {
        bool duplicateFound = activeLineup.any((m) => m.instrument == option);
        if (duplicateFound && !(genreName == 'Klangor' && option == 'Bass')) {
          continue;
        }
      }
      return option;
    }

    return choices[_random.nextInt(choices.length)];
  }
}