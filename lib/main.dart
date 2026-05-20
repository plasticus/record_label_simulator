import 'package:flutter/material.dart';
import 'gen/band_generator.dart';
import 'gen/band_gen_complex.dart';
import 'gen/screen_band_gen_complex.dart';
import 'gen/name_loader.dart';

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

            // --- Button 1: Basic Generator ---
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GeneratorScreen()),
                );
              },
              icon: const Icon(Icons.music_note, color: Colors.black),
              label: const Text(
                'BAND GENERATOR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Genre-based roster generator',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),

            const SizedBox(height: 40),

            // --- Button 2: Complex Generator (placeholder) ---
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
          ],
        ),
      ),
    );
  }
}



// ─── EXISTING GENERATOR SCREEN (unchanged) ──────────────────────────────────

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final BandGenerator _generator = BandGenerator();
  String _selectedGenre = 'Rock';
  List<BandMember> _currentLineup = [];

  @override
  void initState() {
    super.initState();
    _rollBand();
  }

  void _rollBand() {
    setState(() {
      _currentLineup = _generator.generateBand(_selectedGenre);
    });
  }

  @override
  Widget build(BuildContext context) {
    final genreInfo = _generator.genres[_selectedGenre];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎸 Band Roster Generator'),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFF1F1F1F),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Select a Musical Style:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedGenre,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  dropdownColor: const Color(0xFF2C2C2C),
                  items: _generator.genres.keys.map((String genre) {
                    return DropdownMenuItem<String>(
                      value: genre,
                      child: Text(genre, style: const TextStyle(fontWeight: FontWeight.w500)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() => _selectedGenre = newValue);
                      _rollBand();
                    }
                  },
                ),
                const SizedBox(height: 12),
                if (genreInfo != null) ...[
                  Text(
                    genreInfo.description,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white60,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Size Limits: ${genreInfo.minMembers} - ${genreInfo.maxMembers} members',
                    style: TextStyle(fontSize: 12, color: Colors.amber.withValues(alpha: 0.7)),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: _currentLineup.isEmpty
                ? const Center(child: Text('No members generated.'))
                : ListView.builder(
              itemCount: _currentLineup.length,
              itemBuilder: (context, index) {
                final member = _currentLineup[index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber.shade700,
                      foregroundColor: Colors.black,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      member.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        member.toString(),
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    trailing: const Icon(Icons.music_note, color: Colors.white24),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _rollBand,
              icon: const Icon(Icons.refresh, color: Colors.black),
              label: const Text(
                'ROLL NEW BAND',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}