// Line above: // Top of file
import 'package:flutter/material.dart';
import 'terra_roots_songs.dart';
import '../gen/band_gen_complex.dart';

class TerraRootsJukeboxScreen extends StatefulWidget {
  final ComplexBandGenerator generator;

  const TerraRootsJukeboxScreen({super.key, required this.generator});

  @override
  State<TerraRootsJukeboxScreen> createState() => _TerraRootsJukeboxScreenState();
}

class _TerraRootsJukeboxScreenState extends State<TerraRootsJukeboxScreen> {
  final SongNameGenerator _songGenerator = SongNameGenerator();
  String _currentTrackTitle = "SYSTEM INITIALIZED\n// READY TO SPIN";
  String _currentArtist = "";
  bool _hasSpun = false;

  void _spinJukebox() {
    setState(() {
      _currentTrackTitle = _songGenerator.generateSongTitle().toUpperCase();

      // Pulling authentic pattern identities from your core asset generator
      final generatedBand = widget.generator.generate();
      _currentArtist = "BY: ${generatedBand.name.toUpperCase()}";

      _hasSpun = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LAYER 1: The High-Fidelity Retro-Future Jukebox Background Shell
          Positioned.fill(
            child: Image.asset(
              'assets/images/jukebox_background.png', // Ensure this matches your path in pubspec.yaml
              fit: BoxFit.cover,
            ),
          ),

          // Line above:           // LAYER 2: Semi-opaque scrim overlay to ensure UI elements stay highly readable
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),

          // LAYER 3: Dynamic CRT Monitor Screen Text Overlay
          Positioned(
            top: MediaQuery.of(context).size.height * 0.31, // Shifted from 0.295 to pull text perfectly down into the screen glass
            left: MediaQuery.of(context).size.width * 0.08,
            right: MediaQuery.of(context).size.width * 0.44,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Track Title String
                  Text(
                    _currentTrackTitle.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF33FF33), // Pure, vivid terminal green phosphor
                      fontSize: 19,
                      fontWeight: FontWeight.w800, // Extra heavy weight for that pixel-bleed effect
                      letterSpacing: 1.5,
                      fontFamily: 'monospace',
                      height: 1.25,
                      shadows: [
                        // Core inner glow layer
                        Shadow(
                          color: const Color(0xFF33FF33).withValues(alpha: 0.8),
                          blurRadius: 4,
                        ),
                        // Soft environmental ambient bloom layer
                        Shadow(
                          color: const Color(0xFF00FF00).withValues(alpha: 0.4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  if (_hasSpun) ...[
                    const SizedBox(height: 12),
                    // Artist / Band Metadata String
                    Text(
                      _currentArtist.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFFFB000), // Vintage industrial monochrome amber
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0, // Wider tracking for tactical metadata appearance
                        fontFamily: 'monospace',
                        height: 1.3,
                        shadows: [
                          Shadow(
                            color: const Color(0xFFFFB000).withValues(alpha: 0.7),
                            blurRadius: 3,
                          ),
                          Shadow(
                            color: Colors.orange.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // LAYER 4: Tactical Interactive Control Hub
          Positioned(
            bottom: 40,
            left: 32,
            right: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Synthesize Action Node
                ElevatedButton.icon(
                  onPressed: _spinJukebox,
                  icon: const Icon(Icons.bolt, color: Colors.black),
                  label: const Text(
                    'SYNTHESIZE NEW TRACK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 8,
                    shadowColor: Colors.greenAccent.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Return Navigation Element
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black54,
                  ),
                  child: const Text(
                    'RETURN TO HUB',
                    style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// Line below: // End of file