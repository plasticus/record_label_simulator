// lib/models/band_manager.dart

import '../generators/band_generator.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Personality archetype that colours every interaction mini-game with this
/// agent. Values are intentionally broad so gameplay writers can layer
/// specific dialogue on top.
enum ManagerPersonality {
  /// Does the bare minimum; needs prodding to hit deadlines.
  lazy,

  /// Pushes back on instructions and escalates friction in mini-games.
  confrontational,

  /// Agrees with everything; rarely flags problems until it's too late.
  yesMan,

  /// Thinks in spreadsheets; great strategist, terrible bedside manner.
  cutthroat,

  /// Builds loyalty fast; burns bright but cracks under sustained pressure.
  passionate,

  /// Well-rounded, predictable, rarely surprising in any direction.
  steadfast,

  /// Chases trends instead of building long-term artist identity.
  trendjacker,

  /// Deeply invested in their artists; sometimes loses business objectivity.
  nurturing,
}

/// Positive or negative trait earned (or suffered) over the course of a
/// playthrough. Stored as a value object; effects are resolved by game logic.
enum ManagerTrait {
  // --- Positive ---
  /// Has made it through at least one disastrous tour without quitting.
  battleHardened,

  /// Negotiated an especially lucrative deal in the past.
  dealmaker,

  /// Discovered at least one breakout act that went platinum.
  talentWhisperer,

  /// Maintains strong bonds with their current roster.
  bandLoyal,

  /// Rarely needs overtime pay; self-managing under pressure.
  selfStarter,

  // --- Negative ---
  /// Missed a critical deadline at least once, now watched closely.
  unreliable,

  /// Tends to over-promise and under-deliver on new signings.
  inflatedExpectations,

  /// Loses morale faster than peers when albums under-perform.
  fragileEgo,

  /// Has a history of clashing with Legal or Production staff.
  abrasive,

  /// Burned bridges with at least one former artist; word gets around.
  toxicReputation,
}

// ---------------------------------------------------------------------------
// AgentSkills — shared stat block, reusable by other agent types later
// ---------------------------------------------------------------------------

/// The six core competency scores that drive agent effectiveness.
/// All values are in the range 0–100.
class AgentSkills {
  /// Corporate and financial navigation.
  final double acumen;

  /// Spotting raw talent and reading creative trends.
  final double insight;

  /// Mental stamina; resistance to burnout and in-game crises.
  final double resolve;

  /// Charisma, clout, and persuasive power.
  final double presence;

  /// Technical ability to deliver polished, high-quality output.
  final double execution;

  /// Depth of industry contacts and connections.
  final double network;

  const AgentSkills({
    required this.acumen,
    required this.insight,
    required this.resolve,
    required this.presence,
    required this.execution,
    required this.network,
  });

  /// Clamps every skill to [0, 100] on construction — safety net for
  /// generators that add/subtract deltas without bounds-checking.
  factory AgentSkills.clamped({
    required double acumen,
    required double insight,
    required double resolve,
    required double presence,
    required double execution,
    required double network,
  }) {
    double c(double v) => v.clamp(0.0, 100.0);
    return AgentSkills(
      acumen: c(acumen),
      insight: c(insight),
      resolve: c(resolve),
      presence: c(presence),
      execution: c(execution),
      network: c(network),
    );
  }

  /// Returns a copy with any number of fields overridden.
  AgentSkills copyWith({
    double? acumen,
    double? insight,
    double? resolve,
    double? presence,
    double? execution,
    double? network,
  }) {
    return AgentSkills(
      acumen: acumen ?? this.acumen,
      insight: insight ?? this.insight,
      resolve: resolve ?? this.resolve,
      presence: presence ?? this.presence,
      execution: execution ?? this.execution,
      network: network ?? this.network,
    );
  }

  /// Rough overall rating; useful for UI sorting and difficulty scaling.
  double get overallRating =>
      (acumen + insight + resolve + presence + execution + network) / 6.0;

