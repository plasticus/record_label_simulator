import 'dart:math';
import 'asset_loader.dart';

// ─── SURNAME GENERATION CONSTANTS ────────────────────────────────────────────
// Adjust these to tune the mix of surname types in production.
// All four should add up to 100.

const int kSurnameDirectChance      = 25;  // Pull straight from Surname list
const int kSurnameHyphenRealChance  = 25;  // Hyphenate two real surnames
const int kSurnameAssembledChance   = 25;  // Build from prefix/root/suffix
const int kSurnameHyphenAsmChance   = 25;  // Hyphenate two assembled surnames

/// Max character length for a single assembled surname component (before hyphenation).
const int kAssembledMaxLength = 14;

/// Chance (0-100) that an assembled name includes a root between prefix and suffix.
const int kRootInclusionChance = 40;

// ─── SURNAME GENERATOR ───────────────────────────────────────────────────────

class SurnameGenerator {
  final Random _random = Random();
  final AppData _data;

  SurnameGenerator(this._data);

  bool _roll(int chance) => _random.nextInt(100) < chance;
  String _pick(List<String> list) => list[_random.nextInt(list.length)];

  /// Generate a surname using one of the four methods.
  /// Method is chosen randomly based on the constants above.
  String generate() {
    final roll = _random.nextInt(100);

    if (roll < kSurnameDirectChance) {
      return _direct();
    } else if (roll < kSurnameDirectChance + kSurnameHyphenRealChance) {
      return _hyphenatedReal();
    } else if (roll < kSurnameDirectChance + kSurnameHyphenRealChance + kSurnameAssembledChance) {
      return _assembled();
    } else {
      return _hyphenatedAssembled();
    }
  }

  /// Generate [count] surnames using a specific method.
  /// Useful for the test screen.
  List<String> generateByMethod(SurnameMethod method, int count) {
    final results = <String>[];
    int attempts = count * 30;
    while (results.length < count && attempts-- > 0) {
      final name = switch (method) {
        SurnameMethod.direct           => _direct(),
        SurnameMethod.hyphenatedReal   => _hyphenatedReal(),
        SurnameMethod.assembled        => _assembled(),
        SurnameMethod.hyphenatedAssembled => _hyphenatedAssembled(),
      };
      if (!results.contains(name)) results.add(name);
    }
    return results;
  }

  // ─── METHOD 1: DIRECT ──────────────────────────────────────────────────────

  String _direct() => _pick(_data.surnames);

  // ─── METHOD 2: HYPHENATED REAL ─────────────────────────────────────────────

  String _hyphenatedReal() {
    String a = _pick(_data.surnames);
    String b = _pick(_data.surnames);
    // Avoid same-name hyphenation
    int attempts = 10;
    while (b == a && attempts-- > 0) {
      b = _pick(_data.surnames);
    }
    return '$a-$b';
  }

  // ─── METHOD 3: ASSEMBLED ───────────────────────────────────────────────────

  String _assembled() {
    for (int attempt = 0; attempt < 20; attempt++) {
      final name = _buildAssembled();
      if (name != null) return name;
    }
    // Fallback to direct if assembled keeps failing length check
    return _direct();
  }

  String? _buildAssembled() {
    final prefix = _pick(_data.cPrefixes);
    final suffix = _pick(_data.cSuffixes);

    if (_roll(kRootInclusionChance)) {
      final root = _pick(_data.cRoots);
      final name = '$prefix$root$suffix';
      if (name.length <= kAssembledMaxLength) return name;
      return null; // Too long — retry
    } else {
      final name = '$prefix$suffix';
      if (name.length <= kAssembledMaxLength) return name;
      return null;
    }
  }

  // ─── METHOD 4: HYPHENATED ASSEMBLED ────────────────────────────────────────

  String _hyphenatedAssembled() {
    String? a, b;
    int attempts = 20;
    while (attempts-- > 0) {
      a ??= _buildAssembled();
      b ??= _buildAssembled();
      if (a != null && b != null && a != b) break;
      if (a == b) b = null; // Force a different second half
    }
    if (a == null || b == null) return _direct(); // Fallback
    return '$a-$b';
  }
}

// ─── SURNAME METHOD ENUM ─────────────────────────────────────────────────────

enum SurnameMethod {
  direct,
  hyphenatedReal,
  assembled,
  hyphenatedAssembled,
}

extension SurnameMethodLabel on SurnameMethod {
  String get label {
    switch (this) {
      case SurnameMethod.direct:              return 'Direct';
      case SurnameMethod.hyphenatedReal:      return 'Hyphenated Real';
      case SurnameMethod.assembled:           return 'Assembled';
      case SurnameMethod.hyphenatedAssembled: return 'Hyphenated Assembled';
    }
  }
}