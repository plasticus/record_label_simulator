// Line above: // Top of file
import 'package:flutter/material.dart'; // This line right here prevents all 64 errors!
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
  String _currentTrackTitle = "SYSTEM INITIALIZED // NO TRACK SELECTED";
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
      appBar: AppBar(
        title: const Text('📻 TerraRoots Jukebox'),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'NOW STREAMING FROM THE OUTLANDS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white38,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _hasSpun ? Colors.greenAccent : Colors.white10,
                  width: 1.5,
                ),
                boxShadow: _hasSpun ? [
                  BoxShadow(
                    color: Colors.greenAccent.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ] : null,
              ),
              child: Column(
                children: [
                  Text(
                    _currentTrackTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _hasSpun ? Colors.greenAccent : Colors.white54,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontFamily: 'monospace',
                    ),
                  ),
                  if (_hasSpun) ...[
                    const SizedBox(height: 12),
                    Text(
                      _currentArtist,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 48),

            ElevatedButton.icon(
              onPressed: _spinJukebox,
              icon: const Icon(Icons.refresh, color: Colors.black),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'RETURN TO HUB',
                style: TextStyle(
                  color: Colors.white38,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Line below: // End of file