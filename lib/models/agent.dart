// lib/models/agent.dart

// ---------------------------------------------------------------------------
// AgentSkills
// ---------------------------------------------------------------------------

/// The six core competency scores shared by every agent type.
/// All values are in the range 0–100.
///
/// Moved here from band_manager.dart so that future agent classes
/// (A&R, Creative Director, etc.) can reference it without a circular import.
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
      acumen:    c(acumen),
      insight:   c(insight),
      resolve:   c(resolve),
      presence:  c(presence),
      execution: c(execution),
      network:   c(network),
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
      acumen:    acumen    ?? this.acumen,
      insight:   insight   ?? this.insight,
      resolve:   resolve   ?? this.resolve,
      presence:  presence  ?? this.presence,
      execution: execution ?? this.execution,
      network:   network   ?? this.network,
    );
  }

  /// Rough overall rating; useful for UI sorting and difficulty scaling.
  double get overallRating =>
      (acumen + insight + resolve + presence + execution + network) / 6.0;

  factory AgentSkills.fromJson(Map<String, dynamic> json) {
    return AgentSkills(
      acumen:    (json['acumen']    as num).toDouble(),
      insight:   (json['insight']   as num).toDouble(),
      resolve:   (json['resolve']   as num).toDouble(),
      presence:  (json['presence']  as num).toDouble(),
      execution: (json['execution'] as num).toDouble(),
      network:   (json['network']   as num).toDouble(),
    );
  }

  @override
  String toString() =>
      'AgentSkills(acumen: $acumen, insight: $insight, resolve: $resolve, '
          'presence: $presence, execution: $execution, network: $network)';
}

// ---------------------------------------------------------------------------
// Agent<P, T>
// ---------------------------------------------------------------------------

/// Abstract base class for every agent in the Rogue's Gallery.
///
/// Type parameters let each subclass lock in its own enum types while still
/// sharing this base:
///   [P] — the personality enum for this agent type (e.g. [ManagerPersonality])
///   [T] — the trait enum for this agent type    (e.g. [ManagerTrait])
///
/// Example subclass declaration:
///   class BandManager extends Agent(ManagerPersonality, ManagerTrait) { … }
abstract class Agent<P, T> {
  // ── Identity ───────────────────────────────────────────────────────────────

  final String name;

  // ── Financials ─────────────────────────────────────────────────────────────

  /// Monthly salary cost to the label, in the game's currency unit.
  final double salary;

  // ── Wellbeing ──────────────────────────────────────────────────────────────

  /// Current mood / morale. Range 0–100.
  /// Low morale triggers confrontational mini-games and skill debuffs.
  final double morale;

  // ── Competency ─────────────────────────────────────────────────────────────

  final AgentSkills skills;

  // ── Character ──────────────────────────────────────────────────────────────

  /// Personality archetype that colours every interaction mini-game.
  /// Typed as [P] so each subclass can use its own personality enum.
  final P personality;

  /// Traits accumulated through gameplay events.
  /// Typed as [T] so each subclass can use its own trait enum.
  final List<T> traits;

  // ── Flavour ────────────────────────────────────────────────────────────────

  /// Flavour text shown on the agent detail screen.
  final String bio;

  // ── Constructor ────────────────────────────────────────────────────────────

  const Agent({
    required this.name,
    required this.salary,
    required this.morale,
    required this.skills,
    required this.personality,
    required this.traits,
    required this.bio,
  });

  // ── Shared convenience getters ─────────────────────────────────────────────

  /// True when overall skill rating is critically low.
  /// Triggers a warning badge on the Rogue's Gallery overview card.
  bool get isUnderPerforming => skills.overallRating < 40.0;

  /// True when morale has dropped to a crisis level.
  /// At this threshold the agent is at risk of quitting or causing drama.
  bool get isBurningOut => morale < 25.0;

  // ── copyWith (abstract) ───────────────────────────────────────────────────

  /// Each subclass must implement its own [copyWith] that returns the
  /// concrete subtype. Declared here as a reminder and to establish the
  /// contract; the base class cannot provide a concrete implementation
  /// because it doesn't know which extra fields the subclass carries.
  Agent<P, T> copyWith({
    String? name,
    double? salary,
    double? morale,
    AgentSkills? skills,
    P? personality,
    List<T>? traits,
    String? bio,
  });
}