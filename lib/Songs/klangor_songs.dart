// Line above: // Top of file
import 'dart:math';

class KlangorGenerator {
  // 50 Heavy brass weapons / orchestral artillery items
  final List<String> brassWeapons = const [
    "Das Plasma-Horn", "Die Titan-Tuba", "Der Doom-Posaunenchor", "Die Cyber-Trumpet", "Das Blast-Saxophon",
    "Die Brass-Artillerie", "Der Overdrive-Flügelhorn", "Die Reaktor-Oboe", "Das Megawatt-Cornet", "Der Giga-Helikon",
    "Die Schall-Fanfare", "Das Quantum-Mundstück", "Die Echo-Klarinette", "Der Laser-Symphoniker", "Die Schwerkraft-Flöte",
    "Das Warp-Fagott", "Die Neutronen-Trompete", "Der Pulsar-Posaunist", "Das Dynamo-Euphonium", "Die Kometen-Cornuse",
    "Das Void-Alphorn", "Die Solar-Pfeife", "Der Magma-Subbass", "Das Hydro-Bugle", "Die Eisen-Melodie",
    "Das Carbon-Cello", "Die Frequenz-Violine", "Der Matrix-Flötist", "Das Bitcrush-Keyboard", "Die Hybrid-Harfe",
    "Das Mecha-Orchester", "Die Ether-Symphonie", "Der Synth-Dirigent", "Das Gravitations-Zymbal", "Die Antimaterie-Glocke",
    "Der Blei-Gong", "Das Wolfram-Xylophon", "Die Stahl-Marimba", "Das Dynamo-Chroma", "Der Apex-Akzent",
    "Die Blitz-Pauke", "Der Terror-Takt", "Das Donner-Blech", "Die Sturm-Trommel", "Der Inferno-Beat",
    "Das Chaos-Schlagzeug", "Die Cybernetic-Harmonie", "Das Exo-Riff", "Der Titanen-Akkord", "Die Endzeit-Hymne"
  ];

  // 50 Industrial subjects / cybernetic entities
  final List<String> industrialSubjects = const [
    "Der Void-Kaiser", "Die Krupp-Drone", "Das Cyber-Subsystem", "Der Reactor-King", "Die Laser-Axe",
    "Der Overdrive-Klang", "Das Schrott-Monster", "Der Titan-Cyborg", "Die Plasma-Bestie", "Der Giga-Mechanismus",
    "Das Neon-Skelett", "Der Quantum-Goliath", "Die Carbon-Maschine", "Der Diesel-Krieger", "Das Klon-Imperium",
    "Der Matrix-Avatar", "Die Omega-Kreatur", "Der Apex-Präsident", "Das Androiden-Zentralorgan", "Der Hybrid-Rebell",
    "Die Dynamo-Gottheit", "Der Warp-Aufseher", "Das Hydro-Aggregat", "Der Solar-Gladiator", "Die Thermo-Einheit",
    "Der Magma-Titan", "Das Schwerkraft-Glied", "Der Orbital-Kommandant", "Die Cybernetic-Waffe", "Der Nano-Schwarm",
    "Das Vector-Subjekt", "Der Static-Dämon", "Die Glitch-Garde", "Der Buffer-Boss", "Die Proxy-Sekte",
    "Das Eisen-Monstrum", "Der Stahl-Soldat", "Die Blei-Brigade", "Der Kupfer-Klon", "Das Legierungs-Modell",
    "Der Radium-Ritter", "Die Cobalt-Königin", "Der Uran-Zar", "Das Plutonium-Phantom", "Der Asche-Geist",
    "Die Ruinen-Ratte", "Der Rost-Vagabund", "Das Schlamm-Konstrukt", "Der Ölsand-Golem", "Der Fabrik-Fürst"
  ];

