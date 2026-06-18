// Line above: // Top of file
import 'dart:math';

class SongNameGenerator {
    // 50 Sci-Fi and cybernetic prefixes
    final List<String> techModifiers = const [
        "Bio", "Neon", "Synth", "Nano", "Cyber", "Quantum", "Laser", "Holo", "Plasma", "Glitch",
        "Neural", "Vector", "Sonic", "Atomic", "Kinetic", "Static", "Warp", "Pulsar", "Solar", "Lunar",
        "Neutron", "Proton", "Graviton", "Magneto", "Thermo", "Hydro", "Aero", "Exo", "Macro", "Micro",
        "Chrono", "Optic", "Spectral", "Cosmic", "Astral", "Helix", "Matrix", "Proxy", "Node", "Grid",
        "Signal", "Frequency", "Overdrive", "Bitcrush", "Subwoof", "Binary", "Digital", "Virtual", "Alloy", "Carbon"
    ];

    // 50 Heartbroken and blue-collar country actions
    final List<String> emotionalActions = const [
        "Crying", "Longing", "Drinking", "Leaving", "Ridin'", "Prayin'", "Cheatin'", "Dyin'", "Lovin'", "Missin'",
        "Workin'", "Bleedin'", "Searchin'", "Dreamin'", "Yearnin'", "Stumblin'", "Gamblin'", "Hustlin'", "Roamin'", "Driftin'",
        "Grievin'", "Weepin'", "Toilin'", "Sweatin'", "Ploddin'", "Sufferin'", "Hopin'", "Fleein'", "Trudgin'", "Singin'",
        "Strummin'", "Howlin'", "Whisperin'", "Growlin'", "Chasin'", "Runnin'", "Fallin'", "Burnin'", "Drownin'", "Starvin'",
        "Beggin'", "Pleadin'", "Hidin'", "Leakin'", "Rustin'", "Sinkin'", "Fadin'", "Breakin'", "Fixin'", "Stallin'"
    ];

    // 50 Classic country song layout tropes
    final List<String> classicTropes = const [
        "Truck", "Train", "Mama", "Heartbreak", "Dog", "Rain", "Boot", "Beer", "Whiskey", "Dirt",
        "Tailgate", "Guitar", "Porch", "Road", "River", "Hound", "Pickup", "Moonshine", "Tears", "Bible",
        "Flag", "Farm", "Barn", "Cattle", "Tractor", "Harvest", "Field", "Pasture", "Fence", "Saddle",
        "Spur", "Hat", "Jeans", "Radio", "Highway", "Tracks", "Station", "Bridge", "Valley", "Mountain",
        "Creek", "Swamp", "Cabin", "Shack", "Stove", "Rocking-Chair", "Lantern", "Clock", "Picture", "Letter"
    ];

    // 50 Tech-slang terms from the cyberpunk underworld
    final List<String> cyberSlang = const [
        "Glitch", "Chrome", "Grid", "Proxy", "Static", "Neural", "Buffer", "Vector", "Sprawl", "Ping",
        "Synth", "Node", "Bit", "Net", "Port", "Code", "Link", "Feed", "Data", "Core",
        "Chip", "Deck", "Jack", "Ram", "Byte", "Bug", "Patch", "Mod", "Hack", "Crack",
        "Script", "Bot", "Drone", "Scan", "Trace", "Leak", "Bleed", "Crash", "Freeze", "Wipe",
        "Loop", "Shift", "Sync", "Load", "Dump", "Kill", "Boot", "Void", "Apex", "Matrix"
    ];

    // 50 Traditional rural and agrarian objects
    final List<String> ruralNouns = const [
        "Dirt", "Whiskey", "Tailgate", "Guitar", "Porch", "Road", "River", "Hound", "Field", "Crops",
        "Harvest", "Tractor", "Barn", "Cattle", "Pasture", "Hay", "Seed", "Plow", "Soil", "Dust",
        "Clay", "Mud", "Stone", "Rock", "Stump", "Tree", "Wood", "Timber", "Log", "Branch",
        "Leaf", "Grass", "Weed", "Grain", "Wheat", "Corn", "Barley", "Rye", "Flour", "Bread",
        "Meat", "Bone", "Skin", "Hide", "Horn", "Hoof", "Tail", "Feather", "Nest", "Egg"
    ];

    // 50 Futuristic settings and regional territories
    final List<String> futuristicPlaces = const [
        "Dome", "Megacity", "Outpost", "Sector", "Canyon", "Colony", "Station", "Crater", "Hab", "Bunker",
        "Spire", "Ring", "Waste", "Vault", "Quadrant", "Zone", "District", "Block", "Ward", "Hub",
        "Terminal", "Port", "Dock", "Bay", "Hangar", "Lab", "Array", "Facility", "Plant", "Refinery",
        "Foundry", "Forge", "Mine", "Quarry", "Silo", "Depot", "Warehouse", "Complex", "Compound", "Citadel",
        "Tower", "Platform", "Bridge", "Tunnel", "Pipeline", "Grid-Line", "Orbit", "Rift", "Void", "Abyss"
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

class TrackMetadata {
    final String title;
    final String artist;

    TrackMetadata({required this.title, required this.artist});

    // Simple string serialization to store as a single string line
    String toRawString() => "$title|||$artist";

    factory TrackMetadata.fromRawString(String raw) {
        // Escaped string literal pattern splitting on the actual storage delimiter
        final parts = raw.split(r"|||");
        return TrackMetadata(
            title: parts[0],
            artist: parts.length > 1 ? parts[1] : "",
        );
    }
}
// Line below: // End of file