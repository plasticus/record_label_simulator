import 'dart:math';
import 'package:flutter/services.dart';

// ─── APP DATA ────────────────────────────────────────────────────────────────

class AppData {
  // Human name data
  final List<String> maleFirst;
  final List<String> femaleFirst;
  final List<String> middleInitials;
  final List<String> surnames;
  final List<String> suffixes;
  final List<String> stupidMale;
  final List<String> stupidFemale;

  // Combinatorial surname parts
  final List<String> cPrefixes;
  final List<String> cRoots;
  final List<String> cSuffixes;

  // Band name word banks
  final List<String> adjectives;
  final List<String> nouns;
  final List<String> nounsPlural;
  final List<String> gerundVerbs;
  final List<String> verbs;
  final List<String> prepositions;
  final List<String> articles;
  final List<String> colors;
  final List<String> humanNames;
  final List<String> adverbPlace;
  final List<String> adverbs;

  const AppData({
    required this.maleFirst,
    required this.femaleFirst,
    required this.middleInitials,
    required this.surnames,
    required this.suffixes,
    required this.stupidMale,
    required this.stupidFemale,
    required this.cPrefixes,
    required this.cRoots,
    required this.cSuffixes,
    required this.adjectives,
    required this.nouns,
    required this.nounsPlural,
    required this.gerundVerbs,
    required this.verbs,
    required this.prepositions,
    required this.articles,
    required this.colors,
    required this.humanNames,
    required this.adverbPlace,
    required this.adverbs,
  });

  /// Looks up a word bank by the token name used in bandPatterns.
  List<String> wordBank(String token) {
    switch (token) {
      case 'Adjective':    return adjectives;
      case 'Noun':         return nouns;
      case 'Noun_Plural':  return nounsPlural;
      case 'Gerund_Verb':  return gerundVerbs;
      case 'Verb':         return verbs;
      case 'Preposition':  return prepositions;
      case 'Article':      return articles;
      case 'Color':        return colors;
      case 'Human_Name':   return humanNames;
      case 'Adverb_Place': return adverbPlace;
      case 'Adverb':       return adverbs;
      case 'Number':       return adjectives; // Numbers live in Adjectives column
      default:             return [];
    }
  }
}

// ─── ASSET LOADER ────────────────────────────────────────────────────────────

class AssetLoader {
  static AppData? _cache;

  /// Call once at app startup. Returns cached data on subsequent calls.
  static Future<AppData> load() async {
    if (_cache != null) return _cache!;

    final nameData = await _loadCsv('assets/data/human_name_gen_data.csv');
    final bandData = await _loadCsv('assets/data/band_name_gen_data.csv');

    _cache = AppData(
      // ── Human names ──
      maleFirst:      _col(nameData, 'MFirst'),
      femaleFirst:    _col(nameData, 'FFirst'),
      middleInitials: _col(nameData, 'Middle'),
      surnames:       _col(nameData, 'Surname'),
      suffixes:       _col(nameData, 'Suffix'),
      stupidMale:     _col(nameData, 'StupidM'),
      stupidFemale:   _col(nameData, 'StupidF'),

      // ── Combinatorial surname parts ──
      cPrefixes: _col(nameData, 'c_prefix'),
      cRoots:    _col(nameData, 'c_root'),
      cSuffixes: _col(nameData, 'c_suffix'),

      // ── Band name words ──
      adjectives:   _col(bandData, 'Adjectives'),
      nouns:        _col(bandData, 'Nouns'),
      nounsPlural:  _col(bandData, 'Nouns_Plural'),
      gerundVerbs:  _col(bandData, 'Gerund_Verbs'),
      verbs:        _col(bandData, 'Verbs'),
      prepositions: _col(bandData, 'Prepositions'),
      articles:     _col(bandData, 'Articles'),
      colors:       _col(bandData, 'Colors'),
      humanNames:   _col(bandData, 'Human_Names'),
      adverbPlace:  _col(bandData, 'adverb_place'),
      adverbs:      _col(bandData, 'adverb'),
    );

    return _cache!;
  }