  @override
  String toString() =>
      'AgentSkills(acumen: $acumen, insight: $insight, resolve: $resolve, '
          'presence: $presence, execution: $execution, network: $network)';
}

// ---------------------------------------------------------------------------
// BandManager
// ---------------------------------------------------------------------------

class BandManager {
  // ── Identity ───────────────────────────────────────────────────────────────

  final String name;

  // ── Financials ─────────────────────────────────────────────────────────────

  /// Monthly salary cost to the label, in whatever in-game currency unit is
  /// settled on later. Stored as a double to match other currency fields.
  final double salary;

  // ── Wellbeing ──────────────────────────────────────────────────────────────

  /// Current mood / morale. Range 0–100.
  /// Low morale triggers confrontational mini-games and skill debuffs.
  final double morale;

  // ── Competency ─────────────────────────────────────────────────────────────

  final AgentSkills skills;

  // ── Character ──────────────────────────────────────────────────────────────

  final ManagerPersonality personality;

  /// Traits accumulated (positively or negatively) through gameplay events.
  final List<ManagerTrait> traits;

  // ── Roster ─────────────────────────────────────────────────────────────────

  /// Bands currently under this manager's care. Mutable during a playthrough;
  /// exposed as an unmodifiable view to prevent accidental direct mutation.
  final List<Band> _assignedBands;
  List<Band> get assignedBands => List.unmodifiable(_assignedBands);

  // ── Constructor ────────────────────────────────────────────────────────────

  BandManager({
    required this.name,
    required this.salary,
    required double morale,
    required this.skills,
    required this.personality,
    List<ManagerTrait> traits = const [],
    List<Band> assignedBands = const [],
  })  : morale = morale.clamp(0.0, 100.0),
        traits = List.unmodifiable(traits),
        _assignedBands = List<Band>.from(assignedBands);

  // ── Roster helpers ─────────────────────────────────────────────────────────

  void assignBand(Band band) {
    if (!_assignedBands.contains(band)) {
      _assignedBands.add(band);
    }
  }

  void removeBand(Band band) {
    _assignedBands.remove(band);
  }

  bool manages(Band band) => _assignedBands.contains(band);

  // ── Trait helpers ──────────────────────────────────────────────────────────

  bool hasTrait(ManagerTrait trait) => traits.contains(trait);

  BandManager withTrait(ManagerTrait trait) {
    if (hasTrait(trait)) return this;
    return copyWith(traits: [...traits, trait]);
  }

  BandManager withoutTrait(ManagerTrait trait) {
    return copyWith(traits: traits.where((t) => t != trait).toList());
  }

  // ── copyWith ───────────────────────────────────────────────────────────────

  BandManager copyWith({
    String? name,
    double? salary,
    double? morale,
    AgentSkills? skills,
    ManagerPersonality? personality,
    List<ManagerTrait>? traits,
    List<Band>? assignedBands,
  }) {
    return BandManager(
      name: name ?? this.name,
      salary: salary ?? this.salary,
      morale: morale ?? this.morale,
      skills: skills ?? this.skills,
      personality: personality ?? this.personality,
      traits: traits ?? this.traits,
      assignedBands: assignedBands ?? _assignedBands,
    );
  }

  // ── Convenience getters ────────────────────────────────────────────────────

  /// Shorthand for the Rogue's Gallery overview card.
  bool get isUnderPerforming => skills.overallRating < 40.0;
  bool get isBurningOut => morale < 25.0;
  int get rosterSize => _assignedBands.length;

  // ── Debug ──────────────────────────────────────────────────────────────────

  @override
  String toString() =>
      'BandManager('
          'name: $name, '
          'salary: $salary, '
          'morale: $morale, '
          'personality: ${personality.name}, '
          'traits: ${traits.map((t) => t.name).toList()}, '
          'bands: ${_assignedBands.map((b) => b.name).toList()}, '
          'skills: $skills'
          ')';
}