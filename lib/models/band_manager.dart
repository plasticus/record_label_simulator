// lib/models/band_manager.dart

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'band.dart';
import 'agent.dart'; // AgentSkills lives here now

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
// JSON parsers
// ---------------------------------------------------------------------------

/// Maps a JSON string to [ManagerPersonality].
/// Falls back to [ManagerPersonality.steadfast] for any unrecognised value
/// so a typo in the data file doesn't crash the app.
ManagerPersonality _personalityFromString(String value) {
  switch (value) {
    case 'lazy':             return ManagerPersonality.lazy;
    case 'confrontational':  return ManagerPersonality.confrontational;
    case 'yesMan':           return ManagerPersonality.yesMan;
    case 'cutthroat':        return ManagerPersonality.cutthroat;
    case 'passionate':       return ManagerPersonality.passionate;
    case 'steadfast':        return ManagerPersonality.steadfast;
    case 'trendjacker':      return ManagerPersonality.trendjacker;
    case 'nurturing':        return ManagerPersonality.nurturing;
    default:                 return ManagerPersonality.steadfast;
  }
}

/// Maps a JSON string to a [ManagerTrait], or `null` if unrecognised.
/// Callers filter out nulls so bad data is silently skipped.
ManagerTrait? _traitFromString(String value) {
  switch (value) {
    case 'battleHardened':       return ManagerTrait.battleHardened;
    case 'dealmaker':            return ManagerTrait.dealmaker;
    case 'talentWhisperer':      return ManagerTrait.talentWhisperer;
    case 'bandLoyal':            return ManagerTrait.bandLoyal;
    case 'selfStarter':          return ManagerTrait.selfStarter;
    case 'unreliable':           return ManagerTrait.unreliable;
    case 'inflatedExpectations': return ManagerTrait.inflatedExpectations;
    case 'fragileEgo':           return ManagerTrait.fragileEgo;
    case 'abrasive':             return ManagerTrait.abrasive;
    case 'toxicReputation':      return ManagerTrait.toxicReputation;
    default:                     return null;
  }
}

// ---------------------------------------------------------------------------
// BandManager
// ---------------------------------------------------------------------------

class BandManager extends Agent<ManagerPersonality, ManagerTrait> {
  // ── Roster ─────────────────────────────────────────────────────────────────

  /// Bands currently under this manager's care. Mutable during a playthrough;
  /// exposed as an unmodifiable view to prevent accidental direct mutation.
  final List<Band> _assignedBands;
  List<Band> get assignedBands => List.unmodifiable(_assignedBands);

  // ── Constructor ────────────────────────────────────────────────────────────

  BandManager({
    required super.name,
    required super.salary,
    required double morale,
    required super.skills,
    required super.personality,
    required super.bio,
    List<ManagerTrait> traits = const [],
    List<Band> assignedBands = const [],
  })  : _assignedBands = List<Band>.from(assignedBands),
        super(
        morale: morale.clamp(0.0, 100.0),
        traits: List.unmodifiable(traits),
      );

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

  @override
  BandManager copyWith({
    String? name,
    double? salary,
    double? morale,
    AgentSkills? skills,
    ManagerPersonality? personality,
    List<ManagerTrait>? traits,
    String? bio,
    // BandManager-specific
    List<Band>? assignedBands,
  }) {
    return BandManager(
      name:          name          ?? this.name,
      salary:        salary        ?? this.salary,
      morale:        morale        ?? this.morale,
      skills:        skills        ?? this.skills,
      personality:   personality   ?? this.personality,
      traits:        traits        ?? this.traits,
      bio:           bio           ?? this.bio,
      assignedBands: assignedBands ?? _assignedBands,
    );
  }

  // ── Convenience getters ────────────────────────────────────────────────────

  // isUnderPerforming and isBurningOut are inherited from Agent.

  int get rosterSize => _assignedBands.length;

  // ── fromJson ───────────────────────────────────────────────────────────────

  factory BandManager.fromJson(Map<String, dynamic> json) {
    final rawTraits = (json['traits'] as List<dynamic>? ?? [])
        .cast<String>()
        .map(_traitFromString)
        .whereType<ManagerTrait>() // silently drops any null (unrecognised) values
        .toList();

    return BandManager(
      name:          json['name']        as String,
      salary:        (json['salary']     as num).toDouble(),
      morale:        (json['morale']     as num).toDouble(),
      personality:   _personalityFromString(json['personality'] as String),
      traits:        rawTraits,
      assignedBands: const [],           // populated at runtime, not from JSON
      skills:        AgentSkills.fromJson(json['skills'] as Map<String, dynamic>),
      bio:           json['bio']         as String? ?? '',
    );
  }

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

// ---------------------------------------------------------------------------
// Asset loader
// ---------------------------------------------------------------------------

/// Reads `assets/data/band_managers.json` and returns a typed list.
/// Call once at startup (e.g. in your AgentGallery initState) and cache
/// the result — don't call on every build.
Future<List<BandManager>> loadBandManagers() async {
  final raw  = await rootBundle.loadString('assets/data/band_managers.json');
  final list = json.decode(raw) as List<dynamic>;
  return list
      .cast<Map<String, dynamic>>()
      .map(BandManager.fromJson)
      .toList();
}
