import 'package:flutter/material.dart';
import 'gen/band_gen_complex.dart';
import 'gen/screen_band_gen_complex.dart';
import 'gen/screen_surname_test.dart';
import 'gen/screen_band_name_test.dart';

final complexGenerator = ComplexBandGenerator();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await complexGenerator.init();
  runApp(const BandGeneratorApp());
}

class BandGeneratorApp extends StatelessWidget {
  const BandGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Band Roster Generator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ─── HOME SCREEN — two generator buttons ────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎸 Band Roster Generator'),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose a Generator',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 40),

            // --- Button 1: Complex Generator ---
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ComplexGeneratorScreen(generator: complexGenerator)),
                );
              },
              icon: const Icon(Icons.tune, color: Colors.black),
              label: const Text(
                'COMPLEX BAND GEN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Coming soon',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),

            const SizedBox(height: 40),

            // --- Button 3: Surname Test ---
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SurnameTestScreen()),
                );
              },
              icon: const Icon(Icons.science, color: Colors.black),
              label: const Text(
                'SURNAME TEST',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '5 names per generation method',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),

            const SizedBox(height: 40),

            // --- Button 4: Band Name Test ---
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BandNameTestScreen(generator: complexGenerator)),
                );
              },
              icon: const Icon(Icons.album, color: Colors.black),
              label: const Text(
                'GEN 20 BAND NAMES',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pattern-based band name generator',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}