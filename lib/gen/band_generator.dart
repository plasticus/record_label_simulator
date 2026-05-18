// lib/gen/band_generator.dart
import 'dart:math';
import 'word_banks.dart';

class BandMember {
  final String name;
  final String gender;

  BandMember({required this.name, required this.gender});
}

class Band {
  final String name;
  final String genre;
  final List<BandMember> members;

  Band({
    required this.name,
    required this.genre,
    required this.members,
  });
}

class BandGenerator {
  static final Random _random = Random();

  static String _getRandomWord(String key) {
    final list = wordBanks[key];
    if (list == null || list.isEmpty) return '[$key]';
    return list[_random.nextInt(list.length)];
  }

  static BandMember _generateHumanName() {
    bool isMale = _random.nextBool();

    String first = isMale
        ? maleFirstNames[_random.nextInt(maleFirstNames.length)]
        : femaleFirstNames[_random.nextInt(femaleFirstNames.length)];

    String last = surnames[_random.nextInt(surnames.length)];

    return BandMember(name: '$first $last', gender: isMale ? 'M' : 'F');
  }

  static Band generateBand() {
    final genreMap = genresData[_random.nextInt(genresData.length)];
    String selectedGenre = genreMap['Genre'] as String;

    int minM = genreMap['minMembers'] as int;
    int maxM = genreMap['maxMembers'] as int;

    int memberCount = minM + _random.nextInt((maxM - minM) + 1);

    List<BandMember> members = [];
    for (int i = 0; i < memberCount; i++) {
      members.add(_generateHumanName());
    }

    String finalBandName = '';

    // RULE: If it's a solo artist, 75% chance they just use their human name
    if (memberCount == 1 && _random.nextDouble() < 0.75) {
      finalBandName = members.first.name;
    } else {
      // FLATTENED PROBABILITY: Every formula has an exact equal chance
      String formula = bandPatterns[_random.nextInt(bandPatterns.length)];
      finalBandName = formula;

      if (formula.startsWith('[Acronym:')) {
        String w1 = _getRandomWord('Noun');
        String w2 = _getRandomWord('Noun');
        String w3 = _getRandomWord('Noun');

        String acronym = '${w1[0]}${w2[0]}${w3[0]}'.toUpperCase();
        finalBandName = '$acronym ($w1 $w2 $w3)';

      } else if (formula == '[First_Syllable][Second_Syllable]') {
        // Explicitly stitch the syllables together so the loop doesn't get its tail twisted
        String first = _getRandomWord('First_Syllable');
        String second = _getRandomWord('Second_Syllable');

        // Combine them and make sure it has a proper capital letter on front
        String combined = '${first.toLowerCase()}$second';
        finalBandName = combined[0].toUpperCase() + combined.substring(1);

      } else {
        // Run standard loop over tags for all other flat templates
        for (String key in wordBanks.keys) {
          String targetTag = '[$key]';
          while (finalBandName.contains(targetTag)) {
            finalBandName = finalBandName.replaceFirst(targetTag, _getRandomWord(key));
          }
        }
      }
    } // <--- Sweet molasses, this is the bracket that was missing!

    return Band(
        name: finalBandName,
        genre: selectedGenre,
        members: members
    );
  }
}