import 'dart:math';
import 'package:flutter/services.dart';

// ─── NAME GENERATION CONSTANTS ───────────────────────────────────────────────
// Adjust these percentages freely — all are out of 100 unless noted.

const int kMiddleInitialChance  = 10;   // % chance of a middle initial
const int kSecondMiddleChance   = 10;   // % chance of 2nd middle initial (James S. A. Corey)
const int kStupidNameChance     = 1;    // % chance first name is replaced by stupid name
const int kSuffixChance         = 10;   // % chance of suffix (Jr., Sr., II, III)
const int kInitialFirstChance   = 1;    // % chance of "P. Tommy Wahls" style
const int kAllInitialsChance    = 1;    // % chance of "L. R. Bubbard" style (excl. stupid)

// ─── NAME DATA ───────────────────────────────────────────────────────────────

class NameData {
  final List<String> maleFirst;
  final List<String> femaleFirst;
  final List<String> middleInitials;
  final List<String> surnames;
  final List<String> suffixes;
  final List<String> stupidMale;
  final List<String> stupidFemale;

  const NameData({
    required this.maleFirst,
    required this.femaleFirst,
    required this.middleInitials,
    required this.surnames,
    required this.suffixes,
    required this.stupidMale,
    required this.stupidFemale,
  });
}

// ─── LOADER ──────────────────────────────────────────────────────────────────

class NameLoader {
  static NameData? _cache;

  /// Call once at app startup. Returns cached data on subsequent calls.
  static Future<NameData> load() async {
    if (_cache != null) return _cache!;

    final raw = await rootBundle.loadString('assets/data/human_name_gen_data.csv');
    final lines = raw.trim().split('\n');

    // Parse header
    final headers = lines.first.split(',').map((h) => h.trim()).toList();
    final mFirstIdx   = headers.indexOf('MFirst');
    final fFirstIdx   = headers.indexOf('FFirst');
    final middleIdx   = headers.indexOf('Middle');
    final surnameIdx  = headers.indexOf('Surname');
    final suffixIdx   = headers.indexOf('Suffix');
    final stupidMIdx  = headers.indexOf('StupidM');
    final stupidFIdx  = headers.indexOf('StupidF');

    final maleFirst     = <String>[];
    final femaleFirst   = <String>[];
    final middleInitials = <String>[];
    final surnames      = <String>[];
    final suffixes      = <String>[];
    final stupidMale    = <String>[];
    final stupidFemale  = <String>[];

    for (final line in lines.skip(1)) {
      if (line.trim().isEmpty) continue;
      final cols = line.split(',').map((c) => c.trim()).toList();

      void addIfPresent(int idx, List<String> list) {
        if (idx >= 0 && idx < cols.length) {
          final val = cols[idx];
          if (val.isNotEmpty && val != 'nan' && val != 'NaN') list.add(val);
        }
      }

      addIfPresent(mFirstIdx,  maleFirst);
      addIfPresent(fFirstIdx,  femaleFirst);
      addIfPresent(middleIdx,  middleInitials);
      addIfPresent(surnameIdx, surnames);
      addIfPresent(suffixIdx,  suffixes);
      addIfPresent(stupidMIdx, stupidMale);
      addIfPresent(stupidFIdx, stupidFemale);
    }

    _cache = NameData(
      maleFirst:      maleFirst,
      femaleFirst:    femaleFirst,
      middleInitials: middleInitials,
      surnames:       surnames,
      suffixes:       suffixes,
      stupidMale:     stupidMale,
      stupidFemale:   stupidFemale,
    );

    return _cache!;
  }
}

// ─── NAME GENERATOR ──────────────────────────────────────────────────────────

class NameGenerator {
  final Random _random = Random();
  final NameData _data;

  NameGenerator(this._data);

  bool _roll(int chance) => _random.nextInt(100) < chance;
  String _pick(List<String> list) => list[_random.nextInt(list.length)];

  /// Generates a full human name with all the weird rules applied.
  /// Returns the name string and whether a stupid name was rolled
  /// (so callers can apply the Hambone bonus if needed).
  ({String name, bool isStupid}) generate({required bool isMale}) {
    final firstNames  = isMale ? _data.maleFirst  : _data.femaleFirst;
    final stupidNames = isMale ? _data.stupidMale : _data.stupidFemale;
    final surname     = _pick(_data.surnames);

    bool isStupid = false;

    // --- STEP 1: ROLL STUPID NAME ---
    // If stupid, first name is replaced. All-initials cannot override this.
    if (_roll(kStupidNameChance)) {
      isStupid = true;
      final stupid = _pick(stupidNames);
      final middle  = _buildMiddle();
      final suffix  = _roll(kSuffixChance) ? ' ${_pick(_data.suffixes)}' : '';
      return (name: '$stupid$middle $surname$suffix', isStupid: true);
    }

    // --- STEP 2: ROLL ALL INITIALS (L. R. Bubbard) ---
    if (_roll(kAllInitialsChance)) {
      final i1 = _pick(_data.middleInitials);
      final i2 = _pick(_data.middleInitials);
      final suffix = _roll(kSuffixChance) ? ' ${_pick(_data.suffixes)}' : '';
      return (name: '$i1. $i2. $surname$suffix', isStupid: false);
    }

    // --- STEP 3: ROLL INITIAL-FIRST (P. Tommy Wahls) ---
    if (_roll(kInitialFirstChance)) {
      final initial   = _pick(_data.middleInitials);
      final realFirst = _pick(firstNames);
      final suffix    = _roll(kSuffixChance) ? ' ${_pick(_data.suffixes)}' : '';
      return (name: '$initial. $realFirst $surname$suffix', isStupid: false);
    }

    // --- STEP 4: NORMAL PATH ---
    final first  = _pick(firstNames);
    final middle = _buildMiddle();
    final suffix = _roll(kSuffixChance) ? ' ${_pick(_data.suffixes)}' : '';

    return (name: '$first$middle $surname$suffix', isStupid: false);
  }

  /// Builds the middle section: nothing, one initial, or two initials.
  String _buildMiddle() {
    if (!_roll(kMiddleInitialChance)) return '';
    final i1 = _pick(_data.middleInitials);
    if (_roll(kSecondMiddleChance)) {
      final i2 = _pick(_data.middleInitials);
      return ' $i1. $i2.';
    }
    return ' $i1.';
  }
}