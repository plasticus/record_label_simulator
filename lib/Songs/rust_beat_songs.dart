// Line above: // Top of file
import 'dart:math';

class RustBeatGenerator {
  // 50 Gritty, distorted mechanical and audio gear components
  final List<String> garageGear = const [
    "Fuzz-Box", "Tube-Amp", "Piston", "Overdrive", "Sprocket",
    "Rotor", "Flywheel", "Manifold", "Gears", "Crankshaft",
    "Turbine", "Exhaust", "Carburetor", "Spark-Plug", "Alternator",
    "Distributor", "Gasket", "Clutch-Plate", "Camshaft", "Radiator",
    "Fuel-Pump", "Ignition", "Choke-Valve", "Transaxle", "Differential",
    "Suspension", "Shock-Absorber", "Brake-Pad", "Drive-Shaft", "Flyweight",
    "Governor", "Actuator", "Solenoid", "Relay-Switch", "Fuse-Block",
    "Capacitor", "Resistor", "Transformer", "Oscillator", "Pickup-Coil",
    "Tremolo-Arm", "Wah-Pedal", "Pre-Amp", "Speaker-Cone", "Sub-Woofer",
    "Mixing-Board", "Tape-Head", "Phono-Needle", "Tone-Arm", "Reverb-Tank"
  ];

  // 50 Raw textures of grime, industrial decay, and survival
  final List<String> industrialTextures = const [
    "Rusty", "Corroded", "Scrap", "Oil-Slick", "Junk-Yard",
    "Diesel", "Chrome-Flake", "Greasy", "Oxidized", "Copper",
    "Gravel", "Slag", "Tarnished", "Weathered", "Dent-Marked",
    "Smudged", "Sooty", "Charred", "Scuffed", "Scratched",
    "Battered", "Bruised", "Fractured", "Splintered", "Eroded",
    "Decayed", "Mouldered", "Blistered", "Peeling", "Faded",
    "Bleached", "Stained", "Muddy", "Gritty", "Dusty",
    "Sandy", "Silty", "Crusted", "Scaly", "Flaking",
    "Chipped", "Warped", "Leaking", "Dripping", "Oozing",
    "Slimy", "Gunk-Caked", "Tar-Coated", "Carbon-Scraped", "Lead-Weighted"
  ];

  // 50 High-friction, high-velocity rock actions
  final List<String> rockActions = const [
    "Stompin'", "Rattlin'", "Grindin'", "Screamin'", "Pumpin'",
    "Crashin'", "Smashin'", "Burnout", "Clankin'", "Rebelling",
    "Howlin'", "Shakin'", "Thumpin'", "Chuggin'", "Pounding",
    "Slammin'", "Bangin'", "Rippin'", "Tearin'", "Shreddin'",
    "Blasting", "Roaring", "Rumbling", "Quaking", "Rockin'",
    "Rolling", "Shuffling", "Grooving", "Cruising", "Drifting",
    "Skidding", "Spinning", "Wrecking", "Smashing", "Crushing",
    "Breaking", "Bending", "Twisting", "Tearing", "Splitting",
    "Stripping", "Chewing", "Biting", "Clawin'", "Diggin'",
    "Plowin'", "Pushin'", "Pullin'", "Haulin'", "Revvin'"
  ];

  // 50 Grimy environments and makeshift underground venues
  final List<String> greasyLocales = const [
    "Hangar-4", "Scrap-Heap", "Foundry", "Refinery", "Silo",
    "Alleyway", "Basement-Grid", "Dock-7", "Pit", "Forge",
    "Pipeline", "Terminal", "Garage-X", "Workshop", "Junkyard",
    "Saloon", "Tavern", "Outpost", "Bunker", "Tunnel",
    "Subway", "Warehouse", "Depot", "Station", "Yard",
    "Bay-12", "Vault", "Shed", "Cellar", "Attic",
    "Loft", "Studio", "Shack", "Cabin", "Camp",
    "Trench", "Mine-Shaft", "Quarry", "Excavation", "Dump-Site",
    "Drainpipe", "Sewer-Grid", "Catacomb", "Ruins", "Wreckage",
    "Debris-Field", "Salvage-Yard", "Breakwater", "Pier", "Wharf"
  ];

  // 50 Rebel, outlaw, and blue-collar mechanic personas
  final List<String> rebelTropes = const [
    "Vagabond", "Scrapper", "Renegade", "Stray-Dog", "Outlaw",
    "Mechanic", "Scavenger", "Grease-Monkey", "Drifter", "Riveter",
    "Welder", "Machinist", "Operator", "Driver", "Pilot",
    "Runner", "Smuggler", "Pirate", "Bandit", "Thief",
    "Hustler", "Gambler", "Rider", "Biker", "Trucker",
    "Stoker", "Fireman", "Engineer", "Artisan", "Smith",
    "Builder", "Crafter", "Tinkerer", "Hacker", "Coder",
    "Tech", "Goon", "Thug", "Enforcer", "Soldier",
    "Veteran", "Survivor", "Nomad", "Outcast", "Rebel",
    "Anarchist", "Mutineer", "Defiant", "Maverick", "Wildcard"
  ];

  final Random _random = Random();

  /// Fuses high-friction mechanical textures into raw garage-rock raw power.
  String generateRustBeatTitle() {
    final gear = garageGear[_random.nextInt(garageGear.length)];
    final texture = industrialTextures[_random.nextInt(industrialTextures.length)];
    final action = rockActions[_random.nextInt(rockActions.length)];
    final locale = greasyLocales[_random.nextInt(greasyLocales.length)];
    final rebel = rebelTropes[_random.nextInt(rebelTropes.length)];

    // Classic driving 3-chord garage rock title layouts
    switch (_random.nextInt(4)) {
      case 0:
        return "$texture $gear Anthem";
      case 1:
        return "$action Down at $locale";
      case 2:
        return "Ballad of the $texture $rebel";
      case 3:
        return "Got the $gear Blues Again";
      default:
        return "$texture $gear, $action Heart";
    }
  }
}
// Line below: // End of RustBeatGenerator class