  static Future<List<Map<String, String>>> _loadCsv(String path) async {
    final raw = await rootBundle.loadString(path);
    final lines = raw.trim().split('\n');
    if (lines.isEmpty) return [];

    final headers = lines.first.split(',').map((h) => h.trim()).toList();
    final rows = <Map<String, String>>[];

    for (final line in lines.skip(1)) {
      if (line.trim().isEmpty) continue;
      final cols = line.split(',').map((c) => c.trim()).toList();
      final row = <String, String>{};
      for (int i = 0; i < headers.length && i < cols.length; i++) {
        row[headers[i]] = cols[i];
      }
      rows.add(row);
    }

    return rows;
  }

  static List<String> _col(List<Map<String, String>> rows, String column) {
    return rows
        .map((r) => r[column] ?? '')
        .where((v) => v.isNotEmpty && v != 'nan' && v != 'NaN')
        .toList();
  }
}

// ─── NAME GENERATION CONSTANTS ───────────────────────────────────────────────
// All percentages out of 100. Adjust freely here.

const int kMiddleInitialChance = 10;  // % chance of a middle initial
const int kSecondMiddleChance  = 10;  // % chance of 2nd initial (of those with 1st)
const int kStupidNameChance    = 1;   // % chance first name is a stupid name
const int kSuffixChance        = 10;  // % chance of suffix (Jr., Sr., II, III)
const int kInitialFirstChance  = 1;   // % chance of "P. Tommy Wahls" style
const int kAllInitialsChance   = 1;   // % chance of "L. R. Bubbard" style

// ─── NAME GENERATOR ──────────────────────────────────────────────────────────

class NameGenerator {
  final Random _random = Random();
  final AppData _data;

  NameGenerator(this._data);

  bool _roll(int chance) => _random.nextInt(100) < chance;
  String _pick(List<String> list) => list[_random.nextInt(list.length)];

  ({String name, bool isStupid}) generate({required bool isMale}) {
    final firstNames  = isMale ? _data.maleFirst  : _data.femaleFirst;
    final stupidNames = isMale ? _data.stupidMale : _data.stupidFemale;
    final surname     = _pick(_data.surnames);

    // --- STEP 1: STUPID NAME (wins over all initials) ---
    if (_roll(kStupidNameChance)) {
      final stupid = _pick(stupidNames);
      final middle = _buildMiddle();
      final suffix = _roll(kSuffixChance) ? ' ${_pick(_data.suffixes)}' : '';
      return (name: '$stupid$middle $surname$suffix', isStupid: true);
    }

    // --- STEP 2: ALL INITIALS — L. R. Bubbard ---
    if (_roll(kAllInitialsChance)) {
      final i1 = _pick(_data.middleInitials);
      final i2 = _pick(_data.middleInitials);
      final suffix = _roll(kSuffixChance) ? ' ${_pick(_data.suffixes)}' : '';
      return (name: '$i1. $i2. $surname$suffix', isStupid: false);
    }

    // --- STEP 3: INITIAL FIRST — P. Tommy Wahls ---
    if (_roll(kInitialFirstChance)) {
      final initial   = _pick(_data.middleInitials);
      final realFirst = _pick(firstNames);
      final suffix    = _roll(kSuffixChance) ? ' ${_pick(_data.suffixes)}' : '';
      return (name: '$initial. $realFirst $surname$suffix', isStupid: false);
    }

    // --- STEP 4: NORMAL ---
    final first  = _pick(firstNames);
    final middle = _buildMiddle();
    final suffix = _roll(kSuffixChance) ? ' ${_pick(_data.suffixes)}' : '';
    return (name: '$first$middle $surname$suffix', isStupid: false);
  }

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