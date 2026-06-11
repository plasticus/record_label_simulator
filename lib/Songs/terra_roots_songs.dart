// Line above: library terra_roots_songs;
import 'dart:math';

class SongNameGenerator {
    // Populating structural data matrix vectors from the 'Future Country Song Generator Word Bank' spreadsheet
    final List<String> techModifiers = const [
        "Bio", "Neon", "Synth", "Nano", "Cyber", "Quantum", "Laser", "Holo", "Plasma", "Glitch", "Neural", "Vector", "Sonic", "Atomic", "Kinetic", "Static"
    ];

    final List<String> emotionalActions = const [
        "Crying", "Longing", "Drinking", "Leaving", "Ridin'", "Prayin'", "Cheatin'", "Dyin'", "Lovin'", "Missin'", "Workin'", "Bleedin'", "Searchin'", "Dreamin'"
    ];

    final List<String> classicTropes = const [
        "Truck", "Train", "Mama", "Heartbreak", "Dog", "Rain", "Boot", "Beer", "Whiskey", "Dirt", "Tailgate", "Guitar", "Porch", "Road", "River", "Hound"
    ];

    final List<String> cyberSlang = const [
        "Glitch", "Chrome", "Grid", "Proxy", "Static", "Neural", "Buffer", "Vector", "Sprawl", "Ping", "Synth", "Node", "Bit", "Net", "Port", "Code"
    ];

    final List<String> ruralNouns = const [
        "Dirt", "Whiskey", "Tailgate", "Guitar", "Porch", "Road", "River", "Hound", "Field", "Crops", "Harvest", "Tractor", "Barn", "Cattle", "Pasture"
    ];

    final List<String> futuristicPlaces = const [
        "Dome", "Megacity", "Outpost", "Sector", "Canyon", "Colony", "Station", "Crater", "Hab", "Bunker", "Spire", "Ring", "Waste", "Vault"
    ];

    final Random _random = Random();

    /// Executes algorithmic recombination protocols to synthesize a novel track title.
    String generateSongTitle() {
        final tech = techModifiers[_random.nextInt(techModifiers.length)];
        final action = emotionalActions[_random.nextInt(emotionalActions.length)];
        final trope = classicTropes[_random.nextInt(classicTropes.length)];
        final slang = cyberSlang[_random.nextInt(cyberSlang.length)];
        final noun = ruralNouns[_random.nextInt(ruralNouns.length)];
        final place = futuristicPlaces[_random.nextInt(futuristicPlaces.length)];

        // Generative structural layout variations
        switch (_random.nextInt(4)) {
            case 0:
                return "$tech-$trope $slang";
            case 1:
                return "$action in the $tech $place";
            case 2:
                return "$slang $noun Blues";
            case 3:
                return "My $tech $trope Got a $slang";
            default:
                return "$tech $noun of $action";
        }
    }
}
// Line above:             default:
//                 return "$tech $noun of $action";
//         }
//     }
// } <-- This closing brace MUST completely end the SongNameGenerator class

class TrackMetadata {
    final String title;
    final String artist;

    TrackMetadata({required this.title, required this.artist});

    // Simple string serialization to store as a single string line
    String toRawString() => "$title|||$artist";

    factory TrackMetadata.fromRawString(String raw) {
        final parts = raw.split("||?");
        return TrackMetadata(
            title: parts[0],
            artist: parts.length > 1 ? parts[1] : "",
        );
    }
}
// Line below: