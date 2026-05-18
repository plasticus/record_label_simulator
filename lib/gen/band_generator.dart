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

    // Explicitly cast these as integers!
    int minM = genreMap['minMembers'] as int;
    int maxM = genreMap['maxMembers'] as int;

    int memberCount = minM + _random.nextInt((maxM - minM) + 1);

    List<BandMember> members = [];
    for (int i = 0; i < memberCount; i++) {
      members.add(_generateHumanName());
    }

    int totalWeight = bandPatterns.fold(0, (sum, item) => sum + (item['weight'] as int));
    int roll = _random.nextInt(totalWeight);

    Map<String, dynamic> selectedPattern = bandPatterns.first;
    int currentSum = 0;
    for (var pattern in bandPatterns) {
      currentSum += pattern['weight'] as int;
      if (roll < currentSum) {
        selectedPattern = pattern;
        break;
      }
    }

    String formula = selectedPattern['formula'] as String;
    String finalBandName = formula;

    if (formula.startsWith('[Acronym:')) {
      String w1 = _getRandomWord('Noun');
      String w2 = _getRandomWord('Noun');
      String w3 = _getRandomWord('Noun');

      String acronym = '${w1[0]}${w2[0]}${w3[0]}'.toUpperCase();
      finalBandName = '$acronym ($w1 $w2 $w3)';

    } else if (formula.startsWith('[Slam:')) {
      String adj = _getRandomWord('Adjective');
      String noun = _getRandomWord('Noun_Plural');

      int cutAdj = (adj.length / 2).clamp(3, adj.length).toInt();
      int cutNoun = (noun.length / 2).clamp(2, noun.length).toInt();

      String front = adj.substring(0, cutAdj);
      String back = noun.substring(noun.length - cutNoun);
      String slammed = '$front$back'.toLowerCase();

      slammed = slammed[0].toUpperCase() + slammed.substring(1);
      finalBandName = 'The $slammed';

    } else {
      for (String key in wordBanks.keys) {
        String targetTag = '[$key]';
        while (finalBandName.contains(targetTag)) {
          finalBandName = finalBandName.replaceFirst(targetTag, _getRandomWord(key));
        }
      }
    }

    return Band(
        name: finalBandName,
        genre: selectedGenre,
        members: members
    );
  }
}