  // 50 Strong verbs for the structural Position-2 slot
  final List<String> verbsPosition2 = const [
    "schmettert", "zerquetscht", "dröhnt", "bricht", "schweißt",
    "hämmert", "frisst", "zerschlägt", "verbrennt", "spaltet",
    "schmilzt", "zerreißt", "durchbohrt", "erwürgt", "schleift",
    "peitscht", "jagt", "stürzt", "blockiert", "infiziert",
    "löscht", "zündet", "pumpt", "dreht", "fräst",
    "stanzt", "biegt", "gießt", "schüttelt", "rammt",
    "treibt", "schlitzt", "würgt", "bläst", "saugt",
    "filtert", "lädt", "entlädt", "speichert", "strömt",
    "kocht", "friert", "dampft", "knallt", "blitzt",
    "donnert", "bebt", "hallt", "vibriert", "resoniert"
  ];

  // 50 Targets / direct objects of destruction
  final List<String> metalObjects = const [
    "den Orbit", "das Empire", "die Neon-Night", "den Cyberspace", "the Wasteland",
    "die Death-Zone", "das Vakuum", "die Endzeit", "den Reaktor Core", "die Grid-Pipeline",
    "den Mainframe", "die Cloud-City", "das Core-Data", "den Klon-Sektor", "die Bunker-Mauer",
    "den Fabrik-Bezirk", "das Slum-Viertel", "die Mega-Mall", "den Highway-Grid", "die Neon-Street",
    "den Plasma-Schild", "das Laser-Netz", "die Dynamo-Station", "den Solar-Turm", "die Quantum-Bank",
    "den Gen-Pool", "das Bio-Labor", "die Hydro-Farm", "den Kometen-Krater", "den Asteroiden-Gürtel",
    "den Tiefsee-Graben", "die Wüsten-Festung", "den Eis-Palast", "das Dschungel-Zentrum", "den Sumpf-Sektor",
    "die Ruinen-Stadt", "den Schrott-Platz", "das Giftmüll-Lager", "die Asche-Wüste", "den Lava-See",
    "das Schwerkraft-Feld", "den Zeit-Tunnel", "das Dimensions-Tor", "die Parallel-Welt", "den Alptraum",
    "die Illusion", "die Realität", "das Bewusstsein", "die Menschheit", "die Galaxis"
  ];

  // 50 Separable prefixes / secondary action elements for the terminal slot
  final List<String> terminalPrefixes = const [
    "nieder", "auf", "fort", "unter", "down",
    "out", "away", "off", "up", "zusammen",
    "aus", "ein", "ab", "an", "durch",
    "um", "vor", "nach", "zu", "weg",
    "mit", "her", "hin", "über", "entgegen",
    "vorbei", "zurück", "voraus", "entlang", "herauf",
    "herab", "herein", "heraus", "hinauf", "hinab",
    "hinein", "hinaus", "empor", "entzwei", "fehl",
    "fest", "frei", "los", "voll", "wieder",
    "wider", "back", "into", "through", "over"
  ];

  final Random _random = Random();

  /// Synthesizes a Klangor track title utilizing a multilingual smash within Germanic syntax.
  String generateKlangorTitle() {
    final brass = brassWeapons[_random.nextInt(brassWeapons.length)];
    final subject = industrialSubjects[_random.nextInt(industrialSubjects.length)];
    final verb = verbsPosition2[_random.nextInt(verbsPosition2.length)];
    final object = metalObjects[_random.nextInt(metalObjects.length)];
    final prefix = terminalPrefixes[_random.nextInt(terminalPrefixes.length)];

    // Algorithmic variations adhering strictly to German syntax matrices
    switch (_random.nextInt(4)) {
      case 0:
        return "$subject $verb $object";
      case 1:
        return "$brass $verb $prefix";
      case 2:
        return "${_capitalizeFirst(object)} $verb $brass";
      case 3:
        return "$brass $verb $object $prefix";
      default:
        return "HAIL TO $subject";
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
// Line below: // End of KlangorGenerator class