// lib/models/band.dart
//
// Band-related models — extracted from band_generator.dart so the
// generation logic and the data models live separately.

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

// ─── BAND MEMBER ─────────────────────────────────────────────────────────────
// A band member has 5 core skills. Band-level stats are derived by averaging
// these across all members (see BandStats). No growth stats — kept simple.

class BandMember {
  String name;
  final int age;
  final Gender gender;
  String instrument;
  String? doubleInstrument;
  bool isLeadVocals;
  bool isBackingVocals;

  // ── 5 core member skills (0–100 soft cap, tier-gated at gen time) ──
  final double skill;         // → averages into Band.technicalSkill
  final double songwriting;   // → averages into Band.sonicIdentity
  final double starPower;     // → averages into Band.starPower
  final double temperament;   // → averages into Band.temperament
  final double cooperation;   // → averages into Band.chemistry

  BandMember({
    required this.name,
    required this.age,
    required this.gender,
    required this.instrument,
    this.doubleInstrument,
    this.isLeadVocals = false,
    this.isBackingVocals = false,
    required this.skill,
    required this.songwriting,
    required this.starPower,
    required this.temperament,
    required this.cooperation,
  });

  String get displayInstrument {
    final roles = <String>[instrument];
    if (instrument == 'Vocals' && doubleInstrument != null) roles.add(doubleInstrument!);
    if (isLeadVocals && instrument != 'Vocals') roles.add('Vocals');
    if (isBackingVocals) roles.add('Backing Vocals');
    return roles.join(' / ');
  }

  String get genderLabel => gender == Gender.male ? 'M' : 'F';
}

// ─── BAND STATS ──────────────────────────────────────────────────────────────
// These are the band's aggregate stats, derived by averaging member skills.
// They are the inputs to the Album Quality formula in the Vision Doc.

class BandStats {
  final double technicalSkill;  // avg of members' skill
  final double sonicIdentity;   // avg of members' songwriting
  final double starPower;       // avg of members' starPower
  final double temperament;     // avg of members' temperament
  final double chemistry;       // avg of members' cooperation

  double get overall =>
      (technicalSkill + sonicIdentity + starPower + temperament + chemistry) / 5.0;

  const BandStats({
    required this.technicalSkill,
    required this.sonicIdentity,
    required this.starPower,
    required this.temperament,
    required this.chemistry,
  });

  /// Derives band stats by averaging the matching skill across all members.
  factory BandStats.fromMembers(List<BandMember> members) {
    if (members.isEmpty) {
      return const BandStats(
        technicalSkill: 0, sonicIdentity: 0,
        starPower: 0, temperament: 0, chemistry: 0,
      );
    }
    double avg(double Function(BandMember) f) =>
        double.parse(
          (members.fold(0.0, (sum, m) => sum + f(m)) / members.length)
              .toStringAsFixed(2),
        );
    return BandStats(
      technicalSkill: avg((m) => m.skill),
      sonicIdentity:  avg((m) => m.songwriting),
      starPower:      avg((m) => m.starPower),
      temperament:    avg((m) => m.temperament),
      chemistry:      avg((m) => m.cooperation),
    );
  }
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

// ─── BAND ────────────────────────────────────────────────────────────────────

class Band {
  final String name;
  final List<BandMember> members;
  final BandStats stats;
  final BandTraits traits;

  const Band({
    required this.name,
    required this.members,
    required this.stats,
    required this.traits,
  });
}
